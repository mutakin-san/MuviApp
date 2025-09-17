//
//  CheckIsFavorite.swift
//  MuviApp
//
//  Created by Mutakin on 18/09/25.
//

protocol CheckIsFavoriteUseCase {
    func execute(_ id: Int) throws -> Bool
}

class CheckIsFavorite: CheckIsFavoriteUseCase {
    private let favoriteRepository: FavoriteMovieRepository
    
    init(favoriteRepository: FavoriteMovieRepository) {
        self.favoriteRepository = favoriteRepository
    }
    
    func execute(_ id: Int) throws -> Bool {
        return try favoriteRepository.isFavorite(id)
    }
}
