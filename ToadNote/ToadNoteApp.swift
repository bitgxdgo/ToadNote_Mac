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
    @StateObject private var sidebarViewModel = ViewModelContainer.shared.sidebarViewModel
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(sidebarViewModel)
        }
        .commands {
            FolderCommands(sidebarViewModel: sidebarViewModel)
        }
    }
}
