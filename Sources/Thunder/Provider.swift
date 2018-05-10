//
//  Provider.swift
//  Thunder
//
//  Created by Austin Astorga on 5/9/18.
//

import Vapor

public struct ThunderConfig: Service {
    public let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }
}

public final class ThunderProvider: Provider {

    public init() { }

    public func register(_ services: inout Services) throws {
        services.register { container -> ThunderClient in
            let httpClient = try container.make(Client.self)
            let config = try container.make(ThunderConfig.self)
            return ThunderClient(client: httpClient, apiKey: config.apiKey)

        }
    }

    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }

}

public struct ThunderClient: Service {
    public var thunder: ThunderRoutes

    internal init(client: Client, apiKey: String) {
        let apiRequest = ThunderAPIRequest(httpClient: client, apiKey: apiKey)

        thunder = ThunderRoutes(request: apiRequest)
    }
}
