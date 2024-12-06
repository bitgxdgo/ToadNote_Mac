import Foundation
import CoreData

// class SidebarViewModel: ObservableObject {
//     private let folderManager: FolderManager
    
//     @Published var rootFolders: [Folder] = []
//     @Published var showCreateFolderSheet = false
//     @Published var showCreateRootFolderSheet = false
//     @Published var newFolderName: String = ""
//     @Published var error: Error?
//     @Published var selectedFolder: Folder?
//     @Published var selectedItemId: String?
//     @Published var showCreateSubFolderSheet = false
//     @Published var expandedFolders: Set<UUID> = []  // 记录展开状态的文件夹ID
//     @Published var folders: [Folder] = []
    
//     init(context: NSManagedObjectContext) {
//         self.folderManager = FolderManager(context: context)
//         loadFolders()
//     }
    
//     // 加载文件夹
//     private func loadFolders() {
//         do {
//             rootFolders = try folderManager.fetchRootFolders()
//             print("\n当前所有根文件夹:")
//             rootFolders.forEach { folder in
//                 print("- \(folder.name) (创建于: \(folder.createdAt))")
//             }
//         } catch {
//             print("加载文件夹失败: \(error.localizedDescription)")
//             self.error = error
//         }
//     }
    
//     // 创建新文件夹
//     func createFolder(name: String, parent: Folder? = nil) {
//         do {
//             let newFolder = try folderManager.createFolder(name: name, parentFolder: parent)
//             loadFolders()
//         } catch {
//             self.error = error
//         }
//     }
    
//     // 删除文件夹
//     func deleteFolder(_ folder: Folder) {
//         do {
//             try folderManager.deleteFolder(folder)
//             loadFolders()
//         } catch {
//             self.error = error
//         }
//     }
    
//     // 创建根文件夹
//     func createRootFolder() {
//         guard !newFolderName.isEmpty else { return }
        
//         do {
//             let newFolder = try folderManager.createFolder(name: newFolderName)
//             print("成功创建文件夹:")
//             print("- 名称: \(newFolder.name)")
//             print("- ID: \(newFolder.id)")
            
//             loadFolders()
//             selectedFolder = newFolder
//             selectedItemId = newFolder.id.uuidString
            
//             newFolderName = ""
//             showCreateRootFolderSheet = false
//         } catch {
//             print("创建文件夹失败: \(error.localizedDescription)")
//             self.error = error
//         }
//     }
    
//     // 创建子文件夹
//     func createSubFolder(name: String, parentFolder: Folder) {
//         do {
//             let newFolder = try folderManager.createFolder(name: name, parentFolder: parentFolder)
//             loadFolders()
//             selectedFolder = newFolder
//             selectedItemId = newFolder.id.uuidString
//         } catch {
//             self.error = error
//         }
//     }
    
//     func toggleFolderExpansion(_ folder: Folder) {
//         if expandedFolders.contains(folder.id) {
//             expandedFolders.remove(folder.id)
//         } else {
//             expandedFolders.insert(folder.id)
//         }
//     }
    
//     func hasNotes(in folder: Folder) -> Bool {
//         if !folder.notes.isEmpty {
//             return true
//         }
//         for subFolder in folder.subFolders {
//             if hasNotes(in: subFolder) {
//                 return true
//             }
//         }
//         return false
//     }
    
//     // 修改更新选中文件夹的方法
//     func updateSelectedFolder(with folder: Folder) {
//         // 只有当选中的文件夹真的改变时才更新
//         if selectedFolder?.id != folder.id {
//             selectedItemId = folder.id.uuidString
//             selectedFolder = folder
//             print("选中文件夹: \(folder.name), ID: \(selectedItemId ?? "无")")
//         }
//     }
// }
class SidebarViewModel: ObservableObject {
    private let folderManager: FolderManager
    
    @Published var rootFolders: [Folder] = []
    @Published var showCreateFolderSheet = false
    @Published var showCreateRootFolderSheet = false
    @Published var newFolderName: String = ""
    @Published var error: Error?
    @Published var selectedFolder: Folder?
    @Published var selectedItemId: String?
    @Published var showCreateSubFolderSheet = false
    @Published var expandedFolders: Set<UUID> = []
    @Published var folders: [Folder] = []
    
    init(context: NSManagedObjectContext) {
        self.folderManager = FolderManager(context: context)
        loadFolders()
    }
    
    // 统一的选中状态管理方法
    func updateSelection(folderId: String?) {
        print("更新选中状态: \(folderId ?? "nil")")
        
        if folderId == nil {
            selectedItemId = nil
            selectedFolder = nil
            print("清除选中状态")
            return
        }
        
        if let folder = findFolder(by: folderId!, in: rootFolders) {
            selectedItemId = folderId
            selectedFolder = folder
            print("选中文件夹: \(folder.name), ID: \(folderId!)")
        } else {
            print("未找到对应文件夹: \(folderId!)")
        }
    }
    
    // 私有的查找方法
    private func findFolder(by id: String, in folders: [Folder]) -> Folder? {
        for folder in folders {
            if folder.id.uuidString == id {
                return folder
            }
            if let found = findFolder(by: id, in: Array(folder.subFolders)) {
                return found
            }
        }
        return nil
    }
    
    // 加载文件夹
    private func loadFolders() {
        do {
            rootFolders = try folderManager.fetchRootFolders()
            print("\n当前所有根文件夹:")
            rootFolders.forEach { folder in
                print("- \(folder.name) (创建于: \(folder.createdAt))")
            }
        } catch {
            print("加载文件夹失败: \(error.localizedDescription)")
            self.error = error
        }
    }
    
    // 创建新文件夹
    func createFolder(name: String, parent: Folder? = nil) {
        do {
            let newFolder = try folderManager.createFolder(name: name, parentFolder: parent)
            loadFolders()
            updateSelection(folderId: newFolder.id.uuidString)  // 使用统一的方法
        } catch {
            self.error = error
        }
    }
    
    // 删除文件夹
    func deleteFolder(_ folder: Folder) {
        do {
            let folderId = folder.id.uuidString
            try folderManager.deleteFolder(folder)
            loadFolders()
            
            // 如果删除的是当前选中的文件夹，清除选中状态
            if selectedItemId == folderId {
                updateSelection(folderId: nil)
            }
        } catch {
            self.error = error
        }
    }
    
    // 创建根文件夹
    func createRootFolder() {
        guard !newFolderName.isEmpty else { return }
        
        do {
            let newFolder = try folderManager.createFolder(name: newFolderName)
            loadFolders()
            updateSelection(folderId: newFolder.id.uuidString)
            
            newFolderName = ""
            showCreateRootFolderSheet = false
        } catch {
            print("创建文件夹失败: \(error.localizedDescription)")
            self.error = error
        }
    }
    
    // 创建子文件夹
    func createSubFolder(name: String, parentFolder: Folder) {
        do {
            let newFolder = try folderManager.createFolder(name: name, parentFolder: parentFolder)
            loadFolders()
            updateSelection(folderId: newFolder.id.uuidString)
        } catch {
            self.error = error
        }
    }
    
    // 文件夹展开/折叠
    func toggleFolderExpansion(_ folder: Folder) {
        if expandedFolders.contains(folder.id) {
            expandedFolders.remove(folder.id)
        } else {
            expandedFolders.insert(folder.id)
        }
    }
    
    // 检查文件夹是否包含笔记
    func hasNotes(in folder: Folder) -> Bool {
        if !folder.notes.isEmpty {
            return true
        }
        for subFolder in folder.subFolders {
            if hasNotes(in: subFolder) {
                return true
            }
        }
        return false
    }
}