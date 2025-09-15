//
//  SearchViewModel.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import Foundation
import Combine
import RxSwift
import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var results: [Movie] = []
    @Published var isLoading: Bool = false
    @Published var query: String = ""
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    private let disposeBag = DisposeBag()
    
    init(searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
        // Observe query changes
        $query
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newQuery in
                self?.search(query: newQuery)
            }
            .store(in: &cancellables)
    }
    
    
    private var cancellables = Set<AnyCancellable>()
    
    func search(query: String) {
        guard !query.isEmpty else { return }
        isLoading = true
        searchMoviesUseCase.execute(query: query)
            .observe(on: MainScheduler.instance) // ensure updates on UI thread
            .subscribe(
                onNext: { [weak self] movies in
                    self?.results = movies
                    self?.isLoading = false
                },
                onError: { [weak self] error in
                    self?.isLoading = false
                    print(error.localizedDescription)
                }
            )
            .disposed(by: disposeBag)
    }
}
