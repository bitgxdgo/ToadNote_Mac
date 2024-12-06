// import SwiftUI

// struct SidebarView: View {
//     @ObservedObject var viewModel: SidebarViewModel
//     @State private var isNavigating = false
    
//     private enum SidebarItem: String {
//         case work = "work_folder"
//         case personal = "personal_folder"
//         case notes = "all_notes"
//         case todo = "todo"
//         case favorites = "favorites"
//     }
    
//     var body: some View {
//         ZStack(alignment: .bottom) {
//             List(selection: Binding(
//                 get: { viewModel.selectedItemId },
//                 set: { newValue in
//                     if let newValue = newValue {
//                         if let folder = findFolder(by: newValue, in: viewModel.rootFolders) {
//                             viewModel.updateSelectedFolder(with: folder)
//                         }
//                     }
//                     viewModel.selectedItemId = newValue
//                 }
//             )) {
//                 Section("笔记本") {
//                     NavigationLink(value: SidebarItem.work.rawValue) {
//                         Label("工作", systemImage: "briefcase")
//                     }
//                     NavigationLink(value: SidebarItem.personal.rawValue) {
//                         Label("个人", systemImage: "person")
//                     }
                    
//                     ForEach(viewModel.rootFolders) { folder in
//                         FolderView(viewModel: viewModel, folder: folder, level: 0)
//                             .onChange(of: viewModel.selectedItemId) { newValue in
//                                 if newValue == folder.id.uuidString {
//                                     viewModel.updateSelectedFolder(with: folder)
//                                 }
//                             }
//                     }
//                 }
                
//                 Section("收藏夹") {
//                     NavigationLink(value: SidebarItem.notes.rawValue) {
//                         Label("所有笔记", systemImage: "note.text")
//                     }
//                     NavigationLink(value: SidebarItem.todo.rawValue) {
//                         Label("待办事项", systemImage: "checklist")
//                     }
//                     NavigationLink(value: SidebarItem.favorites.rawValue) {
//                         Label("收藏内容", systemImage: "star")
//                     }
//                 }
//             }
            
            
//             // 新建文件夹按钮
//             VStack {
//                 Spacer()
//                 Button(action: {
//                     viewModel.showCreateRootFolderSheet = true
//                 }) {
//                     HStack {
//                         Image(systemName: "plus.circle.fill")
//                         Text("新建文件夹")
//                     }
//                     .padding(10)
//                     .frame(maxWidth: .infinity, alignment: .leading)
//                     .background(Color(NSColor.windowBackgroundColor))
//                     .cornerRadius(6)
//                 }
//                 .buttonStyle(.plain)
//                 .padding(.horizontal, 10)
//                 .padding(.bottom, 10)
//             }
//         }
//         .sheet(isPresented: $viewModel.showCreateRootFolderSheet) {
//             CreateFolderSheet(viewModel: viewModel)
//         }
//         .sheet(isPresented: $viewModel.showCreateSubFolderSheet) {
//             CreateFolderSheet(viewModel: viewModel, parentFolder: viewModel.selectedFolder)
//         }
//     }
    
//     func findFolder(by id: String, in folders: [Folder]) -> Folder? {
//     print("开始查找文件夹 ID: \(id)")  // 打印开始查找的 ID
    
//     for folder in folders {
//         if folder.id.uuidString == id {
//             if let parent = folder.parentFolder {
//                 print("找到子文件夹: \(folder.name)，父文件夹: \(parent.name)")
//             } else {
//                 print("找到根文件夹: \(folder.name)")
//             }
//             return folder
//         }
//         if let found = findFolder(by: id, in: Array(folder.subFolders)) {
//             return found
//         }
//         }
//         return nil
//     }
// }
import SwiftUI

struct SidebarView: View {
    @ObservedObject var viewModel: SidebarViewModel
    
    private enum SidebarItem: String {
        case work = "work_folder"
        case personal = "personal_folder"
        case notes = "all_notes"
        case todo = "todo"
        case favorites = "favorites"
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List(selection: Binding(
                get: { viewModel.selectedItemId },
                set: { viewModel.updateSelection(folderId: $0) }
            )) {
                Section("笔记本") {
                    // 固定的导航项
                    NavigationLink(value: SidebarItem.work.rawValue) {
                        Label("工作", systemImage: "briefcase")
                    }
                    NavigationLink(value: SidebarItem.personal.rawValue) {
                        Label("个人", systemImage: "person")
                    }
                    
                    // 文件夹列表
                    ForEach(viewModel.rootFolders) { folder in
                        FolderView(viewModel: viewModel, folder: folder, level: 0)
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
            
            // 新建文件夹按钮
            VStack {
                Spacer()
                Button(action: {
                    viewModel.showCreateRootFolderSheet = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("新建文件夹")
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
        }
        .sheet(isPresented: $viewModel.showCreateRootFolderSheet) {
            CreateFolderSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showCreateSubFolderSheet) {
            CreateFolderSheet(viewModel: viewModel, parentFolder: viewModel.selectedFolder)
        }
    }
}