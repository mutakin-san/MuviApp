//
//  HomeViewModel.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import Foundation
import Combine
import RxSwift

class HomeViewModel: ObservableObject {
    @Published var nowPlayingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var upcomingMovies: [Movie] = []
    
    private let disposeBag = DisposeBag()

    private let getPopularMovieUseCase: GetPopularMovieUseCase
    private let getNowPlayingMovieUseCase: GetNowPlayingMovieUseCase
    private let getUpcomingMovieUseCase: GetUpcomingMovieUseCase
    
    init(getPopularMovieUseCase: GetPopularMovieUseCase, getNowPlayingMovieUseCase: GetNowPlayingMovieUseCase, getUpcomingMovieUseCase: GetUpcomingMovieUseCase) {
        self.getPopularMovieUseCase = getPopularMovieUseCase
        self.getUpcomingMovieUseCase = getUpcomingMovieUseCase
        self.getNowPlayingMovieUseCase = getNowPlayingMovieUseCase
    }
    
    
    func fetchNowPlayingMovies() {
        getNowPlayingMovieUseCase.execute()
            .observe(on: MainScheduler.instance) // ensure updates on UI thread
            .subscribe(
                onNext: { [weak self] movies in
                    self?.nowPlayingMovies = movies
                },
                onError: { error in
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchPopularMovies() {
        getPopularMovieUseCase.execute()
            .observe(on: MainScheduler.instance) // ensure updates on UI thread
            .subscribe(
                onNext: { [weak self] movies in
                    self?.popularMovies = movies
                },
                onError: { _ in
                }
            )
            .disposed(by: disposeBag)
    }
    
    func fetchUpcomingMovies() {
        getUpcomingMovieUseCase.execute()
            .observe(on: MainScheduler.instance) // ensure updates on UI thread
            .subscribe(
                onNext: { [weak self] movies in
                    self?.upcomingMovies = movies
                },
                onError: { _ in
                }
            )
            .disposed(by: disposeBag)
    }
}
