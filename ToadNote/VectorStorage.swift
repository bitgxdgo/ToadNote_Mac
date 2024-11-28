import Foundation
import CoreData

@objc(VectorStorage)
public class VectorStorage: NSManagedObject {
    // MARK: - Core Data 属性
    @NSManaged public var id: UUID
    @NSManaged public var noteId: UUID
    @NSManaged public var vector: Data  // 存储向量数据
    @NSManaged public var dimension: Int32
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    
    // MARK: - 关系
    @NSManaged public var note: Note?
    
    // MARK: - Core Data Fetch Request
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VectorStorage> {
        return NSFetchRequest<VectorStorage>(entityName: "VectorStorage")
    }
    
    // MARK: - 便利方法
    func setVector(_ vectorArray: [Float]) throws {
        guard vectorArray.count == Int(dimension) else {
            throw VectorStorageError.dimensionMismatch
        }
        self.vector = Data(bytes: vectorArray, count: vectorArray.count * MemoryLayout<Float>.size)
    }
    
    func getVector() -> [Float] {
        return vector.withUnsafeBytes { pointer in
            Array(UnsafeBufferPointer(
                start: pointer.baseAddress?.assumingMemoryBound(to: Float.self),
                count: Int(dimension)
            ))
        }
    }
}

// MARK: - 错误类型
enum VectorStorageError: Error {
    case dimensionMismatch
    case invalidVectorData
}
