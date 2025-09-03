//
//  View+Renderer.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import SwiftUI

@MainActor
extension View {
    /// SwiftUI 뷰를 UIImage로 렌더링하는 함수
    func renderAsImage() -> UIImage? {
        let renderer = ImageRenderer(content: self)
        
        // 렌더러의 CGImage를 사용하여 UIImage를 생성
        return renderer.uiImage
    }
}
