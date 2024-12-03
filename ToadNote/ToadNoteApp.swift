//
//  ToadNoteApp.swift
//  ToadNote
//
//  Created by Zhuanz1密码0000 on 2024/11/27.
//

import SwiftUI
import CoreData

@main
struct ToadNoteApp: App {
    @StateObject private var sidebarViewModel: SidebarViewModel
    
    init() {
        print("开始初始化 ToadNoteApp")
        let context = PersistenceController.shared.container.viewContext
        print("获取到 CoreData context")
        _sidebarViewModel = StateObject(wrappedValue: SidebarViewModel(context: context))
        print("ToadNoteApp initialized")
    }
    
    var body: some Scene {
        print("ToadNoteApp body 被调用")
        return WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(sidebarViewModel)
                .sheet(isPresented: $sidebarViewModel.showCreateRootFolderSheet) {
                    CreateFolderSheet(viewModel: sidebarViewModel)
                }
        }
        .commands {
            FolderCommands(sidebarViewModel: sidebarViewModel)
        }
    }
}
