import Foundation
import CoreData
import Combine

class ContentListViewModel: ObservableObject {
    private let noteManager: NoteManager
    private let vectorManager: VectorStorageManager
    
    @Published var notes: [Note] = []
    @Published var error: Error?
    @Published var searchText: String = "" {
        didSet {
            searchNotes()
        }
    }
    
    private var selectedFolder: Folder?
    private var cancellables = Set<AnyCancellable>()
    
    init(context: NSManagedObjectContext) {
        self.noteManager = NoteManager(context: context)
        self.vectorManager = VectorStorageManager(context: context)
        setupSearchSubscription()
    }
    
    // 设置搜索订阅
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.searchNotes()
            }
            .store(in: &cancellables)
    }
    
    // 加载笔记
    func loadNotes(in folder: Folder?) {
        self.selectedFolder = folder
        do {
            notes = try noteManager.fetchNotes(in: folder)
        } catch {
            self.error = error
        }
    }
    
    // 搜索笔记
    private func searchNotes() {
        do {
            if searchText.isEmpty {
                notes = try noteManager.fetchNotes(in: selectedFolder)
            } else {
                notes = try noteManager.searchNotes(query: searchText)
            }
        } catch {
            self.error = error
        }
    }
    
    // 创建新笔记
    func createNote(title: String) {
        do {
            let newNote = try noteManager.createNote(title: title, folder: selectedFolder)
            loadNotes(in: selectedFolder)
        } catch {
            self.error = error
        }
    }
    
    // 删除笔记
    func deleteNote(_ note: Note) {
        do {
            try noteManager.deleteNote(note)
            loadNotes(in: selectedFolder)
        } catch {
            self.error = error
        }
    }
}
