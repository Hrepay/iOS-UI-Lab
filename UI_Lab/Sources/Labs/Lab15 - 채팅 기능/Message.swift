//
//  Message.swift
//  UI_Lab
//
//  Created by 황상환 on 11/27/25.
//

import SwiftUI
import FirebaseFirestore

struct Message: Identifiable, Codable {
    var id = UUID().uuidString // 고유 ID (자동 생성)
    let text: String           // 내용
    let senderId: String       // 보낸 사람 ID (이걸로 내꺼/니꺼 구분)
}
