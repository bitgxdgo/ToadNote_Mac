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
            SidebarView(selectedItem: $selectedItem)
        } content: {
            ContentListView(searchText: $searchText)
        } detail: {
            NoteDetailView()
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

#Preview {
    ContentView()
}
