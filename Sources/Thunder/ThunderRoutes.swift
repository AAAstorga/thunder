//
//  ThunderRoutes.swift
//  Thunder
//
//  Created by Austin Astorga on 5/9/18.
//

import Vapor

public struct ThunderRoutes {
    private let request: ThunderAPIRequest

    init(request: ThunderAPIRequest) {
        self.request = request
    }

    public func getWeather(latitude lat: Double, longitude lon: Double, time: Date?, excludeFields: [Forecast.Field] = [], extendHourly: Bool = false, units: Units?, language: Language?) throws -> Future<Forecast> {
        return try self.request.getWeather(latitude: lat, longitude: lon, time: time, excludeFields: excludeFields, extendHourly: extendHourly, units: units, language: language)
    }
}
