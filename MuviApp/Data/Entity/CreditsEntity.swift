//
//  CreditsEntity.swift
//  MuviApp
//
//  Created by Mutakin on 12/09/25.
//

import ObjectMapper

struct CreditsEntity: Mappable {
    var cast: [ActorEntity]?
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        cast <- map["cast"]
    }
}
