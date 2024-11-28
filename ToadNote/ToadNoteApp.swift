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
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
