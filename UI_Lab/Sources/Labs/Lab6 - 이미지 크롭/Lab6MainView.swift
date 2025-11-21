//
//  Lab6MainView.swift
//  UI_Lab
//
//  Created by 황상환 on 10/14/25.
//

import SwiftUI
import PhotosUI
import Mantis

// 1. 이미지를 감싸는 Identifiable 래퍼 구조체 생성 (핵심 수정 사항)
struct ImageToCrop: Identifiable {
    let id = UUID()
    let image: UIImage
}

struct Lab6MainView: View {
    // 2. UIImage? 대신 래퍼 구조체 사용
    @State private var selectedImageToCrop: ImageToCrop?
    @State private var croppedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 크롭된 이미지 표시
                if let croppedImage = croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .cornerRadius(12)
                        .padding()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(maxWidth: .infinity, maxHeight: 400)
                        .overlay {
                            Text("이미지를 선택해주세요")
                                .foregroundColor(.gray)
                        }
                        .padding()
                }
                
                // 갤러리 열기 버튼
                Button(action: {
                    showImagePicker = true
                }) {
                    Label("갤러리에서 선택", systemImage: "photo.on.rectangle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Mantis 테스트")
            // 3. 갤러리 시트
            .sheet(isPresented: $showImagePicker) {
                SimpleImagePicker(selectedImageWrapper: $selectedImageToCrop)
            }
            // 4. 크롭 시트 (래퍼 객체가 변경되면 실행됨)
            .sheet(item: $selectedImageToCrop) { item in
                MantisCropView(
                    image: item.image,
                    croppedImage: $croppedImage
                )
            }
        }
    }
}

// MARK: - Simple Image Picker
struct SimpleImagePicker: UIViewControllerRepresentable {
    // 바인딩 타입을 래퍼 구조체로 변경
    @Binding var selectedImageWrapper: ImageToCrop?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: SimpleImagePicker
        
        init(_ parent: SimpleImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else {
                return
            }
            
            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        // 여기서 래퍼 구조체로 감싸서 전달
                        self?.parent.selectedImageWrapper = ImageToCrop(image: image)
                    }
                }
            }
        }
    }
}

// MARK: - Mantis Crop View
struct MantisCropView: UIViewControllerRepresentable {
    let image: UIImage
    @Binding var croppedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> Mantis.CropViewController {
        var config = Mantis.Config()
        config.presetFixedRatioType = .canUseMultiplePresetFixedRatio()
        
        // Mantis 권장: config를 생성자에 주입
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = context.coordinator
        
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: Mantis.CropViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        let parent: MantisCropView
        
        init(_ parent: MantisCropView) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(
            _ cropViewController: Mantis.CropViewController,
            cropped: UIImage,
            transformation: Transformation,
            cropInfo: CropInfo
        ) {
            parent.croppedImage = cropped
            parent.dismiss()
        }
        
        func cropViewControllerDidCancel(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage
        ) {
            parent.dismiss()
        }
        
        func cropViewControllerDidFailToCrop(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage
        ) {
            parent.dismiss()
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {}
        
        func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: CropInfo) {}
    }
}

#Preview {
    Lab6MainView()
}
