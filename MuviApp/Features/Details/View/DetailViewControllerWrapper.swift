//
//  DetailViewControllerWrapper.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//
import SwiftUI

struct DetailViewControllerWrapper: UIViewControllerRepresentable {
    @EnvironmentObject var viewModel: DetailViewModel
    @EnvironmentObject var favoriteViewModel: FavoriteMovieViewModel
    let movieId: Int
    
    func makeUIViewController(context: Context) -> DetailViewController {
        viewModel.fetchMovie(id: movieId)
        let vc = DetailViewController(favoriteViewModel: favoriteViewModel)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DetailViewController, context: Context) {
        uiViewController.delegate?.didDataChange(detailMovie: viewModel.movie)
    }
}
