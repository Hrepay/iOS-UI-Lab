//
//  CustomCropView.swift
//  UI_Lab
//
//  Created by 황상환 on 11/22/25.
//

import SwiftUI

struct InstagramStyleCropView: View {
    let image: UIImage
    var onComplete: (UIImage) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: - 설정 상수
    private let fixedAspectRatio: CGFloat = 3.0 / 4.0
    private let minBoxWidth: CGFloat = 100
    private let boxPadding: CGFloat = 20
    
    // MARK: - 상태 변수
    @State private var imageScale: CGFloat = 1.0
    @State private var lastImageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var lastImageOffset: CGSize = .zero
    
    @State private var maxCropSize: CGSize = .zero
    @State private var currentCropSize: CGSize = .zero
    @State private var resizeOffset: CGSize = .zero
    
    // 떨림 방지용
    @State private var dragStartSize: CGSize = .zero
    @State private var dragStartLocation: CGPoint = .zero
    @State private var isResizing: Bool = false
    
    @State private var isViewInitialized = false
    
    // 화면 크기 저장용 (UIScreen 대체)
    @State private var containerSize: CGSize = .zero

    var body: some View {
        ZStack {
            // 1. 배경: 검은색으로 전체 화면 채움 (상태바 포함)
            Color.black.ignoresSafeArea()
            
            // 2. 컨텐츠: Safe Area를 준수하는 VStack
            VStack(spacing: 0) {
                // 상단 툴바
                HStack {
                    Button("취소") { dismiss() }
                        .foregroundColor(.white)
                    Spacer()
                    Text("3:4 비율 크롭")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Spacer()
                    Button("완료") {
                        if let cropped = cropImage() {
                            onComplete(cropped)
                            dismiss()
                        }
                    }
                    .foregroundColor(.yellow)
                    .fontWeight(.bold)
                }
                .padding(.horizontal) // 좌우 여백
                .padding(.top, 200)
                .frame(height: 44) // 높이 고정
                .background(Color.black) // 배경색
                .zIndex(1)

                // 메인 작업 영역 (이미지 + 크롭박스)
                GeometryReader { geometry in
                    ZStack {
                        Color.black
                        
                        // 이미지 레이어
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(imageScale)
                            .offset(imageOffset)
                            .gesture(
                                isResizing ? nil : SimultaneousGesture(
                                    MagnificationGesture()
                                        .onChanged { value in
                                            let delta = value / lastImageScale
                                            lastImageScale = value
                                            imageScale = max(imageScale * delta, 1.0)
                                        }
                                        .onEnded { _ in
                                            lastImageScale = 1.0
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                limitBounds()
                                            }
                                        },
                                    DragGesture()
                                        .onChanged { value in
                                            imageOffset = CGSize(
                                                width: lastImageOffset.width + value.translation.width,
                                                height: lastImageOffset.height + value.translation.height
                                            )
                                        }
                                        .onEnded { _ in
                                            lastImageOffset = imageOffset
                                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                                limitBounds()
                                            }
                                        }
                                )
                            )
                            .frame(width: geometry.size.width, height: geometry.size.height)
                        
                        // 마스크 및 크롭 박스
                        if isViewInitialized {
                            Rectangle()
                                .fill(Color.black.opacity(0.7))
                                .mask(
                                    ZStack {
                                        Rectangle().fill(Color.white)
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: currentCropSize.width, height: currentCropSize.height)
                                            .offset(resizeOffset)
                                            .blendMode(.destinationOut)
                                    }
                                    .compositingGroup()
                                )
                                .allowsHitTesting(false)
                            
                            ZStack {
                                CropBoxOverlay(size: currentCropSize)
                                cornerHandle(for: .topLeft)
                                cornerHandle(for: .topRight)
                                cornerHandle(for: .bottomLeft)
                                cornerHandle(for: .bottomRight)
                            }
                            .frame(width: currentCropSize.width, height: currentCropSize.height)
                            .offset(resizeOffset)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .coordinateSpace(name: "CROP_AREA")
                    .onAppear {
                        // 뷰가 나타나면 크기 측정 및 레이아웃 초기화
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.containerSize = geometry.size
                            initializeLayout(viewSize: geometry.size)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 로직 함수들 (UIScreen 완전 제거)
    
    private func initializeLayout(viewSize: CGSize) {
        let screenW = viewSize.width
        let screenH = viewSize.height
        
        var boxWidth = screenW - (boxPadding * 2)
        var boxHeight = boxWidth / fixedAspectRatio
        
        if boxHeight > screenH - 40 {
            boxHeight = screenH - 40
            boxWidth = boxHeight * fixedAspectRatio
        }
        
        let initialBoxSize = CGSize(width: boxWidth, height: boxHeight)
        
        let imageRatio = image.size.width / image.size.height
        let viewRatio = screenW / screenH
        
        var renderWidth: CGFloat
        var renderHeight: CGFloat
        if imageRatio > viewRatio {
            renderWidth = screenW
            renderHeight = screenW / imageRatio
        } else {
            renderHeight = screenH
            renderWidth = screenH * imageRatio
        }
        
        let widthScale = boxWidth / renderWidth
        let heightScale = boxHeight / renderHeight
        let neededScale = max(widthScale, heightScale)
        
        self.maxCropSize = initialBoxSize
        self.currentCropSize = initialBoxSize
        
        if neededScale > 1.0 {
            self.imageScale = neededScale
            self.lastImageScale = neededScale
        }
        
        self.isViewInitialized = true
    }
    
    private func cornerHandle(for corner: Corner) -> some View {
        Circle()
            .fill(Color.white)
            .frame(width: 30, height: 30)
            .shadow(radius: 2)
            .position(getPosition(for: corner, size: currentCropSize))
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("CROP_AREA"))
                    .onChanged { value in
                        if !isResizing {
                            isResizing = true
                            dragStartSize = currentCropSize
                            dragStartLocation = value.startLocation
                        }
                        handleResizeDrag(currentLocation: value.location, corner: corner)
                    }
                    .onEnded { _ in
                        isResizing = false
                        performSnapAnimation()
                    }
            )
    }
    
    enum Corner { case topLeft, topRight, bottomLeft, bottomRight }
    
    private func getPosition(for corner: Corner, size: CGSize) -> CGPoint {
        switch corner {
        case .topLeft: return CGPoint(x: 0, y: 0)
        case .topRight: return CGPoint(x: size.width, y: 0)
        case .bottomLeft: return CGPoint(x: 0, y: size.height)
        case .bottomRight: return CGPoint(x: size.width, y: size.height)
        }
    }
    
    private func handleResizeDrag(currentLocation: CGPoint, corner: Corner) {
        let deltaX = currentLocation.x - dragStartLocation.x
        var newWidth = dragStartSize.width
        
        switch corner {
        case .topLeft, .bottomLeft:
            newWidth -= deltaX
        case .topRight, .bottomRight:
            newWidth += deltaX
        }
        
        if newWidth < minBoxWidth { newWidth = minBoxWidth }
        if newWidth > maxCropSize.width { newWidth = maxCropSize.width }
        
        let newHeight = newWidth / fixedAspectRatio
        currentCropSize = CGSize(width: newWidth, height: newHeight)
        
        let widthDiff = currentCropSize.width - dragStartSize.width
        switch corner {
        case .topLeft:
            resizeOffset = CGSize(width: -widthDiff / 2, height: (-widthDiff / fixedAspectRatio) / 2)
        case .topRight:
            resizeOffset = CGSize(width: widthDiff / 2, height: (-widthDiff / fixedAspectRatio) / 2)
        case .bottomLeft:
            resizeOffset = CGSize(width: -widthDiff / 2, height: (widthDiff / fixedAspectRatio) / 2)
        case .bottomRight:
            resizeOffset = CGSize(width: widthDiff / 2, height: (widthDiff / fixedAspectRatio) / 2)
        }
    }
    
    private func performSnapAnimation() {
        let snapRatio = maxCropSize.width / currentCropSize.width
        guard snapRatio > 1.01 else {
            withAnimation {
                resizeOffset = .zero
                currentCropSize = maxCropSize
            }
            return
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            currentCropSize = maxCropSize
            imageScale *= snapRatio
            imageOffset.width = (imageOffset.width * snapRatio) - (resizeOffset.width * snapRatio)
            imageOffset.height = (imageOffset.height * snapRatio) - (resizeOffset.height * snapRatio)
            resizeOffset = .zero
            limitBounds()
            lastImageScale = 1.0
            lastImageOffset = imageOffset
        }
    }
    
    private func limitBounds() {
        guard isViewInitialized else { return }
        
        // [수정] 경고 원인이었던 UIScreen 제거. 저장된 containerSize 사용.
        // containerSize가 0이면 아직 초기화 전이므로 return
        if containerSize == .zero { return }
        
        let viewW = containerSize.width
        let viewH = containerSize.height
        
        let imageRatio = image.size.width / image.size.height
        
        var fitH = viewW / imageRatio
        if fitH > viewH { fitH = viewH }
        let fitW = fitH * imageRatio
        
        let scaledW = fitW * imageScale
        let scaledH = fitH * imageScale
        
        let maxOffX = max(0, (scaledW - maxCropSize.width) / 2)
        let maxOffY = max(0, (scaledH - maxCropSize.height) / 2)
        
        imageOffset.width = min(max(imageOffset.width, -maxOffX), maxOffX)
        imageOffset.height = min(max(imageOffset.height, -maxOffY), maxOffY)
        
        if imageScale < 1.0 {
            imageScale = 1.0
            imageOffset = .zero
        }
    }
    
    private func cropImage() -> UIImage? {
        guard isViewInitialized else { return nil }
        // [수정] 경고 원인이었던 UIScreen 제거
        if containerSize == .zero { return nil }
        
        let viewW = containerSize.width
        let renderScale = image.size.width / viewW
        
        let cropW = (maxCropSize.width * renderScale) / imageScale
        let cropH = (maxCropSize.height * renderScale) / imageScale
        let centerX = (image.size.width / 2) - (imageOffset.width * renderScale / imageScale)
        let centerY = (image.size.height / 2) - (imageOffset.height * renderScale / imageScale)
        let originX = centerX - (cropW / 2)
        let originY = centerY - (cropH / 2)
        let cropRect = CGRect(x: originX, y: originY, width: cropW, height: cropH)
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

// 그리드 라인 (유지)
struct CropBoxOverlay: View {
    let size: CGSize
    var body: some View {
        ZStack {
            Rectangle().stroke(Color.white, lineWidth: 1.5)
            VStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color.white.opacity(0.7)).frame(height: 1).shadow(color: .black.opacity(0.3), radius: 1)
                Spacer()
                Rectangle().fill(Color.white.opacity(0.7)).frame(height: 1).shadow(color: .black.opacity(0.3), radius: 1)
                Spacer()
            }
            HStack(spacing: 0) {
                Spacer()
                Rectangle().fill(Color.white.opacity(0.7)).frame(width: 1).shadow(color: .black.opacity(0.3), radius: 1)
                Spacer()
                Rectangle().fill(Color.white.opacity(0.7)).frame(width: 1).shadow(color: .black.opacity(0.3), radius: 1)
                Spacer()
            }
        }
        .allowsHitTesting(false)
    }
}
