import Foundation
import CoreData

class NoteManager {
    private let context: NSManagedObjectContext
    private let contentBlockManager: ContentBlockManager
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.contentBlockManager = ContentBlockManager(context: context)
    }
    
    // 创建新笔记
    func createNote(title: String, folder: Folder?) throws -> Note {
        let note = Note(context: context)
        note.id = UUID()
        note.title = title
        note.createdAt = Date()
        note.updatedAt = Date()
        note.folder = folder
        note.tags = []
        note.contentBlocks = []
        
        try context.save()
        return note
    }
    
    // 更新笔记标题
    func updateTitle(_ note: Note, newTitle: String) throws {
        note.title = newTitle
        note.updatedAt = Date()
        try context.save()
    }
    
    // 更新笔记标签
    func updateTags(_ note: Note, tags: Set<String>) throws {
        note.tags = tags
        note.updatedAt = Date()
        try context.save()
    }
    
    // 更新向量ID
    func updateVectorId(_ note: Note, vectorId: UUID) throws {
        note.vectorId = vectorId
        note.updatedAt = Date()
        try context.save()
    }
    
    // 移动笔记到新文件夹
    func moveNote(_ note: Note, to folder: Folder?) throws {
        note.folder = folder
        note.updatedAt = Date()
        try context.save()
    }
    
    // 获取文件夹中的所有笔记
    func fetchNotes(in folder: Folder?) throws -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        if let folder = folder {
            request.predicate = NSPredicate(format: "folder == %@", folder)
        } else {
            request.predicate = NSPredicate(format: "folder == nil")
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.updatedAt, ascending: false)]
        return try context.fetch(request)
    }
    
    // 搜索笔记
    func searchNotes(query: String) throws -> [Note] {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
        return try context.fetch(request)
    }
    
    // 删除笔记
    func deleteNote(_ note: Note) throws {
        // 删除所有关联的内容块
        for block in note.contentBlocks {
            try contentBlockManager.deleteBlock(block)
        }
        
        context.delete(note)
        try context.save()
    }
}
