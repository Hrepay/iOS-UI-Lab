//
//  TaggingImageView.swift
//  UI_Lab
//
//  Created by 황상환 on 7/10/25.
//

import SwiftUI

struct Tag: Identifiable, Codable {
    let id = UUID()
    var text: String
    var relativeX: CGFloat
    var relativeY: CGFloat

    enum CodingKeys: String, CodingKey {
        case text, relativeX, relativeY
    }

    func absolutePosition(in size: CGSize) -> CGPoint {
        CGPoint(x: relativeX * size.width, y: relativeY * size.height)
    }

    static func from(location: CGPoint, in size: CGSize, text: String = "태그") -> Tag {
        Tag(text: text, relativeX: location.x / size.width, relativeY: location.y / size.height)
    }
}

struct TaggingImageView: View {
    @State private var tags: [Tag] = []
    @State private var imageSize: CGSize = .zero

    var body: some View {
        VStack {
            GeometryReader { geo in
                ZStack {
                    HStack {
                        Image("test_img")
                            .resizable()
                            .scaledToFit()
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear {
                                            imageSize = proxy.size
                                        }
                                        .onChange(of: proxy.size) { newSize in
                                            imageSize = newSize
                                        }
                                }
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    ForEach($tags) { $tag in
                        Text(tag.text)
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                            .position(tag.absolutePosition(in: imageSize))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        tag.relativeX = value.location.x / imageSize.width
                                        tag.relativeY = value.location.y / imageSize.height
                                    }
                            )
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    let relativeX = location.x / imageSize.width
                    let relativeY = location.y / imageSize.height
                    let newTagText = "태그 \(tags.count)"
                    tags.append(Tag(text: newTagText, relativeX: relativeX, relativeY: relativeY))
                }
            }

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
                .listStyle(.insetGrouped) // 원하는 스타일로 변경 가능
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Spacer()

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
            loadTags()
        }
        .navigationTitle("태그 테스트")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveTags() {
        do {
            let data = try JSONEncoder().encode(tags)
            UserDefaults.standard.set(data, forKey: "savedTags")
            print("태그 저장 완료")
        } catch {
            print("태그 저장 실패: \(error)")
        }
    }

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
