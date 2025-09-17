//
//  MuviAppApp.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import SwiftUI

@main
struct MuviAppApp: App {
    
    private var assembler: AppAssembler = .init()

    @ObservedObject private var homeViewModel: HomeViewModel
    @ObservedObject private var movieDetailViewModel: DetailViewModel
    @ObservedObject private var searchViewModel: SearchViewModel
    @ObservedObject private var favoriteViewModel: FavoriteMovieViewModel
    
    init () {
        self.homeViewModel = assembler.resolve()
        self.movieDetailViewModel = assembler.resolve()
        self.searchViewModel = assembler.resolve()
        self.favoriteViewModel = assembler.resolve()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeViewModel)
                .environmentObject(movieDetailViewModel)
                .environmentObject(searchViewModel)
                .environmentObject(favoriteViewModel)
        }
    }
}
