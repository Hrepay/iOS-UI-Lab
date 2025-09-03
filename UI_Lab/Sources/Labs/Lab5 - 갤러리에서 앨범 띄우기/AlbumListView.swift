//
//  AlbumListView.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import SwiftUI

struct AlbumListView: View {
    @ObservedObject var viewModel: PhotoPickerViewModel

    var body: some View {
        List(viewModel.albums) { album in
            NavigationLink(value: album) {
                HStack {
                    Text(album.name)
                    Spacer()
                    Text("\(album.count)")
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("앨범")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.albums.isEmpty {
                viewModel.fetchAlbums()
            }
        }
    }
}
