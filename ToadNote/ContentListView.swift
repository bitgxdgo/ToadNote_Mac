import SwiftUI

struct ContentListView: View {
    @Binding var searchText: String
    
    var body: some View {
        List {
            ForEach(1...10, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text("笔记标题 \(index)")
                        .font(.headline)
                    Text("最后编辑时间: 2024/3/20")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .searchable(text: $searchText, prompt: "搜索笔记")
    }
}
