//
//  MovieRepository.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift
import Foundation

struct DefaultMovieRepository: MovieRepository {

    private let remoteDataSource: MovieRemoteDataSource

    init(remoteDataSource: MovieRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getPopularMovies() -> Observable<[Movie]> {
        remoteDataSource.getPopularMovies()
            .map { results in
                results.map { $0.toDomain() }
            }
    }

    func getUpcomingMovies() -> Observable<[Movie]> {
        remoteDataSource.getUpcomingMovies()
            .map { results in
                results.map { $0.toDomain() }
            }
    }

    func getNowPlayingMovies() -> Observable<[Movie]> {
        remoteDataSource.getNowPlayingMovies()
            .map { results in
                results.map { $0.toDomain() }
            }
    }
    
    func searchMovies(query: String) -> Observable<[Movie]> {
        let moviesObservable = remoteDataSource.searchMovies(query: query)
        let genresObservable = remoteDataSource.getGenreList()

        return Observable.zip(moviesObservable, genresObservable)
            .flatMap { movies, genres -> Observable<[Movie]> in
                let genreDict = Dictionary(uniqueKeysWithValues: genres.map { ($0.id, $0) })

                // For each movie, fetch credits and map into domain Movie
                let enrichedMoviesObservables: [Observable<Movie>] = movies.compactMap { movie in
                   
                    return remoteDataSource.getCreditList(id: movie.id!)
                        .map { credits in
                            let mappedGenres = movie.genreIds?.compactMap { genreDict[$0]?.toDomain() } ?? []
                            
                            return movie.toDomain(
                                genres: mappedGenres,
                                credits: credits.toDomain()
                            )
                        }
                }

                // Zip all movies into one array
                return Observable.zip(enrichedMoviesObservables)
            }
    }


    func getMovieDetails(id: Int) -> Observable<Movie> {
        remoteDataSource.getMovieDetails(id: id).map { $0.toDomain() }
    }
}

extension MovieEntity {
    func toDomain(genres: [Genre] = [], credits: Credits? = nil) -> Movie {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        var releaseDate: Date = Date()

        if let date = formatter.date(from: self.releaseDate ?? "") {
            releaseDate = date
        } else {
            print("Invalid date string")
        }
        
        return Movie(
            overview: self.overview ?? "",
            posterPath: self.posterPath ?? "",
            backdropPath: self.backdropPath ?? "",
            originalTitle: self.originalTitle ?? "",
            id: self.id ?? 0,
            title: self.title ?? "Unknown",
            releaseDate: releaseDate,
            video: self.video ?? false,
            duration: self.duration ?? 0,
            resolution: self.resolution ?? "HD",
            credits: credits ?? self.credits?.toDomain(),
            genres: genres.isEmpty ? self.genres?.map { $0.toDomain() } ?? [] : genres
        )
    }
}

extension GenreEntity {
    func toDomain() -> Genre {
        return Genre(
            id: self.id ?? 0,
            name: self.name ?? "Unknown"
        )
    }
}

extension CreditsEntity {
    func toDomain() -> Credits {
        return Credits(
            cast: self.cast?.map { $0.toDomain() } ?? []
        )
    }
}

extension ActorEntity {
    func toDomain() -> Actor {
        return Actor(
            id: self.id ?? 0,
            name: self.name ?? "Unknown",
            profilePath: self.profilePath ?? ""
        )
    }
}
