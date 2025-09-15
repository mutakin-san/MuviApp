//
//  ActorEntity.swift
//  MuviApp
//
//  Created by Mutakin on 12/09/25.
//

import ObjectMapper

struct ActorEntity: Mappable {
    var id: Int?
    var name: String?
    var profilePath: String?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        profilePath <- map["profile_path"]
    }  
}
