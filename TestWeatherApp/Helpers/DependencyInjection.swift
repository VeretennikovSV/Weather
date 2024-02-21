import Foundation

var Resolver = DependencyInjection.resolver

final class DependencyInjection {
    static var resolver = DependencyInjection()
    private var container: [String: Any] = [:]
    private var protocolImplementations: [String: String] = [:]

    private init() {}

    func register<T>(_ type: T.Type, implements: () -> T, withProtocols: (() -> [Any.Type])? = nil) {
        container[String(describing: type)] = implements()
        withProtocols?().forEach { prot in
            protocolImplementations[String(describing: prot.self)] = String(describing: type)
        }
    }

    func resolve<T>(_ type: T.Type) -> T? {
        if let protocolImplementation = protocolImplementations[String(describing: type)] {
            return container[protocolImplementation] as? T
        }
        return container[String(describing: type)] as? T
    }
}
