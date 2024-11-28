import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    // MARK: - Core Data 属性
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var tags: Set<String>
    @NSManaged public var vectorId: UUID?
    
    // MARK: - 关系
    @NSManaged public var folder: Folder?
    @NSManaged private var primitiveContentBlocks: NSSet
    
    // 提供类型安全的访问器
    var contentBlocks: Set<ContentBlock> {
        get {
            let blocks = primitiveContentBlocks as? Set<ContentBlock> ?? []
            return blocks
        }
        set {
            primitiveContentBlocks = NSSet(set: newValue)
        }
    }
    
    // MARK: - Core Data Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }
    
    // MARK: - 便利属性
    var sortedContentBlocks: [ContentBlock] {
        return contentBlocks.sorted { $0.orderIndex < $1.orderIndex }
    }
}

// MARK: - 内容块访问器
extension Note {
    @objc(addContentBlocksObject:)
    @NSManaged public func addToContentBlocks(_ value: ContentBlock)
    
    @objc(removeContentBlocksObject:)
    @NSManaged public func removeFromContentBlocks(_ value: ContentBlock)
    
    @objc(addContentBlocks:)
    @NSManaged public func addToContentBlocks(_ values: NSSet)
    
    @objc(removeContentBlocks:)
    @NSManaged public func removeFromContentBlocks(_ values: NSSet)
}

// MARK: - Identifiable
extension Note: Identifiable {
}
