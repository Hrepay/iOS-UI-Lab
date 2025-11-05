//
//  HashtagViewModel.swift
//  UI_Lab
//
//  Created by 황상환 on 11/6/25.
//

import SwiftUI
import Combine

class HashtagViewModel: ObservableObject {
    @Published var text: String = "" {
        didSet {
            print("didSet 호출됨! text = \(text)")
            processHashtags(text)
        }
    }
    @Published var hashtags: [String] = []
    @Published var attributedText: AttributedString = AttributedString("")
    
    init() {
        print("HashtagViewModel 초기화됨")
    }
    
    private func processHashtags(_ text: String) {
        print("processHashtags 호출됨")
        var attributed = AttributedString(text)
        var foundHashtags: [String] = []
        
        // 해시태그 패턴: # 뒤에 한글/영문/숫자가 1개 이상
        let pattern = "(?<!#)#(?!#)[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]+"
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            print("정규식 생성 실패")
            self.attributedText = attributed
            return
        }
        
        let nsString = text as NSString
        let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
        
        print("텍스트: \(text)")
        print("매칭 개수: \(matches.count)")
        
        for match in matches {
            let matchedString = nsString.substring(with: match.range)
            print("매칭된 단어: \(matchedString)")
            foundHashtags.append(matchedString)
            
            if let range = Range(match.range, in: text) {
                let attributedRange = AttributedString.Index(range.lowerBound, within: attributed)!
                ..< AttributedString.Index(range.upperBound, within: attributed)!
                
                attributed[attributedRange].foregroundColor = .red
                attributed[attributedRange].font = .system(size: 17, weight: .semibold)
            }
        }
        
        self.hashtags = foundHashtags
        print("추출된 해시태그들: \(foundHashtags)")
        self.attributedText = attributed
    }
}
