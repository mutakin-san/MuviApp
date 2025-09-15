//
//  DetailViewModel.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//

import Foundation
import RxSwift

class DetailViewModel: ObservableObject {
    @Published var movie: Movie?
    @Published var isLoading: Bool = true
    @Published var error: Error?
    
    private let getMovieDetailsUseCase: GetMovieDetailsUseCase
    private let disposeBag = DisposeBag()
    
    init(getMovieDetailsUseCase: GetMovieDetailsUseCase) {
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
    }
    
    
    func fetchMovie(id: Int) {
        getMovieDetailsUseCase.execute(movieId: id)
            .observe(on: MainScheduler.instance) // ensure updates on UI thread
            .subscribe(
                onNext: { [weak self] movie in
                    self?.movie = movie
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.isLoading = false
                }
            )
            .disposed(by: disposeBag)
        
    }
}
