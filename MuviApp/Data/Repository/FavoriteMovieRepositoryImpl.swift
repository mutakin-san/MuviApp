//
//  LocalMovieRepository.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//

class FavoriteMovieRepositoryImpl: FavoriteMovieRepository {

    init(movieLocalDataSource: MovieLocalDataSource) {
        self.movieLocalDataSource = movieLocalDataSource
    }

    private let movieLocalDataSource: MovieLocalDataSource

    func getAllFavoriteMovies() throws -> [FavoriteMovie] {
        return try movieLocalDataSource.getFavoriteMovies()
            .map { $0.toDomain() }

    }

    func addFavoriteMovie(_ movie: FavoriteMovie) throws {

        return try movieLocalDataSource.saveFavoriteMovie(movie)
    }

    func removeFavoriteMovie(_ id: Int) throws {
        return try movieLocalDataSource.removeFavoriteMovie(id)
    }

    func isFavorite(_ id: Int) throws -> Bool {
        return try movieLocalDataSource.isFavorite(id)
    }
}

extension FavoriteMovieEntity {
    func toDomain() -> FavoriteMovie {
        return FavoriteMovie(
            id: Int(self.id), title: self.title ?? "",
            backdropPath: self.backdropPath ?? "",
            categories: self.categories ?? "",
            releaseYear: self.releaseYear ?? ""
        )
    }
}
