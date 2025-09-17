//
//  Movie.swift
//  Data
//
//  Created by Asep Mulyana on 17/11/20.
//  Copyright © 2020 Asep Mulyana. All rights reserved.
//

import ObjectMapper

struct MovieResponse: Mappable {
    var totalPages: Int?
    var page: Int?
    var results: [MovieEntity]?
    var totalResults: Int?

    init?(map: Map) {
        mapping(map: map)
    }

    mutating func mapping(map: Map) {
        totalPages <- map["total_pages"]
        page <- map["page"]
        results <- map["results"]
        totalResults <- map["total_results"]
    }
}

struct MovieEntity: Mappable {
    var video: Bool?
    var duration: Int?
    var resolution: String?
    var credits: CreditsEntity?
    var genres: [GenreEntity]?
    var backdropPath: String?
    var originalTitle: String?
    var id: Int?
    var posterPath: String?
    var title: String?
    var releaseDate: String?
    var overview: String?
    var genreIds: [Int]?

    init?(map: Map) {
        mapping(map: map)
    }

    mutating func mapping(map: Map) {
        backdropPath <- map["backdrop_path"]
        genreIds <- map["genre_ids"]
        genres <- map["genres"]
        originalTitle <- map["original_title"]
        id <- map["id"]
        posterPath <- map["poster_path"]
        title <- map["title"]
        releaseDate <- map["release_date"]
        video <- map["video"]
        duration <- map["runtime"]
        overview <- map["overview"]
        credits <- map["credits"]
    }
}
