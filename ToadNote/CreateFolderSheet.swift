import SwiftUI

struct CreateFolderSheet: View {
    @ObservedObject var viewModel: SidebarViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("新建文件夹")
                .font(.headline)
            
            TextField("名称：", text: $viewModel.newFolderName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 200)
            
            HStack {
                Button("取消") {
                    viewModel.newFolderName = ""
                    dismiss()
                }
                
                Button("好") {
                    viewModel.createRootFolder()
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.newFolderName.isEmpty)
            }
        }
        .padding()
        .frame(width: 300, height: 150)
    }
}
