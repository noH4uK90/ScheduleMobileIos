//
//  Resolver.swift
//  ScheduleMobileIos
//
//  Created by Иван Спирин on 11/19/23.
//

import Foundation
import Swinject

@propertyWrapper
struct Inject<Component> {
    let wrappedValue: Component
    init() {
        self.wrappedValue = Resolver.shared.resolve(Component.self)
    }
}

class Resolver {
    static let shared = Resolver()
    private let container = buildContainer()

    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}

func buildContainer() -> Container {
    let container = Container()

    container.register(GroupDefaultsProtocol.self) { _ in
        return GroupDefaultsService()
    }
    container.register(DataTransferProtocol.self) { _ in
        return DataTransferService()
    }
    container.register(GroupNetworkProtocol.self) { _ in
        return GroupNetworkService()
    }
    container.register(TimetableNetworkProtocol.self) { _ in
        return TimetableNetworkService()
    }

    return container
}
