//import SwiftUI
//
//struct NavigationView: View {
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        GeometryReader { geometry in
//            let safeTop = geometry.safeAreaInsets.top
//            let navBarHeight: CGFloat = 44
//
//            VStack(spacing: 0) {
//                ZStack(alignment: .top) {
//                    Color.white
//
//                    Image("aspa")
//                        .resizable()
//                        .scaledToFit()
//                        .padding(.top, safeTop - navBarHeight)
//                        .overlay(
//                            Color.black.opacity(0.6) // 전체 어둡게
//                                .padding(.top, safeTop - navBarHeight),
//                            alignment: .top
//                        )
//
//                }
//
//                Spacer()
//            }
//            .edgesIgnoringSafeArea(.top)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        dismiss()
//                    }) {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                    }
//                }
//
//                ToolbarItem(placement: .principal) {
//                    Text("2025 aespa WORLD TOUR")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                }
//            }
//            .navigationBarBackButtonHidden(true) // 네이티브 뒤로가기 버튼 숨김
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//#Preview {
//    NavigationStack {
//        NavigationView()
//    }
//}
