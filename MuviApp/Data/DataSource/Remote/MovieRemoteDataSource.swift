//
//  MovieRemoteDataSource.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift

protocol MovieRemoteDataSource {
    func getPopularMovies() -> Observable<[MovieEntity]>
    func getUpcomingMovies() -> Observable<[MovieEntity]>
    func getNowPlayingMovies() -> Observable<[MovieEntity]>
    func searchMovies(query: String) -> Observable<[MovieEntity]>
    func getMovieDetails(id: Int) -> Observable<MovieEntity>
    func getGenreList() -> Observable<[GenreEntity]>
    func getCreditList(id: Int) -> Observable<CreditsEntity>
}

struct DefaultMovieRemoteDataSource: MovieRemoteDataSource {
    func getCreditList(id: Int) -> Observable<CreditsEntity> {
        return NetworkService.shared.connect(api: .credits(id), mappableType: CreditsEntity.self)
    }
    
    func getGenreList() -> Observable<[GenreEntity]> {
        return NetworkService.shared.connect(api: .genres, mappableType: GenreResponse.self)
            .map { $0.genres ?? [] }
    }
    
    func getMovieDetails(id: Int) -> Observable<MovieEntity> {
        return NetworkService.shared.connect(
            api: .detail(id), mappableType: MovieEntity.self
        )
        .compactMap {
            var newMovieEntity = $0
            if let backdrop = newMovieEntity.backdropPath {
                newMovieEntity.posterPath = "\(APIConfig.imageBaseURLString)/\(APIConfig.backdropSize)\(backdrop)"
            }
            return newMovieEntity
        }
    }
    
    func getUpcomingMovies() -> Observable<[MovieEntity]> {
        return NetworkService.shared.connect(
            api: .upcoming, mappableType: MovieResponse.self
        )
        .compactMap {
            $0.results?.map({ (movieEntity) -> MovieEntity in
                var newMovieEntity = movieEntity
                if let poster = newMovieEntity.posterPath {
                    newMovieEntity.posterPath = "\(APIConfig.imageBaseURLString)/\(APIConfig.posterSize)\(poster)"
                }
                return newMovieEntity
            })
        }
    }

    func getNowPlayingMovies() -> Observable<[MovieEntity]> {
        return NetworkService.shared.connect(
            api: .nowPlaying, mappableType: MovieResponse.self
        )
        .compactMap {
            $0.results?.map({ (movieEntity) -> MovieEntity in
                var newMovieEntity = movieEntity
                if let poster = newMovieEntity.posterPath {
                    newMovieEntity.posterPath = "\(APIConfig.imageBaseURLString)/\(APIConfig.posterSize)\(poster)"
                }
                return newMovieEntity
            })
        }
    }

    func searchMovies(query: String) -> Observable<[MovieEntity]> {
        return NetworkService.shared.connect(
            api: .search(query), mappableType: MovieResponse.self
        )
        .compactMap {
            $0.results?.map({ (movieEntity) -> MovieEntity in
                var newMovieEntity = movieEntity
                if let poster = newMovieEntity.posterPath {
                    newMovieEntity.posterPath = "\(APIConfig.imageBaseURLString)/\(APIConfig.posterSize)\(poster)"
                }
                return newMovieEntity
            })
        }
    }

    func getPopularMovies() -> Observable<[MovieEntity]> {
        return NetworkService.shared.connect(
            api: .popular, mappableType: MovieResponse.self
        )
        .compactMap {
            $0.results?.map({ (movieEntity) -> MovieEntity in
                var newMovieEntity = movieEntity
                if let poster = newMovieEntity.posterPath {
                    newMovieEntity.posterPath = "\(APIConfig.imageBaseURLString)/\(APIConfig.posterSize)\(poster)"
                }
                return newMovieEntity
            })
        }
    }
}
