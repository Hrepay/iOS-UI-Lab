//
//  UIImage+Extensions.swift
//  UI_Lab
//
//  Created by 황상환 on 11/22/25.
//

import UIKit

extension UIImage {
    // 이미지를 3:4 비율로 중앙 크롭(Center Crop)하는 함수
    func cropTo3to4() -> UIImage {
        // 1. 현재 이미지의 크기
        let originalWidth = self.size.width
        let originalHeight = self.size.height
        
        // 2. 목표 비율 (3:4 = 0.75)
        let targetRatio: CGFloat = 3.0 / 4.0
        let currentRatio = originalWidth / originalHeight
        
        var newWidth: CGFloat
        var newHeight: CGFloat
        
        // 3. 크롭할 사각형 계산 (Aspect Fill 방식)
        if currentRatio > targetRatio {
            // 이미지가 너무 옆으로 뚱뚱함 -> 높이에 맞추고 양옆을 자름
            newHeight = originalHeight
            newWidth = newHeight * targetRatio
        } else {
            // 이미지가 너무 위아래로 길쭉함 -> 너비에 맞추고 위아래를 자름
            newWidth = originalWidth
            newHeight = newWidth / targetRatio
        }
        
        // 4. 중앙 좌표 계산
        let x = (originalWidth - newWidth) / 2.0
        let y = (originalHeight - newHeight) / 2.0
        let cropRect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        
        // 5. 이미지 자르기 (CGImage 레벨에서 처리)
        guard let cgImage = self.cgImage?.cropping(to: cropRect) else {
            return self
        }
        
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
