//
//  MainView.swift
//  UI_Lab
//
//  Created by 황상환 on 11/22/25.
//

import SwiftUI
import PhotosUI

struct MainView: View {
    // 갤러리 선택 상태 관리
    @State private var selectedItem: PhotosPickerItem? = nil
    
    // 편집기로 보낼 이미지
    @State private var imageToEdit: UIImage? = nil
    
    // 최종 완성된 이미지
    @State private var finalResultImage: UIImage? = nil
    
    // 화면 이동 플래그
    @State private var navigateToEditor = false
    
    var body: some View {
        // [변경 1] 네비게이션 스택으로 전체를 감쌉니다.
        NavigationStack {
            VStack(spacing: 30) {
                Text("나만의 누끼 메이커")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                // [결과 보여주는 영역]
                if let result = finalResultImage {
                    VStack {
                        Text("완성작 (회색 배경 위)")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        ZStack {
                            Color.gray
                            Image(uiImage: result)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(width: 240, height: 320)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 240, height: 320)
                        .overlay(Text("사진을 선택해주세요").foregroundColor(.gray))
                        .cornerRadius(12)
                }
                
                Spacer()
                
                // [갤러리 열기 버튼]
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("갤러리에서 사진 선택")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 50)
            }
            // [변경 2] onChange 로직
            .onChange(of: selectedItem) { oldValue, newItem in
                Task {
                    guard let item = newItem else { return }
                    
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        
                        // 이미지 자르기
                        let cropped = image.cropTo3to4()
                        
                        // 메인 스레드에서 상태 업데이트
                        await MainActor.run {
                            self.imageToEdit = cropped
                            // 여기서 0.1초만 줘도 NavigationStack은 잘 작동합니다.
                            self.navigateToEditor = true
                            print("네비게이션 이동 신호 보냄")
                        }
                    } else {
                        print("이미지 로드 실패")
                    }
                }
            }
            // [변경 3] fullScreenCover 대신 navigationDestination 사용
            .navigationDestination(isPresented: $navigateToEditor) {
                if let image = imageToEdit {
                    EraserEditorView(originalImage: image) { editedImage in
                        self.finalResultImage = editedImage
                    }
                    // [중요] 네비게이션 바 숨기기 (편집 화면을 넓게 쓰기 위해)
                    .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
