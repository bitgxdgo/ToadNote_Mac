import SwiftUI

struct FolderView: View {
    @ObservedObject var viewModel: SidebarViewModel
    let folder: Folder
    let level: Int
    @FocusState private var isTextFieldFocused: Bool
    
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
                    
                    // 文件夹图标
                    Image(systemName: "folder")
                    
                    // 文件夹名称（可编辑状态）
                    if viewModel.renamingFolderId == folder.id {
                        TextField("文件夹名称", text: $viewModel.editingName)
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                viewModel.saveRename()
                            }
                            .onExitCommand {
                                viewModel.cancelRename()
                            }
                            .onChange(of: viewModel.renamingFolderId) { newValue in
                                if newValue == folder.id {
                                    isTextFieldFocused = true
                                }
                            }
                    } else {
                        Text(folder.name)
                    }
                }
                .padding(.leading, CGFloat(level * 16))
            }
            .contextMenu {
                Button(action: {
                    viewModel.updateSelection(folderId: folder.id.uuidString)
                    viewModel.showCreateSubFolderSheet = true
                }) {
                    Label("新建子文件夹", systemImage: "folder.badge.plus")
                }
                
                Button(action: {
                    viewModel.startRenaming(folder)
                    // 使用 DispatchQueue 确保在下一个运行循环中设置焦点
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isTextFieldFocused = true
                    }
                }) {
                    Label("重命名", systemImage: "pencil")
                }
                
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