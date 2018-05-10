//
//  ThunderRequest.swift
//  Thunder
//
//  Created by Austin Astorga on 5/9/18.
//

import Vapor

public class ThunderAPIRequest {

    private let httpClient: Client
    private let apiKey: String
    private let darkSkyURL = "https://api.darksky.net/forecast/"

    public init(httpClient: Client, apiKey: String) {
        self.httpClient = httpClient
        self.apiKey = apiKey
    }

    public func getWeather(latitude lat: Double, longitude lon: Double, time: Date?, excludeFields: [Forecast.Field] = [], extendHourly: Bool = false, units: Units?, language: Language?) throws -> Future<Forecast> {

        let url = buildForecastURL(latitude: lat, longitude: lon, time: time, extendHourly: extendHourly, excludeFields: excludeFields, units: units, language: language)

        let forecast: Future<Forecast> =  self.httpClient.get(url).flatMap { res in
                return res.http.body.consumeData(on: self.httpClient.container)
            }.map(to: Forecast.self) { data in
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .secondsSince1970
                return try jsonDecoder.decode(Forecast.self, from: data)
        }
        return forecast
    }

    private func buildForecastURL(latitude lat: Double, longitude lon: Double, time: Date?, extendHourly: Bool, excludeFields: [Forecast.Field], units: Units?, language: Language?) -> URL {
        //  Build URL path
        var urlString = darkSkyURL + apiKey + "/\(lat),\(lon)"
        if let time = time {
            let timeString = String(format: "%.0f", time.timeIntervalSince1970)
            urlString.append(",\(timeString)")
        }

        //  Build URL query parameters
        var urlBuilder = URLComponents(string: urlString)!
        var queryItems: [URLQueryItem] = []
        if let units = units {
            queryItems.append(URLQueryItem(name: "units", value: units.rawValue))
        }
        if let language = language {
            queryItems.append(URLQueryItem(name: "lang", value: language.rawValue))
        }
        if extendHourly {
            queryItems.append(URLQueryItem(name: "extend", value: "hourly"))
        }
        if !excludeFields.isEmpty {
            var excludeFieldsString = ""
            for field in excludeFields {
                if excludeFieldsString != "" {
                    excludeFieldsString.append(",")
                }
                excludeFieldsString.append("\(field.rawValue)")
            }
            queryItems.append(URLQueryItem(name: "exclude", value: excludeFieldsString))
        }
        urlBuilder.queryItems = queryItems

        return urlBuilder.url!
    }
}
