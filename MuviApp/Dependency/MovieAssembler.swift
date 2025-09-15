//
//  AppAssembler.swift
//  MuviApp
//
//  Created by Mutakin on 15/09/25.
//

protocol MovieAssembler {
    func resolve() -> MovieRemoteDataSource
    func resolve() -> MovieRepository
    func resolve() -> GetPopularMovieUseCase
    func resolve() -> GetNowPlayingMovieUseCase
    func resolve() -> GetUpcomingMovieUseCase
    func resolve() -> GetMovieDetailsUseCase
    func resolve() -> SearchMoviesUseCase
    func resolve() -> HomeViewModel
    func resolve() -> DetailViewModel
    func resolve() -> SearchViewModel
}


extension MovieAssembler where Self: Assembler {
    func resolve() -> MovieRemoteDataSource {
        return DefaultMovieRemoteDataSource()
    }
    
    func resolve() -> MovieRepository {
        return DefaultMovieRepository(remoteDataSource: resolve())
    }
    
    func resolve() -> GetPopularMovieUseCase {
        return GetPopularMovie(repository: resolve())
    }
    
    func resolve() -> GetNowPlayingMovieUseCase {
        return GetNowPlayingMovie(repository: resolve())
    }
    
    func resolve() -> any GetUpcomingMovieUseCase {
        return GetUpcomingMovie(repository: resolve())
    }
    
    func resolve() -> any GetMovieDetailsUseCase {
        return GetMovieDetails(repository: resolve())
    }
    
    func resolve() -> SearchMoviesUseCase {
        return SearchMovies(repository: resolve())
    }
    
    func resolve() -> HomeViewModel {
        return HomeViewModel(
            getPopularMovieUseCase: resolve(),
            getNowPlayingMovieUseCase: resolve(),
            getUpcomingMovieUseCase: resolve()
        )
    }
    
    func resolve() -> DetailViewModel {
        return DetailViewModel(getMovieDetailsUseCase: resolve())
    }
    
    func resolve() -> SearchViewModel {
        return SearchViewModel(searchMoviesUseCase: resolve())
    }
}
