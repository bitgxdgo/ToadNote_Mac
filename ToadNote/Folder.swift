import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    // MARK: - Core Data 属性
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var parentFolderId: UUID?
    
    // MARK: - 关系
    @NSManaged public var notes: Set<Note>
    @NSManaged public var parentFolder: Folder?
    @NSManaged public var subFolders: Set<Folder>
    
    // MARK: - Core Data Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }
}

// MARK: - 生成的访问器
extension Folder {
    @objc(addNotesObject:)
    @NSManaged public func addToNotes(_ value: Note)
    
    @objc(removeNotesObject:)
    @NSManaged public func removeFromNotes(_ value: Note)
    
    @objc(addNotes:)
    @NSManaged public func addToNotes(_ values: NSSet)
    
    @objc(removeNotes:)
    @NSManaged public func removeFromNotes(_ values: NSSet)
}

// MARK: - 子文件夹访问器
extension Folder {
    @objc(addSubFoldersObject:)
    @NSManaged public func addToSubFolders(_ value: Folder)
    
    @objc(removeSubFoldersObject:)
    @NSManaged public func removeFromSubFolders(_ value: Folder)
    
    @objc(addSubFolders:)
    @NSManaged public func addToSubFolders(_ values: NSSet)
    
    @objc(removeSubFolders:)
    @NSManaged public func removeFromSubFolders(_ values: NSSet)
}

// MARK: - Identifiable
extension Folder: Identifiable {
}
