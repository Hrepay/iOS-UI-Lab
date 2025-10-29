//
//  SheetMusicWebView.swift
//  UI_Lab
//
//  Created by 황상환 on 10/29/25.
//

import SwiftUI
import WebKit

struct SheetMusicWebView: UIViewRepresentable {
    
    @Binding var selectedMeasure: Int
    @Binding var selectedProfile: Int
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        
        // ★ JS -> Swift 브릿지 등록
        contentController.add(context.coordinator, name: "measureClicked")
        contentController.add(context.coordinator, name: "profileButtonClicked")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        config.defaultWebpagePreferences = preferences

        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        // ⭐️ 스크롤 설정 - 대각선 스크롤 가능
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = true // 바운스 효과
        webView.scrollView.alwaysBounceVertical = true // 세로 바운스
        webView.scrollView.alwaysBounceHorizontal = true // 가로 바운스
        webView.scrollView.isDirectionalLockEnabled = false // ⭐️ 대각선 스크롤 허용!
        webView.scrollView.showsVerticalScrollIndicator = true
        webView.scrollView.showsHorizontalScrollIndicator = true
        
        // ⭐️ 핀치 줌 설정
        webView.scrollView.minimumZoomScale = 0.3
        webView.scrollView.maximumZoomScale = 3.0
        webView.scrollView.bouncesZoom = true
        webView.scrollView.zoomScale = 0.5
        
        guard let url = Bundle.main.url(forResource: "index", withExtension: "html") else {
            print("❌ Error: index.html 파일을 찾을 수 없습니다.")
            return webView
        }

        let baseURL = url.deletingLastPathComponent()
        print("✅ HTML 파일 경로: \(url)")
        print("✅ Base URL: \(baseURL)")

        webView.loadFileURL(url, allowingReadAccessTo: baseURL)
        print("✅ HTML 로딩 완료")
        
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, selectedMeasure: $selectedMeasure, selectedProfile: $selectedProfile)
    }
    
    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var parent: SheetMusicWebView
        
        @Binding var selectedMeasure: Int
        @Binding var selectedProfile: Int

        init(_ parent: SheetMusicWebView, selectedMeasure: Binding<Int>, selectedProfile: Binding<Int>) {
            self.parent = parent
            self._selectedMeasure = selectedMeasure
            self._selectedProfile = selectedProfile
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            // 마디 클릭
            if message.name == "measureClicked",
               let body = message.body as? [String: Any],
               let measureNumber = body["measureNumber"] as? Int {
                
                print("🎵 마디 클릭: \(measureNumber)번")
                self.selectedMeasure = measureNumber
            }
            
            // 프로필 버튼 클릭
            if message.name == "profileButtonClicked",
               let body = message.body as? [String: Any],
               let measureNumber = body["measureNumber"] as? Int {
                
                print("👤 프로필 버튼 클릭: \(measureNumber)번 마디")
                self.selectedProfile = measureNumber
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ 웹뷰 로딩 완료")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                webView.scrollView.zoomScale = 0.5
                print("✅ 초기 줌 스케일 0.5로 설정")
            }
        }
    }
}
