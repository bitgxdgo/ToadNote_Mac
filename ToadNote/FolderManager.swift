import CoreData

class FolderManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // 获取所有顶级文件夹
    func fetchRootFolders() throws -> [Folder] {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        request.predicate = NSPredicate(format: "parentFolder == nil")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        return try context.fetch(request)
    }
    
    // 创建新文件夹
    func createFolder(name: String, parentFolder: Folder? = nil) throws -> Folder {
        let folder = Folder(context: context)
        folder.id = UUID()
        folder.name = name
        folder.createdAt = Date()
        folder.updatedAt = Date()
        
        if let parent = parentFolder {
            folder.parentFolder = parent
            parent.addToSubFolders(folder)
        }
        
        try context.save()
        return folder
    }
    
    // 删除文件夹
    func deleteFolder(_ folder: Folder) throws {
        // 递归删除所有子文件夹
        let subFolders = folder.subFolders
        for subFolder in subFolders {
            try deleteFolder(subFolder)
        }
        
        context.delete(folder)
        try context.save()
    }
    
    // 重命名文件夹
    func renameFolder(_ folder: Folder, newName: String) throws {
        // 检查名称是否为空
        guard !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FolderError.invalidName("文件夹名称不能为空")
        }
        
        // 检查同级文件夹中是否有重名
        if let parent = folder.parentFolder {
            let siblings = parent.subFolders
            if siblings.contains(where: { $0.id != folder.id && $0.name == newName }) {
                throw FolderError.duplicateName("同一层级下已存在同名文件夹")
            }
        } else {
            // 检查根文件夹是否重名
            let rootFolders = try fetchRootFolders()
            if rootFolders.contains(where: { $0.id != folder.id && $0.name == newName }) {
                throw FolderError.duplicateName("根目录下已存在同名文件夹")
            }
        }
        
        // 更新文件夹信息
        folder.name = newName
        folder.updatedAt = Date()
        
        // 保存更改
        try context.save()
    }
}

// 添加错误类型
enum FolderError: LocalizedError {
    case invalidName(String)
    case duplicateName(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidName(let message):
            return message
        case .duplicateName(let message):
            return message
        }
    }
}
