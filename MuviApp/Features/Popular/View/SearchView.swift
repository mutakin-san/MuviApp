//
//  SearchView.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchVM: SearchViewModel
    
    private let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            MuviSearchField(text: $searchVM.query) { text in
                searchVM.search(query: text)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .background(.muviBlack)
            Spacer()
            if !searchVM.isLoading && searchVM.results.isEmpty {
                Text("What are you looking for?")
            } else if searchVM.isLoading {
                VStack {
                    ProgressView()
                        .tint(.muviYellow)
                    Text("Loading")
                        .foregroundStyle(.white)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Showing result of ‘\(searchVM.query)’")

                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(searchVM.results, id: \.id) { result in
                                NavigationLink {
                                    DetailViewControllerWrapper(movieId: result.id)
                                        .ignoresSafeArea()
                                } label: {
                                    SearchMovieCardView(movie: result)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            Spacer()
        }
    }
}

#Preview {
    SearchView()
}
