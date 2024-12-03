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
}
