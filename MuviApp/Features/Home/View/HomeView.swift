//
//  HomeView.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeVM: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack(spacing: 0) {
                    Text("Movie")
                        .font(
                            .system(size: 32, weight: .bold, design: .default))
                    Text("DB")
                        .font(
                            .system(size: 32, weight: .bold, design: .default)
                        )
                        .foregroundStyle(.muviYellow)
                }
                Spacer()
                Image(.bell)
                    .frame(width: 18, height: 18)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .background(.muviBlack)

            ScrollView {
                MuviSliderView(movies: homeVM.nowPlayingMovies)
                ListMovie(title: "Popular Movies", movies: homeVM.popularMovies)
                ListMovie(title: "Cooming Soon", movies: homeVM.upcomingMovies)
            }
        }
        .background(.muviBackground)

        .onAppear {
            homeVM.fetchNowPlayingMovies()
            homeVM.fetchPopularMovies()
            homeVM.fetchUpcomingMovies()
        }
    }
}

#Preview {
    HomeView()
}
