//
//  EraserCanvasView.swift
//  UI_Lab
//
//  Created by 황상환 on 11/21/25.
//

import SwiftUI

// 1. 선의 경로와 굵기를 함께 저장하는 구조체 정의
struct DrawingLine: Identifiable {
    let id = UUID()
    var path: Path
    var lineWidth: CGFloat
}

struct EraserEditorView: View {
    let originalImage: UIImage
    var onCompleted: (UIImage) -> Void
    @Environment(\.dismiss) var dismiss
    
    // 2. [수정] 단순 Path 배열 대신, 굵기 정보를 포함한 구조체 배열 사용
    @State private var lines: [DrawingLine] = []
    
    // 현재 긋고 있는 선
    @State private var currentPath = Path()
    @State private var brushSize: CGFloat = 30.0
    
    // 3. [추가] 화면상의 캔버스 크기를 기억하기 위한 변수 (비율 계산용)
    @State private var canvasSize: CGSize = .zero
    
    var body: some View {
        VStack {
            // [네비게이션 바]
            HStack {
                Button("취소") { dismiss() }
                    .foregroundColor(.red)
                Spacer()
                Text("지우개 편집")
                    .font(.headline)
                Spacer()
                Button("완료") {
                    let result = saveImage()
                    onCompleted(result)
                    dismiss()
                }
                .fontWeight(.bold)
            }
            .padding()
            
            Spacer()
            
            // [작업 영역]
            ZStack {
                CheckerboardBackground()
                
                // GeometryReader로 현재 화면의 캔버스 크기를 측정
                GeometryReader { geo in
                    Canvas { context, size in
                        // 1. 이미지 그리기
                        let image = Image(uiImage: originalImage)
                        context.draw(image, in: CGRect(origin: .zero, size: size))
                        
                        // 2. 지우개 모드
                        context.blendMode = .destinationOut
                        
                        // 3. [수정] 저장된 선들 그리기 (각자의 굵기 사용)
                        for line in lines {
                            context.stroke(
                                line.path,
                                with: .color(.black),
                                style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round)
                            )
                        }
                        
                        // 4. 현재 긋고 있는 선 그리기 (현재 슬라이더 굵기 사용)
                        context.stroke(
                            currentPath,
                            with: .color(.black),
                            style: StrokeStyle(lineWidth: brushSize, lineCap: .round, lineJoin: .round)
                        )
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                if currentPath.isEmpty {
                                    currentPath.move(to: value.location)
                                } else {
                                    currentPath.addLine(to: value.location)
                                }
                            }
                            .onEnded { _ in
                                // [수정] 선이 끝날 때, 현재 굵기를 함께 저장
                                let newLine = DrawingLine(path: currentPath, lineWidth: brushSize)
                                lines.append(newLine)
                                currentPath = Path()
                            }
                    )
                    .onAppear {
                        // 캔버스 크기 저장 (나중에 저장할 때 비율 계산에 씀)
                        self.canvasSize = geo.size
                    }
                }
            }
            .aspectRatio(3/4, contentMode: .fit)
            .border(Color.gray, width: 1)
            .padding()
            
            Spacer()
            
            // [하단 툴바]
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "circle.fill").scaleEffect(0.5)
                    Slider(value: $brushSize, in: 10...100)
                    Image(systemName: "circle.fill").scaleEffect(1.0)
                }
                .padding(.horizontal)
                
                HStack(spacing: 40) {
                    Button(action: { lines.removeAll() }) {
                        VStack {
                            Image(systemName: "trash").font(.title2)
                            Text("초기화").font(.caption)
                        }
                        .foregroundColor(.red)
                    }
                    
                    Button(action: {
                        if !lines.isEmpty { lines.removeLast() }
                    }) {
                        VStack {
                            Image(systemName: "arrow.uturn.backward").font(.title2)
                            Text("되돌리기").font(.caption)
                        }
                    }
                    .disabled(lines.isEmpty)
                }
            }
            .padding(.bottom, 20)
        }
        .background(Color.white)
    }
    
    // [핵심 수정] 이미지 저장 로직
    @MainActor
    func saveImage() -> UIImage {
        // 화면 크기가 0이면(오류 방지) 원본 크기로 가정
        let currentCanvasSize = (canvasSize == .zero) ? originalImage.size : canvasSize
        
        // **비율 계산**: (실제 이미지 너비 / 화면 캔버스 너비)
        let scaleFactor = originalImage.size.width / currentCanvasSize.width
        
        let renderer = ImageRenderer(content:
            Canvas { context, size in
                // 1. 원본 이미지는 꽉 채워서 그립니다 (이미지 좌표계)
                let image = Image(uiImage: originalImage)
                context.draw(image, in: CGRect(origin: .zero, size: size))
                
                // 2. 지우개 모드 진입
                context.blendMode = .destinationOut
                
                // 3. [중요] 좌표계 확대!
                // 우리가 기록한 path는 작은 화면(예: 300px) 기준입니다.
                // 캔버스는 큰 이미지(예: 3000px) 기준이므로, context 자체를 확대합니다.
                context.scaleBy(x: scaleFactor, y: scaleFactor)
                
                // 4. 이제 선을 그리면 확대된 좌표에 그려집니다.
                for line in lines {
                    context.stroke(
                        line.path,
                        with: .color(.black),
                        style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round)
                    )
                }
            }
            .frame(width: originalImage.size.width, height: originalImage.size.height)
        )
        
        renderer.scale = 1.0
        return renderer.uiImage ?? originalImage
    }
}

// 투명 배경용 체크무늬 뷰
struct CheckerboardBackground: View {
    var body: some View {
        GeometryReader { geometry in
            let size = 20.0
            let rows = Int(geometry.size.height / size) + 1
            let cols = Int(geometry.size.width / size) + 1
            
            VStack(spacing: 0) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<cols, id: \.self) { col in
                            Rectangle()
                                .fill((row + col) % 2 == 0 ? Color.white : Color.gray.opacity(0.2))
                                .frame(width: size, height: size)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}
