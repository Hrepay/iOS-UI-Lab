//
//  PhotoGridItemView.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import SwiftUI
import Photos

struct PhotoGridItemView: View {
    @State private var thumbnail: UIImage?
    let photo: Photo
    let isSelected: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .clipped()
            } else {
                ProgressView()
            }

            if isSelected {
                // 선택되었을 때 표시
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.white)
                    .background(Circle().fill(.blue))
                    .padding(4)
            }
        }
        .onAppear(perform: loadThumbnail)
    }

    private func loadThumbnail() {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = false
        option.deliveryMode = .opportunistic
        option.resizeMode = .exact
        let targetSize = CGSize(width: 200, height: 200) 

        manager.requestImage(for: photo.asset, targetSize: targetSize, contentMode: .aspectFill, options: option) { image, _ in
            if let image = image {
                DispatchQueue.main.async {
                    self.thumbnail = image
                }
            }
        }
    }
}
