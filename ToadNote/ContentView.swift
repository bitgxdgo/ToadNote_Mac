//
//  ContentView.swift
//  ToadNote
//
//  Created by Zhuanz1密码0000 on 2024/11/27.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedItem: String? = "笔记"
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationSplitView {
            // 侧边栏
            Sidebar(selectedItem: $selectedItem)
        } content: {
            // 内容列表
            ContentList(searchText: $searchText)
        } detail: {
            // 详情视图
            DetailView()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
}

// 侧边栏视图
struct Sidebar: View {
    @Binding var selectedItem: String?
    
    var body: some View {
        List(selection: $selectedItem) {
            Section("收藏夹") {
                NavigationLink(value: "笔记") {
                    Label("所有笔记", systemImage: "note.text")
                }
                NavigationLink(value: "待办") {
                    Label("待办事项", systemImage: "checklist")
                }
                NavigationLink(value: "收藏") {
                    Label("收藏内容", systemImage: "star")
                }
            }
            
            Section("笔记本") {
                NavigationLink(value: "工作") {
                    Label("工作", systemImage: "briefcase")
                }
                NavigationLink(value: "个人") {
                    Label("个人", systemImage: "person")
                }
            }
        }
    }
}

// 内容列表视图
struct ContentList: View {
    @Binding var searchText: String
    
    var body: some View {
        List {
            ForEach(1...10, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text("笔记标题 \(index)")
                        .font(.headline)
                    Text("最后编辑时间: 2024/3/20")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .searchable(text: $searchText, prompt: "搜索笔记")
    }
}

// 详情视图
struct DetailView: View {
    @State private var noteText: String = "在这里输入笔记内容..."
    
    var body: some View {
        TextEditor(text: $noteText)
            .font(.body)
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {}) {
                        Image(systemName: "textformat")
                    }
                    Button(action: {}) {
                        Image(systemName: "photo")
                    }
                    Button(action: {}) {
                        Image(systemName: "link")
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
