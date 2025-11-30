//
//  WebSocketRepository.swift
//  UI_Lab
//
//  Created by 황상환 on 11/28/25.
//

import Foundation
import Combine

final class WebSocketRepository: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    
    // 화면으로 메시지를 전달하는 파이프
    let messageStream = PassthroughSubject<String, Never>()
    
    private var urlString = ""
    
    // IP 주소를 받아서 URL 설정
    func setIP(ip: String) {
        // ws://192.168.0.x:8765 형태로 만듦
        self.urlString = "ws://\(ip):8765"
    }

    // 1. 서버 연결
    func connect() {
        guard let url = URL(string: urlString) else {
            print("❌ 유효하지 않은 URL입니다.")
            return
        }
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        print("🔗 [앱] 연결 시도: \(urlString)")
        receiveMessage() // 듣기 시작
    }
    
    // 2. 메시지 전송
    func sendMessage(_ text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("🚨 [앱] 전송 실패: \(error)")
            } else {
                print("📤 [앱] 전송 성공: \(text)")
            }
        }
    }
    
    // 3. 메시지 수신 (재귀 호출)
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                if case .string(let text) = message {
                    print("📥 [앱] 서버 응답: \(text)")
                    DispatchQueue.main.async {
                        self?.messageStream.send(text)
                    }
                }
                self?.receiveMessage() // 계속 듣기
            case .failure(let error):
                print("❌ [앱] 연결 끊김: \(error)")
            }
        }
    }
    
    // 4. 연결 종료
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
