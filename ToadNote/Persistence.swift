import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToadNote")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("持久化存储描述信息：")
                print("- 类型: \(description.type)")
                print("- URL: \(description.url?.absoluteString ?? "未设置")")
                print("- 配置名称: \(description.configuration ?? "默认配置")")
                print("- 是否只读: \(description.isReadOnly)")
                print("- 选项: \(description.options)")
                
                print("\n错误详情：")
                print("- 错误描述: \(error.localizedDescription)")
                
                let nsError = error as NSError
                print("- 错误代码: \(nsError.code)")
                print("- 错误域: \(nsError.domain)")
                print("- 详细信息: \(nsError.userInfo)")
                
                try? FileManager.default.removeItem(at: description.url!)
                
                do {
                    try container.persistentStoreCoordinator.addPersistentStore(
                        ofType: description.type,
                        configurationName: description.configuration,
                        at: description.url,
                        options: description.options
                    )
                } catch {
                    print("重新创建存储失败：\(error.localizedDescription)")
                    fatalError("无法恢复 CoreData 存储: \(error.localizedDescription)")
                }
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    private init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    private let inMemory: Bool
}
