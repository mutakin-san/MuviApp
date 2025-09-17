//
//  MovieLocalDataSource.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//

import CoreData

protocol MovieLocalDataSource {
    func getFavoriteMovies() throws -> [FavoriteMovieEntity]
    func saveFavoriteMovie(_ movie: FavoriteMovie) throws
    func removeFavoriteMovie(_ id: Int) throws
    func isFavorite(_ id: Int) throws -> Bool
}

class DefaultMovieLocalDataSource: MovieLocalDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func getFavoriteMovies() throws -> [FavoriteMovieEntity] {
        let request: NSFetchRequest<FavoriteMovieEntity> =
        FavoriteMovieEntity.fetchRequest()
        return try context.fetch(request)
    }

    func saveFavoriteMovie(_ movie: FavoriteMovie) throws {
        let request: NSFetchRequest<FavoriteMovieEntity> =
        FavoriteMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", movie.id)

        let existing = try context.fetch(request)
        if existing.isEmpty {
            let favMovieEntity = FavoriteMovieEntity(context: context)
            favMovieEntity.id = Int64(movie.id)
            favMovieEntity.title = movie.title
            favMovieEntity.releaseYear = movie.releaseYear
            favMovieEntity.backdropPath = movie.backdropPath
            favMovieEntity.categories = movie.categories
            try context.save()
        }
    }

    func removeFavoriteMovie(_ id: Int) throws {
        let request: NSFetchRequest<FavoriteMovieEntity> =
        FavoriteMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        let results = try context.fetch(request)
        for obj in results {
            context.delete(obj)
        }
        try context.save()
    }

    func isFavorite(_ id: Int) throws -> Bool {
        let request: NSFetchRequest<FavoriteMovieEntity> =
        FavoriteMovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        let count = try context.count(for: request)
        return count > 0
    }

}
