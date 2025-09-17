//
//  FavoriteMovieRepository.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//

protocol FavoriteMovieRepository {
    func getAllFavoriteMovies() throws -> [FavoriteMovie]
    func addFavoriteMovie(_ movie: FavoriteMovie) throws
    func removeFavoriteMovie(_ id: Int) throws
    func isFavorite(_ id: Int) throws -> Bool
}
