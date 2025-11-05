//
//  Lab9View.swift
//  UI_Lab
//
//  Created by 황상환 on 11/5/25.
//

import SwiftUI

struct Lab9View: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                // 일반 링크
                NavigationLink("상세보기", value: "detail")
                
                // 버튼으로 코드 제어
                Button("3단계 깊이로 이동") {
                    path.append("detail")
                    path.append("edit")
                    path.append("confirm")
                }
                
                Button("홈으로 돌아가기") {
                    path.removeLast(path.count)
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "detail" {
                    DetailView()
                } else if value == "edit" {
                    EditView()
                } else if value == "confirm" {
                    ConfirmView()
                }
            }
            .navigationTitle("홈")
        }
    }
}

struct DetailView: View {
    var body: some View {
        VStack {
            Text("상세 화면")
            NavigationLink("편집하기", value: "edit")
        }
        .navigationTitle("상세")
    }
}

struct EditView: View {
    var body: some View {
        Text("편집 화면")
            .navigationTitle("편집")
            NavigationLink("확인하기", value: "confirm")
    }
}

struct ConfirmView: View {
    var body: some View {
        Text("확인 화면")
            .navigationTitle("확인")
    }
}
