import SwiftUI

struct ContentListView: View {
    @Binding var searchText: String
    @StateObject private var viewModel: ContentListViewModel
    @EnvironmentObject var sidebarViewModel: SidebarViewModel
    
    init(searchText: Binding<String>, context: NSManagedObjectContext) {
        print("ContentListView 初始化")
        self._searchText = searchText
        self._viewModel = StateObject(wrappedValue: ContentListViewModel(context: context))
    }
    
    var body: some View {
        List {
            if let selectedFolder = sidebarViewModel.selectedFolder {
                let _ = print("当前选中文件夹: \(selectedFolder.name)")
                if viewModel.notes.isEmpty {
                    let _ = print("当前文件夹无笔记")
                    Text("无笔记")
                        .foregroundColor(.gray)
                } else {
                    let _ = print("笔记数量: \(viewModel.notes.count)")
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
            } else {
                let _ = print("没有选中的文件夹")
            }
        }
        .searchable(text: $searchText, prompt: "搜索笔记")
        .onChange(of: sidebarViewModel.selectedFolder) { folder in
            print("文件夹选择发生变化")
            if let folder = folder {
                print("切换到文件夹: \(folder.name)")
            }
            viewModel.loadNotes(in: folder)
        }
    }
}
