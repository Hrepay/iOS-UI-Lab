//
//  ChatViewModel.swift
//  UI_Lab
//
//  Created by 황상환 on 11/27/25.
//

import Foundation
import UIKit
import FirebaseFirestore

class ChatViewModel: ObservableObject {
    // @Published: 이 배열이 바뀌면 화면도 자동으로 바뀝니다.
    @Published var messages: [Message] = []
    
    // Firestore 데이터베이스 참조
    private var db = Firestore.firestore()
    
    init() {
        // 뷰모델이 생성되자마자 메시지를 듣기 시작합니다.
        fetchMessages()
    }
    
    // 실시간 데이터 듣기
    func fetchMessages() {
        // 'messages'라는 컬렉션(폴더)을 구독합니다.
        db.collection("messages")
            .order(by: "timestamp", descending: false) // 과거 -> 최신 순 정렬
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("문서가 없습니다: \(String(describing: error))")
                    return
                }
                
                // 가져온 문서들을 Message 구조체로 변환해서 배열에 넣습니다.
                self.messages = documents.compactMap { doc -> Message? in
                    try? doc.data(as: Message.self)
                }
            }
    }
    
    // 메시지 전송 기능
    func sendMessage(text: String) {
        // 빈 메시지 방지
        guard !text.isEmpty else { return }
        
        // 보낼 데이터 뭉치 만들기
        let newMessage = Message(
            text: text,
            senderId: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown", // 내 기기 ID
            timestamp: Date()
        )
        
        // Firestore에 저장 (오류 처리는 간단히 print로)
        do {
            try db.collection("messages").addDocument(from: newMessage)
        } catch {
            print("전송 실패: \(error.localizedDescription)")
        }
    }
}
