//
//  Lab5MainView.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import SwiftUI

struct Lab5MainView: View {
    @State private var showAlbumPicker = false
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State private var finalSelectedPhotos: [Photo] = []

    var body: some View {
        VStack {
            Button("앨범 열기") {
                showAlbumPicker = true
            }
            
            // 최종 선택된 사진들을 보여주는 뷰
            ScrollView(.horizontal) {
                HStack {
                    ForEach(finalSelectedPhotos) { photo in
                        PhotoGridItemView(
                            photo: photo,
                            isSelected: false
                        )
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .sheet(
            isPresented: $showAlbumPicker,
            onDismiss: {
                viewModel.selectedPhotos.removeAll()
            }
        ) {
            PhotoPickerContainerView(
                viewModel: viewModel,
                onComplete: {
                    self.finalSelectedPhotos = viewModel.selectedPhotos
                    showAlbumPicker = false
                },
                onCancel: {
                    showAlbumPicker = false
                }
            )
        }
    }
}

// 로딩 상태를 처리하고 PhotoGridView를 띄워주는 컨테이너 뷰
struct PhotoPickerContainerView: View {
    @ObservedObject var viewModel: PhotoPickerViewModel
    let onComplete: () -> Void // '완료' 클로저
    let onCancel: () -> Void   // '취소' 클로저
    
    @State private var recentsAlbum: Album?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Group {
                if let recentsAlbum = recentsAlbum {
                    // PhotoGridView로 클로저들을 전달
                    PhotoGridView(
                        viewModel: viewModel,
                        album: recentsAlbum,
                        isRootView: true,
                        onComplete: onComplete,
                        onCancel: onCancel
                    )
                } else {
                    ProgressView()
                }
            }
            .onAppear(perform: loadRecentsAlbum)
            .navigationDestination(for: Album.self) { album in
                // 다른 앨범으로 이동 시에도 클로저들을 전달
                PhotoGridView(
                    viewModel: viewModel,
                    album: album,
                    isRootView: false,
                    onComplete: onComplete,
                    onCancel: onCancel
                )
            }
            .navigationDestination(for: PhotoNavigation.self) { destination in
                if destination == .albumList {
                    AlbumListView(viewModel: viewModel)
                }
            }
        }
    }
    
    private func loadRecentsAlbum() {
        viewModel.checkPermissionAndFetchRecents { album in
            if let album = album {
                self.recentsAlbum = album
            } else {
                dismiss()
            }
        }
    }
}

#Preview {
    Lab5MainView()
}
