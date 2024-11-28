import Foundation
import CoreData

class ContentBlockManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createContentBlock(type: ContentType, content: String, orderIndex: Int32, note: Note) throws -> ContentBlock {
        let block = ContentBlock(context: context)
        block.id = UUID()
        block.type = type.rawValue
        block.content = content
        block.createdAt = Date()
        block.orderIndex = orderIndex
        block.note = note
        
        try context.save()
        return block
    }
    
    func updateContent(_ block: ContentBlock, newContent: String) throws {
        block.content = newContent
        block.updatedAt = Date()
        try context.save()
    }
    
    func updateMetadata(_ block: ContentBlock, metadata: [String: Any]) throws {
        block.metadata = metadata
        block.updatedAt = Date()
        try context.save()
    }
    
    func deleteBlock(_ block: ContentBlock) throws {
        // 如果是媒体文件，需要删除实际文件
        if block.contentType != .text {
            // 删除关联的媒体文件
            try deleteAssociatedMediaFile(at: block.content)
        }
        
        context.delete(block)
        try context.save()
    }
    
    private func deleteAssociatedMediaFile(at path: String) throws {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            try fileManager.removeItem(atPath: path)
        }
    }
}
