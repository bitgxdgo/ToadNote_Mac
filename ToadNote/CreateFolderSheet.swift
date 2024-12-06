import SwiftUI

struct CreateFolderSheet: View {
    @ObservedObject var viewModel: SidebarViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showToast = false
    @State private var toastMessage = ""
    var parentFolder: Folder?
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
                Text(parentFolder == nil ? "新建文件夹" : "新建子文件夹")
                    .font(.headline)
                
                TextField("文件夹名称", text: $viewModel.newFolderName)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                    .onChange(of: viewModel.newFolderName) { newValue in
                        if newValue.count > 30 {
                            viewModel.newFolderName = String(newValue.prefix(30))
                        }
                    }
                
                HStack {
                    Button("取消") {
                        viewModel.newFolderName = ""
                        dismiss()
                    }
                    
                    Button("创建") {
                        if viewModel.newFolderName.isEmpty {
                            toastMessage = "创建文件夹失败，文件名不能为空"
                            withAnimation {
                                showToast = true
                            }
                        } else if let parent = parentFolder {
                            let existingSubfolderNames = parent.subFolders.map { $0.name }
                            print("⚠️ 子文件夹重名检查 - 新建: '\(viewModel.newFolderName)'")
                            print("⚠️ 子文件夹重名检查 - 已存在: \(existingSubfolderNames)")
                            
                            if existingSubfolderNames.contains(where: { name in
                                let isDuplicate = name.localizedCaseInsensitiveCompare(viewModel.newFolderName) == .orderedSame
                                if isDuplicate {
                                    print("⚠️ 子文件夹重名检查 - 结果: 文件夹'\(name)'已存在")
                                }
                                return isDuplicate
                            }) {
                                toastMessage = "创建文件夹失败，文件名重复，请修改文件名"
                                withAnimation {
                                    showToast = true
                                }
                            } else {
                                viewModel.createSubFolder(name: viewModel.newFolderName, parentFolder: parent)
                                dismiss()
                            }
                        } else {
                            let existingRootFolderNames = viewModel.rootFolders.map { $0.name }
                            print("⚠️ 根文件夹重名检查 - 新建: '\(viewModel.newFolderName)'")
                            print("⚠️ 根文件夹重名检查 - 已存在: \(existingRootFolderNames)")
                            
                            if existingRootFolderNames.contains(where: { name in
                                let isDuplicate = name.localizedCaseInsensitiveCompare(viewModel.newFolderName) == .orderedSame
                                if isDuplicate {
                                    print("⚠️ 根文件夹重名检查 - 结果: 文件夹'\(name)'已存在")
                                }
                                return isDuplicate
                            }) {
                                toastMessage = "创建文件夹失败，文件名重复，请修改文件名"
                                withAnimation {
                                    showToast = true
                                }
                            } else {
                                viewModel.createRootFolder()
                                dismiss()
                            }
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .padding()
            .frame(width: 300)
            .background(Color(NSColor.windowBackgroundColor))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 10)
            
            if showToast {
                Text(toastMessage)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .offset(y:0)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
