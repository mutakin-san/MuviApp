//
//  Genre.swift
//  MuviApp
//
//  Created by Mutakin on 12/09/25.
//

import ObjectMapper

struct GenreResponse: Mappable {
    var genres: [GenreEntity]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        genres <- map["genres"]
    }
}

struct GenreEntity: Mappable {
    var id: Int?
    var name: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
