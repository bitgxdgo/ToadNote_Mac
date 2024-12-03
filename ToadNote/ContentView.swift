//
//  ContentView.swift
//  ToadNote
//
//  Created by Zhuanz1密码0000 on 2024/11/27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        NavigationSplitView {
            SidebarView(viewModel: sidebarViewModel)
        } content: {
            ContentListView(
                searchText: .constant(""),
                context: context
            )
            .environmentObject(sidebarViewModel)
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
