//
//  ChatViewModel.swift
//  UI_Lab
//
//  Created by 황상환 on 11/27/25.
//

import Foundation
import UIKit
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    private let serverURL = "ws:"
    
    init() {
        connect()
    }
    
    // 1. 서버 연결
    func connect() {
        guard let url = URL(string: serverURL) else { return }
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        
        receiveMessage()
    }
    
    // 2. 메시지 보내기
    func sendMessage(text: String) {
        guard !text.isEmpty else { return }
        
        // 보낼 데이터를 JSON으로 포장
        let myId = UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
        let newMessage = Message(text: text, senderId: myId)
        
        guard let jsonData = try? JSONEncoder().encode(newMessage),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        
        let messageToSend = URLSessionWebSocketTask.Message.string(jsonString)
        
        webSocketTask?.send(messageToSend) { error in
            if let error = error {
                print("전송 실패: \(error)")
            }
        }
    }
    
    // 3. 메시지 받기 (계속 듣기)
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                // 받은 메시지(JSON String)를 Message 객체로 변환
                if case .string(let text) = message,
                   let data = text.data(using: .utf8),
                   let receivedMessage = try? JSONDecoder().decode(Message.self, from: data) {
                    
                    // 화면 갱신 (메인 스레드)
                    DispatchQueue.main.async {
                        self?.messages.append(receivedMessage)
                    }
                }
                
                // 다음 메시지 대기 (재귀 호출)
                self?.receiveMessage()
                
            case .failure(let error):
                print("연결 끊김: \(error)")
            }
        }
    }
    
    // 연결 종료 (필요시 호출)
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
