//
//  FavoriteView.swift
//  MuviApp
//
//  Created by Mutakin on 17/09/25.
//

import Kingfisher
import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var favoriteViewModel: FavoriteMovieViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            MuviSearchField(text: $favoriteViewModel.query) { text in
                
            }
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(favoriteViewModel.filteredMovies, id: \.id) {
                        (favoriteMovie: FavoriteMovie) in
                        HStack(alignment: .top, spacing: 8.0) {
                            KFImage(APIConfig.imageURL(path: favoriteMovie.backdropPath ?? "", size: APIConfig.backdropSize))
                                .resizable()
                                .roundCorner(
                                    radius: .point(8)
                                )
                                .serialize(as: .PNG)
                                .frame(width: 160, height: 90)

                            VStack(alignment: .leading) {
                                Text(favoriteMovie.title)
                                    .font(.title2)
                                    .lineLimit(2)
                                Text("\(favoriteMovie.releaseYear)")
                                    .font(.caption)
                                    .padding(.bottom, 2)
                                Text(favoriteMovie.categories)
                                    .font(.caption2)
                            }
                            Spacer()
                            Button {
                                // aksi favorit di sini
                            } label: {
                                Image(systemName: "heart.fill")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 12, height: 12)
                                   .foregroundColor(.white)
                                   .frame(width: 24, height: 24)
                                   .background(Color.muviYellow.opacity(0.8))
                                   .clipShape(Circle())
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            favoriteViewModel.fetchFavoriteMovies()
        }
    }
}

#Preview {
    let favoriteViewModel: FavoriteMovieViewModel = AppAssembler().resolve()
    FavoriteView()
        .environmentObject(favoriteViewModel)
}
