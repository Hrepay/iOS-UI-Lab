//
//  SheetMusicView.swift
//  UI_Lab
//
//  Created by 황상환 on 10/29/25.
//

import SwiftUI

struct SheetMusicView: View {
    
    @State private var selectedMeasure = 0
    @State private var selectedProfile = 0
    
    var body: some View {
        ZStack {
            // 웹뷰(악보)
            SheetMusicWebView(
                selectedMeasure: $selectedMeasure,
                selectedProfile: $selectedProfile
            )
            .edgesIgnoringSafeArea(.all)
            
            // ⭐️ 하단 오른쪽 레슨노트 버튼 (항상 표시)
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    LessonButton(measureNumber: selectedMeasure)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
            
            // 디버깅용 정보 표시
            VStack {
                HStack {
                    if selectedMeasure > 0 {
                        Text("선택된 마디: \(selectedMeasure)")
                            .padding(8)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    if selectedProfile > 0 {
                        Text("프로필 클릭: \(selectedProfile)번")
                            .padding(8)
                            .background(Color.cyan.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 50)
                
                Spacer()
            }
        }
    }
}

// ⭐️ 레슨노트 버튼 (하단 오른쪽 고정)
struct LessonButton: View {
    let measureNumber: Int
    
    var body: some View {
        Button(action: {
            if measureNumber > 0 {
                print("📝 레슨노트 버튼 클릭: \(measureNumber)번 마디")
            } else {
                print("📝 레슨노트 버튼 클릭: 마디 선택 안됨")
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: "note.text")
                    .foregroundColor(.white)
                Text("레슨노트")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.cyan, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            .overlay(
                // "NEW" 뱃지
                measureNumber > 0 ?
                Text("NEW 3")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.red)
                    .cornerRadius(12)
                    .offset(x: 35, y: -18)
                : nil
            )
        }
    }
}
