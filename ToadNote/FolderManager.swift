import CoreData

class FolderManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // 创建新文件夹
    func createFolder(name: String, parentFolder: Folder? = nil) throws -> Folder {
        let folder = Folder(context: context)
        folder.id = UUID()
        folder.name = name
        folder.createdAt = Date()
        folder.updatedAt = Date()
        folder.parentFolder = parentFolder
        folder.parentFolderId = parentFolder?.id
        
        try context.save()
        return folder
    }
    
    // 获取所有顶级文件夹
    func fetchRootFolders() throws -> [Folder] {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        request.predicate = NSPredicate(format: "parentFolder == nil")
        return try context.fetch(request)
    }
    
    // 获取指定文件夹的子文件夹
    func fetchSubFolders(for folder: Folder) throws -> [Folder] {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        request.predicate = NSPredicate(format: "parentFolder == %@", folder)
        return try context.fetch(request)
    }
    
    // 更新文件夹
    func updateFolder(_ folder: Folder, newName: String) throws {
        folder.name = newName
        folder.updatedAt = Date()
        try context.save()
    }
    
    // 删除文件夹
    func deleteFolder(_ folder: Folder) throws {
        context.delete(folder)
        try context.save()
    }
}
