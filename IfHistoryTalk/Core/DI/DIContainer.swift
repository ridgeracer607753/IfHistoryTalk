import Foundation

protocol DependencyKey {
    associatedtype Value
    static var currentValue: Value { get set }
}

class DIContainer {
    static let shared = DIContainer()
    private var dependencies: [String: Any] = [:]
    
    private init() {}
    
    func setup() {
        register(DefaultNetworkService() as NetworkService, for: NetworkService.self)
        register(DefaultHistoryRepository() as HistoryRepository, for: HistoryRepository.self)
        register(MockVersionCheckService() as VersionCheckService, for: VersionCheckService.self)
    }
    
    func register<T>(_ dependency: T, for type: T.Type) {
        let key = String(describing: type)
        dependencies[key] = dependency
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let dependency = dependencies[key] as? T else {
            fatalError("No dependency registered for \(key)")
        }
        return dependency
    }
}

@propertyWrapper
struct Injected<T> {
    private var dependency: T
    
    init() {
        self.dependency = DIContainer.shared.resolve(T.self)
    }
    
    var wrappedValue: T {
        get { dependency }
        mutating set { dependency = newValue }
    }
}
