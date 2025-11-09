//
//  Lab11View.swift
//  UI_Lab
//
//  Created by 황상환 on 11/9/25.
//

import SwiftUI

struct Lab11View: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            // New Tab
            NewTabView()
                .tabItem {
                    Label("New", systemImage: "square.grid.2x2")
                }
                .tag(1)
            
            // Radio Tab
            RadioTabView()
                .tabItem {
                    Label("Radio", systemImage: "dot.radiowaves.left.and.right")
                }
                .tag(2)
            
//            // Library Tab
//            LibraryTabView()
//                .tabItem {
//                    Label("Library", systemImage: "music.note.list")
//                }
//                .tag(3)
//            
//            // Search Tab
//            SearchTabView()
//                .tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
//                .tag(4)
        }
        .tabViewStyle(.sidebarAdaptable)
//        .tabViewBottomAccessory {
//            HStack(spacing: 12) {
//                Button(action: {}) {
//                    Image(systemName: "command")
//                        .font(.system(size: 20))
//                        .foregroundStyle(.primary)
//                }
//                
//                Text(".tabViewBottomAccessory")
//                    .font(.headline)
//                
//                Spacer()
//                
//                Button(action: {}) {
//                    Image(systemName: "play.fill")
//                        .font(.system(size: 18))
//                        .foregroundStyle(.primary)
//                }
//                
//                Button(action: {}) {
//                    Image(systemName: "forward.fill")
//                        .font(.system(size: 18))
//                        .foregroundStyle(.primary)
//                }
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 12)
//        }
    }
}

// MARK: - Tab Views
struct HomeTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.opacity(0.1)
                    .ignoresSafeArea()
                
                Text("Home Tab")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Home")
        }
    }
}

struct NewTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.1)
                    .ignoresSafeArea()
                
                Text("New Tab")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("New")
        }
    }
}

struct RadioTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.opacity(0.1)
                    .ignoresSafeArea()
                
                Text("Radio Tab")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Radio")
        }
    }
}

struct LibraryTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.purple.opacity(0.1)
                    .ignoresSafeArea()
                
                Text("Library Tab")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Library")
        }
    }
}

struct SearchTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.pink.opacity(0.1)
                    .ignoresSafeArea()
                
                Text("Search Tab")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .navigationTitle("Search")
        }
    }
}

#Preview {
    Lab11View()
}
