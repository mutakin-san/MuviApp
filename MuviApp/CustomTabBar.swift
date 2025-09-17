//
//  CustomTabBar.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//


import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedIndex: Int
    let icons = ["house.fill", "rosette", "heart", "square.grid.2x2"]

    var body: some View {
        HStack {
            ForEach(0..<icons.count, id: \.self) { index in
                Button {
                    withAnimation(.easeInOut) {
                        selectedIndex = index
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: icons[index])
                            .font(.system(size: 22))
                            .foregroundColor(selectedIndex == index ? .muviYellow : .white)

                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 12)
        .background(.muviBlack)
    }
}

struct CustomTabView: View {
    @State private var selectedIndex = 0

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedIndex {
                case 0: HomeView().foregroundStyle(.white)
                case 1: SearchView().foregroundStyle(.white)
                case 2: FavoriteView().foregroundColor(.white)
                case 3: Text("Grid").foregroundColor(.white)
                default: Text("Other").foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.muviBackground)

            CustomTabBar(selectedIndex: $selectedIndex)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    CustomTabView()
}
