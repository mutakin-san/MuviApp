//
//  GetPopularMovie.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift

protocol GetNowPlayingMovieUseCase {
    func execute() -> Observable<[Movie]>
}

class GetNowPlayingMovie: GetNowPlayingMovieUseCase {
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute() -> Observable<[Movie]> {
        return repository.getNowPlayingMovies()
    }
}
