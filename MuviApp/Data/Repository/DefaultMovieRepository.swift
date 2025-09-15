//
//  MovieRepository.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift

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
        return Movie(
            overview: self.overview ?? "",  // default empty string
            posterPath: self.posterPath ?? "",  // default empty string
            backdropPath: self.backdropPath ?? "",
            originalTitle: self.originalTitle ?? "",
            id: self.id ?? 0,  // default 0
            title: self.title ?? "Unknown",  // fallback name
            video: self.video ?? false,  // default false
            duration: self.duration ?? 0,  // default 0 minutes
            resolution: self.resolution ?? "HD",  // default "HD"
            credits: credits ?? self.credits?.toDomain(),  // safe map
            genres: genres  // mapping dari luar
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
