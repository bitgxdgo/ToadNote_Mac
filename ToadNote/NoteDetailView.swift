import SwiftUI

struct NoteDetailView: View {
    @State private var noteText: String = "在这里输入笔记内容..."
    
    var body: some View {
        TextEditor(text: $noteText)
            .font(.body)
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {}) {
                        Image(systemName: "textformat")
                    }
                    Button(action: {}) {
                        Image(systemName: "photo")
                    }
                    Button(action: {}) {
                        Image(systemName: "link")
                    }
                }
            }
    }
}
