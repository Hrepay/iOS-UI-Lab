//
//  ImageEditorView.swift
//  UI_Lab
//
//  Created by 황상환 on 9/3/25.
//

import SwiftUI
import PhotosUI

// 편집 모드
enum EditMode {
    case idle // 기본 상태
    case moving // 이미지 이동/확대 모드
    case erasing // 지우개(그리기) 모드
}

struct ImageEditorView: View {
    // MARK: - 상태 변수들
    
    // 편집할 원본 이미지
    @State private var originalImage: UIImage?
    // 편집이 적용된 이미지 (이동, 그리기 등)
    @State private var editedImage: UIImage?
    
    // 현재 편집 모드 (기본, 이동, 지우개)
    @State private var editMode: EditMode = .idle
    
    // PhotosUI를 이용한 이미지 선택기를 띄우기 위한 변수
    @State private var photoPickerItem: PhotosPickerItem?
    
    // 최종적으로 저장된 결과 이미지
    @State private var finalImage: UIImage?
    
    // 그리기 경로들 (지우개 기능용)
    @State private var paths: [Path] = []
    // 이전 그리기 경로들 (되돌리기 기능용)
    @State private var undonePaths: [Path] = []
    
    // 지우개(브러시) 크기
    @State private var brushSize: CGFloat = 20.0
    
    // 이동/확대 관련 상태 변수
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    
    // 임시 저장 변수 (X 버튼을 눌러 취소할 경우를 대비)
    @State private var tempScale: CGFloat = 1.0
    @State private var tempOffset: CGSize = .zero
    @State private var tempPaths: [Path] = []
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("이미지 편집기")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            imageCanvasSection
            
            if editMode == .erasing {
                eraserControls
            }
            
            if editMode == .idle && originalImage != nil {
                bottomToolbar
            }
            
            if let finalImage {
                VStack {
                    Text("저장된 결과")
                        .font(.headline)
                    Image(uiImage: finalImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill) // 비율을 채우도록 설정
                        .frame(width: 150, height: 150)   // 프레임을 정사각형으로
                        .border(Color.gray)
                        .clipped() // 프레임 밖으로 나가는 부분은 잘라냄
                }
            }
        }
        .padding()
        .onChange(of: photoPickerItem) { _, _ in
            Task {
                await loadImage()
            }
        }
    }
    
    // MARK: - UI 구성 요소들
    
    private var imageCanvasSection: some View {
        let canvasView = DrawingCanvasView(
            image: $editedImage,
            paths: $paths,
            brushSize: $brushSize,
            scale: $imageScale,
            offset: $imageOffset,
            isDrawingEnabled: editMode == .erasing,
            isMovingEnabled: editMode == .moving
        )
        
        return ZStack {
            canvasView
                .frame(width: 350, height: 350)
                .border(Color.black, width: 2)
                .background(Color.white)
            
            if originalImage == nil {
                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    ZStack {
                        Rectangle()
                            .fill(Color(uiColor: .systemGray6))
                        Text("앨범에서 사진 선택")
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if editMode != .idle {
                VStack {
                    HStack {
                        Button("X") { cancelEditing() }
                        Spacer()
                        Button("V") { saveChanges(canvasView: canvasView) }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .foregroundColor(.white)
                    .font(.title2)
                    
                    Spacer()
                }
            }
        }
        .frame(width: 350, height: 350)
    }
    
    private var bottomToolbar: some View {
        HStack(spacing: 20) {
            Button("이동") {
                tempScale = imageScale
                tempOffset = imageOffset
                editMode = .moving
            }
            .buttonStyle(.bordered)
            
            Button("이미지 제거") {
                resetAll()
            }
            .buttonStyle(.bordered)
            
            Button("지우개") {
                tempPaths = paths
                editMode = .erasing
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var eraserControls: some View {
        HStack {
            Text("크기")
            Slider(value: $brushSize, in: 5...50)
            
            Button(action: {
                if !paths.isEmpty {
                    let lastPath = paths.removeLast()
                    undonePaths.append(lastPath)
                }
            }) {
                Image(systemName: "arrow.uturn.backward.circle")
                    .font(.title)
            }
            .disabled(paths.isEmpty)
        }
        .padding(.horizontal)
    }
    
    // MARK: - 기능 함수들
    
    private func loadImage() async {
        if let item = photoPickerItem,
           let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.originalImage = image
                self.editedImage = image
                resetAllStates()
            }
        }
    }
    
    private func resetAll() {
        originalImage = nil
        editedImage = nil
        photoPickerItem = nil
        resetAllStates()
    }
    
    private func resetAllStates() {
        paths.removeAll()
        undonePaths.removeAll()
        imageScale = 1.0
        imageOffset = .zero
        editMode = .idle
    }
    
    private func cancelEditing() {
        if editMode == .moving {
            imageScale = tempScale
            imageOffset = tempOffset
        } else if editMode == .erasing {
            paths = tempPaths
        }
        editMode = .idle
    }
    
    @MainActor
    private func saveChanges(canvasView: DrawingCanvasView) {
        let viewToRender = canvasView
            .frame(width: 350, height: 350)

        let renderer = ImageRenderer(content: viewToRender)
        renderer.scale = UIScreen.main.scale
        
        guard let capturedImage = renderer.uiImage else {
            editMode = .idle
            return
        }
        
        self.finalImage = capturedImage
        self.editedImage = capturedImage
        
        self.paths.removeAll()
        self.undonePaths.removeAll()
        self.imageScale = 1.0
        self.imageOffset = .zero
        
        editMode = .idle
    }
}
