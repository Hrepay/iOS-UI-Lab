//
//  PhotoPickerViewModel.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import Photos
import SwiftUI

class PhotoPickerViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var photos: [Photo] = []
    @Published var selectedPhotos: [Photo] = []
    @Published var authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)

    func checkPermissionAndFetchRecents(completion: @escaping (Album?) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        let fetchBlock = {
            let recentsOptions = PHFetchOptions()
            guard let collection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: recentsOptions).firstObject else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            let recentsAlbum = Album(name: collection.localizedTitle ?? "Recents", count: assets.count, collection: collection)
            
            self.fetchPhotos(for: recentsAlbum)
            
            DispatchQueue.main.async {
                completion(recentsAlbum)
            }
        }

        if status == .authorized || status == .limited {
            fetchBlock()
        } else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                if newStatus == .authorized {
                    fetchBlock()
                } else {
                    DispatchQueue.main.async { completion(nil) }
                }
            }
        } else {
            DispatchQueue.main.async {
                // 권한이 거부된 경우
                completion(nil)
            }
        }
    }

    func fetchAlbums() {
        let options = PHFetchOptions()
        options.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        options.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]

        var fetchedAlbums: [Album] = []

        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        smartAlbums.enumerateObjects { collection, _, _ in
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            if assets.count > 0 {
                fetchedAlbums.append(Album(name: collection.localizedTitle ?? "Unknown", count: assets.count, collection: collection))
            }
        }

        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        userAlbums.enumerateObjects { collection, _, _ in
            let assets = PHAsset.fetchAssets(in: collection, options: nil)
            fetchedAlbums.append(Album(name: collection.localizedTitle ?? "Unknown", count: assets.count, collection: collection))
        }

        DispatchQueue.main.async {
            self.albums = fetchedAlbums.sorted { $0.name < $1.name }
        }
    }

    func fetchPhotos(for album: Album) {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let assets = PHAsset.fetchAssets(in: album.collection, options: options)
        var fetchedPhotos: [Photo] = []
        assets.enumerateObjects { asset, _, _ in
            fetchedPhotos.append(Photo(asset: asset))
        }

        DispatchQueue.main.async {
            self.photos = fetchedPhotos
        }
    }
}
