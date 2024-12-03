import SwiftUI

struct ContentListView: View {
    @Binding var searchText: String
    @StateObject private var viewModel: ContentListViewModel
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    
    init(searchText: Binding<String>, context: NSManagedObjectContext) {
        self._searchText = searchText
        self._viewModel = StateObject(wrappedValue: ContentListViewModel(context: context))
    }
    
    var body: some View {
        List {
            if let selectedFolder = sidebarViewModel.selectedFolder {
                if viewModel.notes.isEmpty {
                    Text("无笔记")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.notes) { note in
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .font(.headline)
                            Text("最后编辑时间: \(note.updatedAt.formatted())")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "搜索笔记")
        .onChange(of: sidebarViewModel.selectedFolder) { folder in
            // 当选中文件夹变化时，加载对应的笔记
            viewModel.loadNotes(in: folder)
        }
    }
}
