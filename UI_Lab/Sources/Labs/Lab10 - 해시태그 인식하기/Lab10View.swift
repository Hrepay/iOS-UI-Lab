//
//  Lab10View.swift
//  UI_Lab
//
//  Created by 황상환 on 11/6/25.
//

import SwiftUI

struct Lab10View: View {
    @StateObject private var viewModel = HashtagViewModel()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // 배경색
            Color.gray.opacity(0.1)
            
            // 색상 처리된 텍스트 (표시용)
            Text(viewModel.attributedText)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(8)
            
            // TextEditor (입력용, 투명)
            TextEditor(text: $viewModel.text)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .foregroundColor(.clear)
                .accentColor(.red)
                .padding(4)
        }
        .frame(height: 200)
        .cornerRadius(8)
        .padding()
    }
}

#Preview {
    Lab10View()
}
