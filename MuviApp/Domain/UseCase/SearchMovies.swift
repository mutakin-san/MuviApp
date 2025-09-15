//
//  GetPopularMovie.swift
//  MuviApp
//
//  Created by Mutakin on 13/09/25.
//

import RxSwift

protocol SearchMoviesUseCase {
    func execute(query: String) -> Observable<[Movie]>
}

class SearchMovies: SearchMoviesUseCase {
    private let repository: MovieRepository
    
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(query: String) -> Observable<[Movie]> {
        return repository.searchMovies(query: query)
    }
}
