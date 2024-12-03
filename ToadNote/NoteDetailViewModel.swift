import Foundation
import CoreData

class NoteDetailViewModel: ObservableObject {
    private let noteManager: NoteManager
    private let contentBlockManager: ContentBlockManager
    private let vectorManager: VectorStorageManager
    
    @Published var selectedNote: Note?
    @Published var contentBlocks: [ContentBlock] = []
    @Published var error: Error?
    
    init(context: NSManagedObjectContext) {
        self.noteManager = NoteManager(context: context)
        self.contentBlockManager = ContentBlockManager(context: context)
        self.vectorManager = VectorStorageManager(context: context)
    }
    
    // 加载笔记内容
    func loadNote(_ note: Note) {
        self.selectedNote = note
        self.contentBlocks = note.sortedContentBlocks
    }
    
    // 添加内容块
    func addContentBlock(type: ContentType, content: String) {
        guard let note = selectedNote else { return }
        
        do {
            let orderIndex = Int32(contentBlocks.count)
            let block = try contentBlockManager.createContentBlock(
                type: type,
                content: content,
                orderIndex: orderIndex,
                note: note
            )
            contentBlocks.append(block)
            
            // 更新向量存储
            updateNoteVector()
        } catch {
            self.error = error
        }
    }
    
    // 更新内容块
    func updateBlock(_ block: ContentBlock, newContent: String) {
        do {
            try contentBlockManager.updateContent(block, newContent: newContent)
            updateNoteVector()
        } catch {
            self.error = error
        }
    }
    
    // 删除内容块
    func deleteBlock(_ block: ContentBlock) {
        do {
            try contentBlockManager.deleteBlock(block)
            contentBlocks.removeAll { $0.id == block.id }
            updateNoteVector()
        } catch {
            self.error = error
        }
    }
    
    // 更新笔记向量
    private func updateNoteVector() {
        // 这里需要实现向量更新的具体逻辑
        // 比如调用外部 AI API 生成向量
    }
}
