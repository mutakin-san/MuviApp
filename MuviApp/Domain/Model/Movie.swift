//
//  Movie.swift
//  MuviApp
//
//  Created by Mutakin on 12/09/25.
//

import Foundation

struct Movie {
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let originalTitle: String
    let id: Int
    let title: String
    let releaseDate: Date
    let video: Bool?
    let duration: Int
    let resolution: String?
    let credits: Credits?
    let genres: [Genre]
}

extension Movie {
    var releaseYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: releaseDate)
    }
}
