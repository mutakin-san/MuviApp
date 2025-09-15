//
//  ListMovie.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import SwiftUI

struct ListMovie: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 16) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .default))
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(movies, id: \.id) { movie in
                            NavigationLink {
                                DetailViewControllerWrapper(movieId:  movie.id)
                                    .ignoresSafeArea()
                            } label: {
                                MovieCardView(movie: movie)
                            }
                        }
                    }
                }
            }
            
        }
        .padding(.top, 32)
        .padding(.horizontal)
    }
}
