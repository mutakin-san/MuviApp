//
//  APIConfig.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import Foundation

struct APIConfig {
    static let baseURLString = "https://api.themoviedb.org/3"
    static let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
    static let imageBaseURLString = "https://image.tmdb.org/t/p"
    static let posterSize = "w500"
    static let backdropSize = "w1280"
    static let backdropSizeLarge = "w1920"
    static let posterSizeLarge = "w1280"
    
    static func imageURL(path: String?, size: String = posterSize) -> URL? {
        guard let path = path else { return nil }
        return URL(string: "\(imageBaseURLString)/\(size)\(path)")
    }
}
