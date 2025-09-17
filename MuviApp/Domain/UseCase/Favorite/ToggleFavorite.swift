//
//  ToggleFavorite.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//

protocol ToggleFavoriteUseCase {
    func execute(_ movie: Movie) throws
}

class ToggleFavorite: ToggleFavoriteUseCase {
    private let favoriteRepository: FavoriteMovieRepository
    
    init(favoriteRepository: FavoriteMovieRepository) {
        self.favoriteRepository = favoriteRepository
    }
    
    func execute(_ movie: Movie) throws {
        let favMovie = FavoriteMovie(
            id: movie.id, title: movie.title,
            backdropPath: movie.backdropPath,
            categories: movie.genres.map { $0.name }.joined(
                separator: ", "), releaseYear: movie.releaseYear)
        
        if try favoriteRepository.isFavorite(Int(favMovie.id)) {
            try favoriteRepository.removeFavoriteMovie(Int(favMovie.id))
        } else {
            try favoriteRepository.addFavoriteMovie(favMovie)
        }
    }
}
