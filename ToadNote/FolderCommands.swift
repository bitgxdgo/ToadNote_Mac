import SwiftUI

struct FolderCommands: Commands {
    @ObservedObject private var sidebarViewModel: SidebarViewModel
    
    init(sidebarViewModel: SidebarViewModel) {
        self.sidebarViewModel = sidebarViewModel
        print("FolderCommands initialized")
    }
    
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("新建文件夹") {
                sidebarViewModel.showCreateRootFolderSheet = true
            }
            .keyboardShortcut("n", modifiers: [.command, .shift])
        }
    }
}
