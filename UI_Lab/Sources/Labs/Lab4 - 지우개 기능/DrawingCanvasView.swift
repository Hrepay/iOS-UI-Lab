//
//  DrawingCanvasView.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import SwiftUI

struct DrawingCanvasView: View {
    // MARK: - 바인딩 변수들 (ImageEditorView와 상태 공유)
    @Binding var image: UIImage?
    @Binding var paths: [Path]
    @Binding var brushSize: CGFloat
    
    // 이동/확대 관련 변수
    @Binding var scale: CGFloat
    @Binding var offset: CGSize
    
    // 현재 모드에 따라 제스처를 활성화/비활성화
    var isDrawingEnabled: Bool
    var isMovingEnabled: Bool
    
    @State private var currentDragPath: Path?
    
    // 제스처 도중의 임시적인 변화를 추적하기 위한 @GestureState
    @GestureState private var gestureScale: CGFloat = 1.0
    @GestureState private var gestureOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            // 배경색 (이미지가 없을 경우)
            Color.white
            
            // 편집 중인 이미지 표시
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            
            // 그린 경로들을 캔버스에 표시
            Canvas { context, size in
                // 이미 저장된 경로들 그리기
                for path in paths {
                    context.stroke(path, with: .color(.white), style: .init(lineWidth: brushSize, lineCap: .round, lineJoin: .round))
                }
                // 현재 드래그 중인 경로를 실시간으로 그리기
                if let currentPath = currentDragPath {
                    context.stroke(currentPath, with: .color(.white), style: .init(lineWidth: brushSize, lineCap: .round, lineJoin: .round))
                }
            }
        }
        // --- 💡 수정된 부분 1: 제스처를 한 곳에서 관리하고 좌표 보정 ---
        .scaleEffect(scale * gestureScale)
        .offset(x: offset.width + gestureOffset.width, y: offset.height + gestureOffset.height)
        .contentShape(Rectangle()) // ZStack 전체 영역에서 제스처를 감지하도록 함
        .gesture(isDrawingEnabled ? drawingGesture : nil)
        .gesture(isMovingEnabled ? moveAndZoomGesture : nil)
        .clipped()
    }
    
    /// 그리기 제스처
    var drawingGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                // 현재 확대/이동된 상태를 역으로 계산하여 정확한 그리기 좌표를 얻음
                let transformedLocation = value.location
                let untransformedLocation = CGPoint(
                    x: (transformedLocation.x - offset.width) / scale,
                    y: (transformedLocation.y - offset.height) / scale
                )
                
                if currentDragPath == nil {
                    currentDragPath = Path()
                    currentDragPath?.move(to: untransformedLocation)
                } else {
                    currentDragPath?.addLine(to: untransformedLocation)
                }
            }
            .onEnded { value in
                if let path = currentDragPath {
                    paths.append(path)
                }
                currentDragPath = nil // 현재 경로 초기화
            }
    }
    
    /// 이동 및 확대/축소 제스처
    var moveAndZoomGesture: some Gesture {
        SimultaneousGesture(
            DragGesture()
                .updating($gestureOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    offset.width += value.translation.width
                    offset.height += value.translation.height
                },
            MagnificationGesture()
                .updating($gestureScale) { value, state, _ in
                    state = value
                }
                .onEnded { value in
                    scale *= value
                }
        )
    }
}
