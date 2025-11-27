//
//  ChatView.swift
//  UI_Lab
//
//  Created by 황상환 on 11/27/25.
//

import Foundation
import SwiftUI

struct ChatView: View {
    // 뷰모델을 모셔서 연결합니다.
    @StateObject var viewModel = ChatViewModel()
    
    // 입력창에 쓴 글씨를 잠시 담아둘 변수
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            // 채팅 목록 영역
            ScrollViewReader { proxy in // 자동 스크롤을 위해 필요
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageRow(message: message) // 말풍선 하나하나 그리기
                        }
                    }
                    .padding()
                }
                .onChangeCompatible(of: viewModel.messages.count) {
                    if let lastId = viewModel.messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            // 하단 입력창 영역
            HStack {
                TextField("메시지 입력", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                
                Button {
                    // 뷰모델에게 전송 시키기
                    viewModel.sendMessage(text: inputText)
                    inputText = "" // 입력창 비우기
                } label: {
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()
            .background(Color(.systemGray6)) // 입력창 배경색
        }
    }
}

// 말풍선 디자인 (내 거는 오른쪽, 남의 거는 왼쪽)
struct MessageRow: View {
    let message: Message
    
    // 내 기기 ID인지 확인
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
                    .cornerRadius(12)
                Spacer()
            }
        }
        .id(message.id)
    }
}

// ✅ 경고 해결을 위한 도우미(Extension) 추가
// 이 코드를 추가하면 iOS 16과 17 모두에서 경고 없이 동작합니다.
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
