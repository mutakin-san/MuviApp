//
//  FavoriteMovieViewModel.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//

import Combine
import Foundation

class FavoriteMovieViewModel: ObservableObject {
    @Published var favoriteMovies: [FavoriteMovie] = []
    @Published var filteredMovies: [FavoriteMovie] = []
    @Published var query: String = ""

    private let getFavoriteMovies: GetFavoriteMoviesUseCase
    private let toggleFavoriteMovie: ToggleFavoriteUseCase
    private let checkIsFavoriteMovie: CheckIsFavoriteUseCase

    private var cancellables = Set<AnyCancellable>()

    init(
        getFavoriteMovies: GetFavoriteMoviesUseCase,
        toggleFavoriteMovie: ToggleFavoriteUseCase,
        checkIsFavoriteMovie: CheckIsFavoriteUseCase
    ) {
        self.getFavoriteMovies = getFavoriteMovies
        self.toggleFavoriteMovie = toggleFavoriteMovie
        self.checkIsFavoriteMovie = checkIsFavoriteMovie
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newQuery in
                self?.search(query: newQuery)
            }
            .store(in: &cancellables)
    }

    private func search(query: String) {
        if query.isEmpty {
            filteredMovies = favoriteMovies
        } else {
            filteredMovies = favoriteMovies.filter { movie in
                movie.title
                    .lowercased()
                    .contains(query.lowercased())
            }
        }
    }

    func fetchFavoriteMovies() {
        do {
            let results = try getFavoriteMovies.execute()
            favoriteMovies = results
            filteredMovies = results
        } catch {
        }
    }

    func toggleFavorite(for movie: Movie) {
        do {
            try toggleFavoriteMovie.execute(movie)
        } catch {
        }
    }
    
    func isMovieFavorited(_ movie: Movie) -> Bool {
        do {
            return try checkIsFavoriteMovie.execute(movie.id)
        } catch {
            return false
        }
    }

}
