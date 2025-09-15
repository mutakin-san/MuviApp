//
//  CustomSliderView.swift
//  MuviApp
//
//  Created by Mutakin on 09/09/25.
//

import SwiftUI
import Kingfisher

struct MuviSliderView: View {
    let movies: [Movie]
    @State private var selectedIndex = 0

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                TabView(selection: $selectedIndex) {
                    ForEach(0..<movies.count, id: \.self) { index in
                        NavigationLink{
                            DetailViewControllerWrapper(movieId:  movies[index].id)
                                .ignoresSafeArea()
                        } label: {
                            KFImage(APIConfig.imageURL(
                                path: movies[index].backdropPath,
                                size: APIConfig.backdropSize))
                            .resizable()
                            .serialize(as: .PNG)
                            .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.horizontal, 0)
                .frame(idealHeight: 259)
            }

            HStack(spacing: 6) {
                ForEach(0..<movies.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            selectedIndex == index
                            ? .muviYellow : .muviYellow.opacity(0.5)
                        )
                        .frame(
                            width: selectedIndex == index ? 33 : 11,
                            height: 5
                        )
                        .animation(
                            .easeInOut(duration: 0.25), value: selectedIndex)
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .padding(.bottom, 15)
        }
    }
}

#Preview {
    MuviSliderView(movies: [])
}
