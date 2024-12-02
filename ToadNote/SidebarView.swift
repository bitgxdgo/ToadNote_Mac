import SwiftUI

struct SidebarView: View {
    @Binding var selectedItem: String?
    
    var body: some View {
        List(selection: $selectedItem) {
            Section("收藏夹") {
                NavigationLink(value: "笔记") {
                    Label("所有笔记", systemImage: "note.text")
                }
                NavigationLink(value: "待办") {
                    Label("待办事项", systemImage: "checklist")
                }
                NavigationLink(value: "收藏") {
                    Label("收藏内容", systemImage: "star")
                }
            }
            
            Section("笔记本") {
                NavigationLink(value: "工作") {
                    Label("工作", systemImage: "briefcase")
                }
                NavigationLink(value: "个人") {
                    Label("个人", systemImage: "person")
                }
            }
        }
    }
}
