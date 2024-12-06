import SwiftUI
import CoreData

final class ViewModelContainer {
    static let shared = ViewModelContainer()
    
    let sidebarViewModel: SidebarViewModel
    
    private init() {
        print("【Container】初始化 ViewModelContainer")
        let context = PersistenceController.shared.container.viewContext
        self.sidebarViewModel = SidebarViewModel(context: context)
    }
}
