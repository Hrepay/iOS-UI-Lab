//
//  Album.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import Photos
import SwiftUI

// 앨범 정보를 담을 구조체
struct Album: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let count: Int
    let collection: PHAssetCollection
}

// 사진(PHAsset) 정보를 담을 구조체
struct Photo: Identifiable, Hashable {
    let id = UUID()
    let asset: PHAsset
}

// '앨범 목록' 화면으로의 이동을 나타내는 데이터 타입
enum PhotoNavigation: Hashable {
    case albumList
}
