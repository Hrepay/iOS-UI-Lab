//
//  TaggingImageView.swift
//  UI_Lab
//
//  Created by 황상환 on 7/10/25.
//

import SwiftUI

/// 태그 모델: 이미지 내 상대 위치와 텍스트 정보를 포함
struct Tag: Identifiable, Codable {
    let id = UUID()
    var text: String
    var relativeX: CGFloat
    var relativeY: CGFloat

    enum CodingKeys: String, CodingKey {
        case text, relativeX, relativeY
    }

    /// 실제 이미지 뷰 크기 기준 절대 좌표 반환
    func absolutePosition(in size: CGSize) -> CGPoint {
        CGPoint(x: relativeX * size.width, y: relativeY * size.height)
    }

    /// 현재 터치 위치 기준 상대 위치로부터 Tag 생성
    static func from(location: CGPoint, in size: CGSize, text: String = "태그") -> Tag {
        Tag(text: text, relativeX: location.x / size.width, relativeY: location.y / size.height)
    }
}

/// 태그 추가/표시/이동 가능한 이미지 뷰
struct TaggingImageView: View {
    @State private var tags: [Tag] = [] // 현재 이미지 위에 표시할 태그들
    @State private var imageSize: CGSize = .zero // 이미지 뷰의 크기 (좌표 계산용)

    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    // 이미지 표시 (중앙 정렬)
                    HStack {
                        Image("test_img")
                            .resizable()
                            .scaledToFit()
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear {
                                            imageSize = proxy.size // 이미지 크기 저장
                                        }
                                        .onChange(of: proxy.size) { newSize in
                                            imageSize = newSize
                                        }
                                }
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    // 태그들 렌더링 및 드래그 제스처
                    ForEach($tags) { $tag in
                        Text(tag.text)
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .position(tag.absolutePosition(in: imageSize)) // 절대 좌표로 위치
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        // 드래그 시 상대 위치 업데이트
                                        tag.relativeX = value.location.x / imageSize.width
                                        tag.relativeY = value.location.y / imageSize.height
                                    }
                            )
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    // 탭 시 새로운 태그 추가
                    let relativeX = location.x / imageSize.width
                    let relativeY = location.y / imageSize.height
                    let newTagText = "태그 \(tags.count)"
                    tags.append(Tag(text: newTagText, relativeX: relativeX, relativeY: relativeY))
                }
            }

            // 태그 리스트 뷰
            VStack(alignment: .leading, spacing: 4) {
                Text("태그 리스트")
                    .font(.headline)
                    .padding(.top)

                List {
                    ForEach(tags) { tag in
                        Text(tag.text)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxHeight: .infinity)
                .listStyle(.insetGrouped)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)

            Spacer()

            // 저장 및 전체 삭제 버튼
            HStack {
                Button("저장하기") {
                    saveTags()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)

                Button("전체 삭제") {
                    tags.removeAll()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding(.top)

            Spacer()
        }
        .onAppear {
            loadTags() // 뷰가 등장할 때 저장된 태그 불러오기
        }
        .navigationTitle("태그 테스트")
        .navigationBarTitleDisplayMode(.inline)
    }

    /// 태그를 UserDefaults에 저장
    private func saveTags() {
        do {
            let data = try JSONEncoder().encode(tags)
            UserDefaults.standard.set(data, forKey: "savedTags")
            print("태그 저장 완료")
        } catch {
            print("태그 저장 실패: \(error)")
        }
    }

    /// 저장된 태그 불러오기
    private func loadTags() {
        if let data = UserDefaults.standard.data(forKey: "savedTags") {
            do {
                tags = try JSONDecoder().decode([Tag].self, from: data)
                print("태그 불러오기 완료")
            } catch {
                print("태그 불러오기 실패: \(error)")
            }
        }
    }
}
