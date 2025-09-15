//
//  MovieRepository.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift

protocol MovieRepository {
    func getPopularMovies() -> Observable<[Movie]>
    func getUpcomingMovies() -> Observable<[Movie]>
    func getNowPlayingMovies() -> Observable<[Movie]>
    func searchMovies(query: String) -> Observable<[Movie]>
    func getMovieDetails(id: Int) -> Observable<Movie>
}
