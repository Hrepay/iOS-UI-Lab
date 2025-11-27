//
//  Message.swift
//  UI_Lab
//
//  Created by 황상환 on 11/27/25.
//

import SwiftUI
import FirebaseFirestore

struct Message: Identifiable, Codable {
    // @DocumentID: Firestore에 저장된 문서의 ID(문자열)를 자동으로 가져옵니다.
    // 이게 있어야 나중에 수정하거나 삭제할 때 "이거 지워줘!"라고 말할 수 있습니다.
    @DocumentID var id: String?
    
    let text: String      // 메시지 내용
    let senderId: String  // 보낸 사람 (내 건지 남의 건지 구별용)
    let timestamp: Date   // 보낸 시간
}
