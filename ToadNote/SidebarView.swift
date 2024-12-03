import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: SidebarViewModel
    
    // 定义固定项目的标识符
    private enum SidebarItem: String {
        case work = "work_folder"
        case personal = "personal_folder"
        case notes = "all_notes"
        case todo = "todo"
        case favorites = "favorites"
    }
    
    var body: some View {
        List(selection: Binding(
            get: { viewModel.selectedItemId },
            set: { viewModel.selectedItemId = $0 }
        )) {
            Section("笔记本") {
                NavigationLink(value: SidebarItem.work.rawValue) {
                    Label("工作", systemImage: "briefcase")
                }
                NavigationLink(value: SidebarItem.personal.rawValue) {
                    Label("个人", systemImage: "person")
                }
                
                // 动态文件夹放在固定项目后面
                ForEach(viewModel.rootFolders) { folder in
                    NavigationLink(value: folder.id.uuidString) {
                        Label(folder.name, systemImage: "folder")
                    }
                }
            }
            
            Section("收藏夹") {
                NavigationLink(value: SidebarItem.notes.rawValue) {
                    Label("所有笔记", systemImage: "note.text")
                }
                NavigationLink(value: SidebarItem.todo.rawValue) {
                    Label("待办事项", systemImage: "checklist")
                }
                NavigationLink(value: SidebarItem.favorites.rawValue) {
                    Label("收藏内容", systemImage: "star")
                }
            }
        }
        .onChange(of: viewModel.selectedItemId) { newValue in
            if let newValue = newValue,
               let folder = viewModel.rootFolders.first(where: { $0.id.uuidString == newValue }) {
                viewModel.selectedFolder = folder
            }
        }
    }
}