//
//  ContentView.swift
//  UI_Lab
//
//  Created by 황상환 on 7/10/25.
//

import SwiftUI

public struct ContentView: View {
    public init() {}

    public var body: some View {
        VStack(spacing: 20) {
            Text("SwiftUI 첫 화면입니다!")
                .font(.title)
                .padding()

            Button(action: {
                print("버튼 눌림")
            }) {
                Text("눌러보기")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
