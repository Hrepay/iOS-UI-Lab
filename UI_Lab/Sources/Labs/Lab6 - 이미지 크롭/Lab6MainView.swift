////
////  Lab6MainView.swift
////  UI_Lab
////
////  Created by 황상환 on 10/14/25.
////
//
//import SwiftUI
//import PhotosUI
//
//struct Lab6MainView: View {
//    @State private var selectedImage: UIImage?
//    @State private var croppedImage: UIImage?
//    @State private var showImagePicker = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 20) {
//                // 크롭된 이미지 표시
//                if let croppedImage = croppedImage {
//                    Image(uiImage: croppedImage)
//                        .resizable()
//                        .scaledToFit()
//                        .frame(maxWidth: .infinity, maxHeight: 400)
//                        .cornerRadius(12)
//                        .padding()
//                } else {
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(Color.gray.opacity(0.2))
//                        .frame(maxWidth: .infinity, maxHeight: 400)
//                        .overlay {
//                            Text("이미지를 선택해주세요")
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
//                }
//                
//                // 갤러리 열기 버튼
//                Button(action: {
//                    showImagePicker = true
//                }) {
//                    Label("갤러리에서 선택", systemImage: "photo.on.rectangle")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(12)
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            .navigationTitle("Mantis 테스트")
//            .sheet(isPresented: $showImagePicker) {
//                SimpleImagePicker(selectedImage: $selectedImage)
//            }
//            .sheet(item: $selectedImage) { image in
//                MantisCropView(
//                    image: image,
//                    croppedImage: $croppedImage
//                )
//            }
//        }
//    }
//}
//
//// MARK: - UIImage Identifiable 확장
//extension UIImage: @retroactive Identifiable {
//    public var id: String {
//        return UUID().uuidString
//    }
//}
//
//// MARK: - Simple Image Picker
//struct SimpleImagePicker: UIViewControllerRepresentable {
//    @Binding var selectedImage: UIImage?
//    @Environment(\.dismiss) private var dismiss
//    
//    func makeUIViewController(context: Context) -> PHPickerViewController {
//        var config = PHPickerConfiguration()
//        config.filter = .images
//        config.selectionLimit = 1
//        
//        let picker = PHPickerViewController(configuration: config)
//        picker.delegate = context.coordinator
//        return picker
//    }
//    
//    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, PHPickerViewControllerDelegate {
//        let parent: SimpleImagePicker
//        
//        init(_ parent: SimpleImagePicker) {
//            self.parent = parent
//        }
//        
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            parent.dismiss()
//            
//            guard let provider = results.first?.itemProvider,
//                  provider.canLoadObject(ofClass: UIImage.self) else {
//                print("❌ 이미지 provider 없음")
//                return
//            }
//            
//            print("📸 이미지 로딩 시작...")
//            provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                DispatchQueue.main.async {
//                    if let image = image as? UIImage {
//                        print("✅ 이미지 로드 완료 - Mantis 화면 표시 예정")
//                        self?.parent.selectedImage = image
//                    } else {
//                        print("❌ 이미지 로드 실패: \(error?.localizedDescription ?? "unknown")")
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Mantis Crop View
//struct MantisCropView: UIViewControllerRepresentable {
//    let image: UIImage
//    @Binding var croppedImage: UIImage?
//    @Environment(\.dismiss) private var dismiss
//    
//    func makeUIViewController(context: Context) -> Mantis.CropViewController {
//        print("🎨 Mantis CropViewController 생성")
//        
//        var config = Mantis.Config()
//        config.presetFixedRatioType = .canUseMultiplePresetFixedRatio()
//        
//        let cropViewController = Mantis.cropViewController(image: image)
//        cropViewController.config = config
//        cropViewController.delegate = context.coordinator
//        
//        return cropViewController
//    }
//    
//    func updateUIViewController(_ uiViewController: Mantis.CropViewController, context: Context) {
//        print("🔄 Mantis updateUIViewController 호출")
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, CropViewControllerDelegate {
//        let parent: MantisCropView
//        
//        init(_ parent: MantisCropView) {
//            self.parent = parent
//        }
//        
//        func cropViewControllerDidCrop(
//            _ cropViewController: Mantis.CropViewController,
//            cropped: UIImage,
//            transformation: Transformation,
//            cropInfo: CropInfo
//        ) {
//            print("✅ 크롭 완료! 이미지 크기: \(cropped.size)")
//            parent.croppedImage = cropped
//            parent.dismiss()
//        }
//        
//        func cropViewControllerDidCancel(
//            _ cropViewController: Mantis.CropViewController,
//            original: UIImage
//        ) {
//            print("❌ 사용자가 크롭 취소")
//            parent.dismiss()
//        }
//        
//        func cropViewControllerDidFailToCrop(
//            _ cropViewController: Mantis.CropViewController,
//            original: UIImage
//        ) {
//            print("⚠️ 크롭 실패")
//            parent.dismiss()
//        }
//        
//        func cropViewControllerDidBeginResize(
//            _ cropViewController: Mantis.CropViewController
//        ) {
//            // 리사이즈 시작
//        }
//        
//        func cropViewControllerDidEndResize(
//            _ cropViewController: Mantis.CropViewController,
//            original: UIImage,
//            cropInfo: CropInfo
//        ) {
//            // 리사이즈 종료
//        }
//    }
//}
//
//#Preview {
//    Lab6MainView()
//}
