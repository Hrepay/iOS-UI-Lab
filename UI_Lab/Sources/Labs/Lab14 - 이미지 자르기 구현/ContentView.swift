//
//  ContentView.swift
//  UI_Lab
//
//  Created by 황상환 on 11/22/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var originalImage: UIImage?
    @State private var croppedImage: UIImage?
    @State private var selectedItem: PhotosPickerItem?
    @State private var showCropView: Bool = false
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    if let croppedImage = croppedImage {
                        VStack {
                            Text("편집 완료")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Image(uiImage: croppedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 300)
                            .overlay(
                                VStack {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                    Text("이미지가 없습니다")
                                        .foregroundColor(.gray)
                                        .padding(.top, 5)
                                }
                            )
                            .cornerRadius(10)
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        HStack {
                            Image(systemName: "photo.fill")
                            Text("갤러리에서 사진 선택")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    // [수정] iOS 17+ 스타일의 onChange (파라미터 2개)
                    .onChange(of: selectedItem) { oldValue, newItem in
                        guard let newItem = newItem else { return }
                        isLoading = true
                        
                        Task {
                            do {
                                if let data = try? await newItem.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    
                                    await MainActor.run {
                                        self.originalImage = uiImage
                                        self.isLoading = false
                                        self.showCropView = true
                                        self.selectedItem = nil
                                    }
                                } else {
                                    await MainActor.run { self.isLoading = false }
                                }
                            } catch {
                                await MainActor.run { self.isLoading = false }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                if isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            VStack {
                                ProgressView().tint(.white).scaleEffect(1.5)
                                Text("이미지 불러오는 중...").foregroundColor(.white).padding(.top, 10)
                            }
                        )
                        .zIndex(1)
                }
            }
            .navigationTitle("인스타 스타일 크롭")
            .fullScreenCover(isPresented: $showCropView) {
                if let image = originalImage {
                    InstagramStyleCropView(image: image) { result in
                        self.croppedImage = result
                    }
                }
            }
        }
    }
}
