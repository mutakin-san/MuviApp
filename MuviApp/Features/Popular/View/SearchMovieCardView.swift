//
//  MovieCardView.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import SwiftUI

struct SearchMovieCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(
                    url: APIConfig.imageURL(
                        path: movie.posterPath)
                ) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: 214)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0))
                            .clipped()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 214)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0))
                            .clipped()
                    case .failure:
                        Color.gray
                            .frame(maxWidth: .infinity, maxHeight: 214)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0))
                            .clipped()
                    @unknown default:
                        EmptyView()
                            .frame(maxWidth: .infinity, maxHeight: 214)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0))
                            .clipped()
                    }
                }
                if !movie.genres.isEmpty {
                    Text(movie.genres.map{ $0.name }.joined(separator: ", "))
                        .font(.caption)
                        .padding(2)
                        .background(.muviYellow)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .padding([.leading, .bottom, .trailing], 8)
                }
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                Text(movie.credits?.cast.map({ actor in
                    actor.name
                }).joined(separator: ", ") ?? "")
                .font(.system(size: 10))
                .foregroundStyle(.foreground.opacity(0.6))
            }
        }
        
    }
}
