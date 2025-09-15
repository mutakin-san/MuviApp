//
//  GetPopularMovie.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift

protocol GetUpcomingMovieUseCase {
    func execute() -> Observable<[Movie]>
}

class GetUpcomingMovie: GetUpcomingMovieUseCase {
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute() -> Observable<[Movie]> {
        return repository.getUpcomingMovies()
    }
}
