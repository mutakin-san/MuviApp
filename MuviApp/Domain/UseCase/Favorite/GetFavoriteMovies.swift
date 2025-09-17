//
//  GetFavoriteMovies.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//


protocol GetFavoriteMoviesUseCase {
    func execute() throws -> [FavoriteMovie]
}

class GetFavoriteMovies: GetFavoriteMoviesUseCase {
    private let favoriteRepository: FavoriteMovieRepository
    
    init(favoriteRepository: FavoriteMovieRepository) {
        self.favoriteRepository = favoriteRepository
    }
    
    func execute() throws -> [FavoriteMovie] {
        return try favoriteRepository.getAllFavoriteMovies()
    }
}

