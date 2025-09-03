//
//  PhotoGridView.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import SwiftUI

struct PhotoGridView: View {
    @ObservedObject var viewModel: PhotoPickerViewModel
    let album: Album
    var isRootView: Bool = false
    let onComplete: () -> Void // '완료' 클로저
    let onCancel: () -> Void   // '취소' 클로저

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(viewModel.photos) { photo in
                    PhotoGridItemView(
                        photo: photo,
                        isSelected: viewModel.selectedPhotos.contains(photo)
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .onTapGesture {
                        if let index = viewModel.selectedPhotos.firstIndex(of: photo) {
                            viewModel.selectedPhotos.remove(at: index)
                        } else {
                            viewModel.selectedPhotos.append(photo)
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if isRootView {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        onCancel() // '취소' 액션 호출
                    }
                }
                ToolbarItem(placement: .principal) {
                    NavigationLink(value: PhotoNavigation.albumList) {
                        HStack {
                            Text(album.name)
                            Image(systemName: "chevron.down").font(.caption)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                if !viewModel.selectedPhotos.isEmpty {
                    Button {
                        print("선택된 사진 수: \(viewModel.selectedPhotos.count)")
                        onComplete() // '완료' 액션 호출
                    } label: {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .bold()
                            .padding(6)
                            .background(Circle().fill(.blue))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            if !isRootView {
                viewModel.fetchPhotos(for: album)
            }
        }
        .onDisappear {
            if !isRootView {
                viewModel.photos.removeAll()
            }
        }
    }
}
