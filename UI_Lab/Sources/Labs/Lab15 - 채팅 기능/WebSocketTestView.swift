//
//  WebSocketTestView.swift
//  UI_Lab
//
//  Created by 황상환 on 11/28/25.
//

import SwiftUI

struct WebSocketTestView: View {
    @StateObject private var repo = WebSocketRepository()
    @State private var log: String = "대기 중..."
    @State private var ipAddress: String = "localhost" // 여기에 나중에 IP 입력
    @State private var inputText: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("📡 웹소켓 테스트").font(.title).bold()
            
            // 내 맥북 IP 입력칸
            TextField("내 맥북 IP", text: $ipAddress)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numbersAndPunctuation)
                .padding(.horizontal)
            
            // 로그 창
            Text(log)
                .padding()
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            HStack {
                Button("1. 연결하기") {
                    repo.setIP(ip: ipAddress)
                    repo.connect()
                    log = "연결 시도 중..."
                }
                .buttonStyle(.borderedProminent)
                
                Button("3. 연결 끊기") {
                    repo.disconnect()
                    log += "\n[연결 종료]"
                }
                .tint(.red)
            }
            
            HStack {
                TextField("보낼 메시지", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                
                Button("2. 전송") {
                    repo.sendMessage(inputText)
                    inputText = ""
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .onReceive(repo.messageStream) { text in
            log = "서버 응답: \(text)"
        }
    }
}

#Preview {
    WebSocketTestView()
}
