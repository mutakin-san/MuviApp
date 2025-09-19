//
//  CustomTabBar.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//


import SwiftUI

enum Menus: String, CaseIterable {
    case home = "house.fill"
    case search = "rosette"
    case favorite = "heart"
}

struct CustomTabBar: View {
    @Binding var selectedMenu: Menus

    var body: some View {
        HStack {
            ForEach(Menus.allCases, id: \.self) { menu in
                Button {
                    withAnimation(.easeInOut) {
                        selectedMenu = menu
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: menu.rawValue)
                            .font(.system(size: 22))
                            .foregroundColor(selectedMenu == menu ? .muviYellow : .white)

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
    @State private var selectedMenu: Menus = .home

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedMenu {
                case .home: HomeView().foregroundStyle(.white)
                case .search: SearchView().foregroundStyle(.white)
                case .favorite: FavoriteView().foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.muviBackground)

            CustomTabBar(selectedMenu: $selectedMenu)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    CustomTabView()
}
