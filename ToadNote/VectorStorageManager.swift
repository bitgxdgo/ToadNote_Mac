import Foundation
import CoreData
import SQLite

class VectorStorageManager {
    private let context: NSManagedObjectContext
    private var db: Connection?
    private let dimension: Int32 = 384
    
    // 重新定义所有列，确保类型完全匹配
    private let vectorTable = Table("vector_index")
    // 使用 Setter 类型，这样在插入时不会有类型冲突
    private let vectorDataColumn = Expression<String>(value: "vector_data")
    private let noteIdColumn = Expression<String>(value: "note_id")
    private let updatedAtColumn = Expression<Double>(value: "updated_at")
    
    init(context: NSManagedObjectContext) {
        self.context = context
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let dbPath = documentsPath.appendingPathComponent("vectors.db").path
            
            db = try Connection(dbPath)
            
            // 创建表时使用相同的类型定义
            try db?.run(vectorTable.create(ifNotExists: true) { t in
                t.column(vectorDataColumn)  // 使用预定义的列
                t.column(noteIdColumn)
                t.column(updatedAtColumn)
            })
            
            // 创建索引
            try db?.run(vectorTable.createIndex(noteIdColumn, ifNotExists: true))
            
        } catch {
            print("Database setup error: \(error)")
        }
    }
    
    func saveVector(_ vector: [Float], for note: Note) throws {
        let storage = try fetchVectorStorage(for: note) ?? VectorStorage(context: context)
        storage.id = UUID()
        storage.noteId = note.id
        storage.dimension = dimension
        storage.createdAt = Date()
        storage.updatedAt = Date()
        storage.note = note
        try storage.setVector(vector)
        
        // 保存到 Core Data
        try context.save()
        
        // 准备数据
        let vectorStr = vector.map { String($0) }.joined(separator: ",")
        let timestamp = storage.updatedAt.timeIntervalSince1970
        
        // 修改插入语法
        if let db = db {
            try db.run(vectorTable.insert(or: .replace,
                vectorDataColumn <- vectorStr,
                noteIdColumn <- note.id.uuidString,
                updatedAtColumn <- Expression<Double>(value: String(timestamp))
                
            ))
        }
    }
    
    func findSimilarNotes(to vector: [Float], limit: Int = 10) throws -> [(Note, Float)] {
        var results: [(Note, Float)] = []
        let vectorStr = vector.map { String($0) }.joined(separator: ",")
        
        if let db = db {
            let query = vectorTable.limit(limit)
            for row in try db.prepare(query) {
                if let noteId = UUID(uuidString: row[noteIdColumn]),
                   let note = try fetchNote(by: noteId) {
                    let distance = calculateDistance(vectorStr, row[vectorDataColumn])
                    results.append((note, distance))
                }
            }
        }
        
        return results.sorted { $0.1 < $1.1 }
    }
    
    // 计算两个向量之间的欧几里得距离
    private func calculateDistance(_ vec1Str: String, _ vec2Str: String) -> Float {
        let vec1 = vec1Str.split(separator: ",").compactMap { Float($0) }
        let vec2 = vec2Str.split(separator: ",").compactMap { Float($0) }
        
        guard vec1.count == vec2.count else { return Float.infinity }
        
        var sum: Float = 0
        for i in 0..<vec1.count {
            let diff = vec1[i] - vec2[i]
            sum += diff * diff
        }
        
        return sqrt(sum)
    }
    
    // 辅助方法保持不变
    private func fetchVectorStorage(for note: Note) throws -> VectorStorage? {
        let request: NSFetchRequest<VectorStorage> = VectorStorage.fetchRequest()
        request.predicate = NSPredicate(format: "noteId == %@", note.id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    private func fetchNote(by id: UUID) throws -> Note? {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}
