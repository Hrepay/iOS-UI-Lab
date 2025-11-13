//
//  Lab12View.swift
//  UI_Lab
//
//  Created by 황상환 on 11/14/25.
//

import SwiftUI

struct Lab12View: View {
    @State private var isExpanded = false
    
    let categories = ["전체", "상의", "하의", "아우터", "원피스", "신발", "가방", "액세서리", "모자", "양말"]
    @State private var selectedCategory = "위젯"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 카테고리 영역
                categorySection
                
                Divider()
                
                // 메인 컨텐츠
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(0..<10, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay(
                                    Text("컨텐츠 \(index + 1)")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Lab 12")
        }
    }
    
    private var categorySection: some View {
        ZStack(alignment: .top) {
            // 접힌 상태 (항상 존재, 보이기만 조절)
            collapsedCategoryView
                .opacity(isExpanded ? 0 : 1)
                .frame(height: isExpanded ? 0 : 50)
            
            // 펼쳐진 상태
            if isExpanded {
                expandedCategoryView
//                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(Color(uiColor: .systemBackground))
    }
    
    private var collapsedCategoryView: some View {
        HStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(categories, id: \.self) { category in
                            categoryButton(category)
                                .id(category)
                        }
                    }
                    .padding(.horizontal)
                }
                .onChange(of: selectedCategory) { _, newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            
            // 펼치기 버튼
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded = true
                }
            }) {
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 50)
                    .background(Color(uiColor: .systemBackground))
            }
        }
        .frame(height: 50)
    }
    
    private var expandedCategoryView: some View {
        VStack(spacing: 0) {
            // 접기 버튼
            Button(action: {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded = false
                }
            }) {
                HStack {
                    Text("카테고리")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .frame(height: 50)
            }
            .foregroundColor(.primary)
            
            Divider()
            
            // 세로 그리드
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(categories, id: \.self) { category in
                    categoryButton(category)
                }
            }
            .padding()
        }
    }
    
    private func categoryButton(_ category: String) -> some View {
        Button(action: {
            selectedCategory = category
            // 펼쳐진 상태에서 선택하면 자동으로 접기
            if isExpanded {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded = false
                }
            }
        }) {
            Text(category)
                .font(.system(size: 15, weight: selectedCategory == category ? .bold : .regular))
                .foregroundColor(selectedCategory == category ? .white : .gray)
                .padding(.horizontal, isExpanded ? 12 : 12)
                .padding(.vertical, 8)
                .background(
                    selectedCategory == category ?
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.yellow) : nil
                )
        }
    }
}
