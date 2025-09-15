//
//  GetPopularMovie.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift

protocol GetMovieDetailsUseCase {
    func execute(movieId: Int) -> Observable<Movie>
}

class GetMovieDetails: GetMovieDetailsUseCase {
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(movieId: Int) -> Observable<Movie> {
        return repository.getMovieDetails(id: movieId)
    }
}
