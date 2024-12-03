import Foundation
import CoreData

class SidebarViewModel: ObservableObject {
    private let folderManager: FolderManager
    
    @Published var rootFolders: [Folder] = []
    @Published var showCreateFolderSheet = false
    @Published var showCreateRootFolderSheet = false
    @Published var newFolderName: String = ""
    @Published var error: Error?
    @Published var selectedFolder: Folder?
    @Published var selectedItemId: String?
    
    init(context: NSManagedObjectContext) {
        self.folderManager = FolderManager(context: context)
        loadFolders()
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
        } catch {
            self.error = error
        }
    }
    
    // 删除文件夹
    func deleteFolder(_ folder: Folder) {
        do {
            try folderManager.deleteFolder(folder)
            loadFolders()
        } catch {
            self.error = error
        }
    }
    
    // 创建根文件夹
    func createRootFolder() {
        guard !newFolderName.isEmpty else { return }
        
        do {
            let newFolder = try folderManager.createFolder(name: newFolderName)
            print("成功创建文件夹:")
            print("- 名称: \(newFolder.name)")
            print("- ID: \(newFolder.id)")
            
            loadFolders()
            selectedFolder = newFolder
            selectedItemId = newFolder.id.uuidString
            
            newFolderName = ""
            showCreateRootFolderSheet = false
        } catch {
            print("创建文件夹失败: \(error.localizedDescription)")
            self.error = error
        }
    }
}
