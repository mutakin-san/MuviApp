//
//  FavoriteMovieAssembler.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//

protocol FavoriteMovieAssembler {
    func resolve() -> MovieLocalDataSource
    func resolve() -> FavoriteMovieRepository
    func resolve() -> FavoriteMovieViewModel
    func resolve() -> GetFavoriteMoviesUseCase
    func resolve() -> ToggleFavoriteUseCase
    func resolve() -> CheckIsFavoriteUseCase
}


extension FavoriteMovieAssembler where Self: Assembler {
    func resolve() -> MovieLocalDataSource {
        return DefaultMovieLocalDataSource()
    }
    
    func resolve() -> FavoriteMovieRepository {
        return FavoriteMovieRepositoryImpl(movieLocalDataSource: resolve())
    }
    
    func resolve() -> FavoriteMovieViewModel {
        return FavoriteMovieViewModel(getFavoriteMovies: resolve(), toggleFavoriteMovie: resolve(), checkIsFavoriteMovie: resolve())
    }
    
    func resolve() -> GetFavoriteMoviesUseCase {
        return GetFavoriteMovies(favoriteRepository: resolve())
    }
    
    func resolve() -> ToggleFavoriteUseCase {
        return ToggleFavorite(favoriteRepository: resolve())
    }
    
    func resolve() -> CheckIsFavoriteUseCase {
        return CheckIsFavorite(favoriteRepository: resolve())
    }
    
}
