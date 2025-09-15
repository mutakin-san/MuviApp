//
//  MovieCardView.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import SwiftUI
import Kingfisher

struct MovieCardView: View {
    let movie: Movie
    
    var body: some View {
        KFImage(APIConfig.imageURL(
            path: movie.posterPath))
        .resizable()
        .roundCorner(
            radius: .point(8)
        )
        .serialize(as: .PNG)
        .frame(width: 102, height: 157)
        .shadow(radius: 8)
    }
}
