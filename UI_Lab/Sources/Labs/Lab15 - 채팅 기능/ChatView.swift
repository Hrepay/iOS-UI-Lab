//
//  ChatView.swift
//  UI_Lab
//
//  Created by 황상환 on 11/27/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel = ChatViewModel()
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            // 상단 타이틀
            Text("🔥 파이썬 소켓 채팅")
                .font(.headline)
                .padding()
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageRow(message: message)
                        }
                    }
                    .padding()
                }
                // 메시지 오면 맨 아래로 스크롤
                .onChangeCompatible(of: viewModel.messages.count) {
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            // 하단 입력창
            HStack {
                TextField("메시지 입력", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit { sendMessage() } // 엔터 치면 전송
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .onAppear {
            // 화면 켜지면 연결 확인 (이미 init에서 하지만 확실하게)
             viewModel.connect()
        }
    }
    
    func sendMessage() {
        viewModel.sendMessage(text: inputText)
        inputText = ""
    }
}

// 말풍선 디자인 (기존 코드 유지)
struct MessageRow: View {
    let message: Message
    
    // 내 기기 UUID와 메시지의 senderId가 같으면 '나'
    var isMe: Bool {
        message.senderId == UIDevice.current.identifierForVendor?.uuidString
    }
    
    var body: some View {
        HStack {
            if isMe {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            } else {
                Text(message.text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                Spacer()
            }
        }
        .id(message.id)
        .padding(.horizontal)
    }
}

extension View {
    @ViewBuilder
    func onChangeCompatible<V: Equatable>(of value: V, perform action: @escaping () -> Void) -> some View {
        if #available(iOS 17.0, *) {
            // iOS 17 이상: 새로운 문법 (파라미터 0개 가능)
            self.onChange(of: value) { _, _ in
                action()
            }
        } else {
            // iOS 16 이하: 구형 문법
            self.onChange(of: value) { _ in
                action()
            }
        }
    }
}
