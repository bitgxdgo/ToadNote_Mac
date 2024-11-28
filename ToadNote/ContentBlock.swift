import Foundation
import CoreData

enum ContentType: String {
    case text
    case image
    case video
    case audio
}

@objc(ContentBlock)
public class ContentBlock: NSManagedObject {
    // MARK: - Core Data 属性
    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var content: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var orderIndex: Int32
    @NSManaged public var metadata: [String: Any]?
    @NSManaged public var note: Note?
    
    // MARK: - 便利属性
    var contentType: ContentType {
        get {
            ContentType(rawValue: type) ?? .text
        }
        set {
            type = newValue.rawValue
        }
    }
    
    // MARK: - Core Data Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContentBlock> {
        return NSFetchRequest<ContentBlock>(entityName: "ContentBlock")
    }
}

// MARK: - Identifiable
extension ContentBlock: Identifiable {
}
