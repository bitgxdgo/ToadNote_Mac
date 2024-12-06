// import SwiftUI

// struct FolderView: View {
//     @ObservedObject var viewModel: SidebarViewModel
//     let folder: Folder
//     let level: Int
    
//     var body: some View {
//         Group {
//             NavigationLink(value: folder.id.uuidString) {
//                 HStack {
//                     if !folder.subFolders.isEmpty {
//                         Image(systemName: viewModel.expandedFolders.contains(folder.id) ? "chevron.down" : "chevron.right")
//                             .font(.system(size: 12))
//                             .onTapGesture {
//                                 withAnimation {
//                                     viewModel.toggleFolderExpansion(folder)
//                                 }
//                             }
//                     } else {
//                         Image(systemName: "circle.fill")
//                             .font(.system(size: 6))
//                             .opacity(0.0)
//                             .padding(.horizontal, 4)
//                     }
                    
//                     Label(folder.name, systemImage: "folder")
//                         .contentShape(Rectangle())
//                 }
//                 .padding(.leading, CGFloat(level * 16))
//             }
//             .contextMenu {
//                 Button(action: {
//                     viewModel.selectedFolder = folder
//                     viewModel.showCreateSubFolderSheet = true
//                 }) {
//                     Label("新建子文件夹", systemImage: "folder.badge.plus")
//                 }
//             }
            
//             if viewModel.expandedFolders.contains(folder.id) {
//                 ForEach(Array(folder.subFolders), id: \.id) { subFolder in
//                     FolderView(viewModel: viewModel, folder: subFolder, level: level + 1)
//                 }
//             }
//         }
//     }
// }
import SwiftUI

struct FolderView: View {
    @ObservedObject var viewModel: SidebarViewModel
    let folder: Folder
    let level: Int
    
    var body: some View {
        Group {
            NavigationLink(value: folder.id.uuidString) {
                HStack {
                    // 展开/折叠图标
                    if !folder.subFolders.isEmpty {
                        Image(systemName: viewModel.expandedFolders.contains(folder.id) ? "chevron.down" : "chevron.right")
                            .font(.system(size: 12))
                            .onTapGesture {
                                withAnimation {
                                    viewModel.toggleFolderExpansion(folder)
                                }
                            }
                    } else {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .opacity(0.0)
                            .padding(.horizontal, 4)
                    }
                    
                    // 文件夹图标和名称
                    Label(folder.name, systemImage: "folder")
                        .contentShape(Rectangle())
                }
                .padding(.leading, CGFloat(level * 16))
            }
            .contextMenu {
                Button(action: {
                    // 使用统一的选中状态更新方法
                    viewModel.updateSelection(folderId: folder.id.uuidString)
                    viewModel.showCreateSubFolderSheet = true
                }) {
                    Label("新建子文件夹", systemImage: "folder.badge.plus")
                }
                
                // 可以在这里添加更多的上下文菜单项，比如删除文件夹
                Button(role: .destructive, action: {
                    viewModel.deleteFolder(folder)
                }) {
                    Label("删除文件夹", systemImage: "trash")
                }
            }
            
            // 子文件夹递归展示
            if viewModel.expandedFolders.contains(folder.id) {
                ForEach(Array(folder.subFolders), id: \.id) { subFolder in
                    FolderView(viewModel: viewModel, folder: subFolder, level: level + 1)
                }
            }
        }
    }
}