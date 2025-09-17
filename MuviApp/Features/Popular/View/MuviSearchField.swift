//
//  SearchField.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//


import SwiftUI

struct MuviSearchField: View {
    @Binding var text: String
    var placeholder: String = "Search"
    var onSubmit: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField(text: $text) {
                    Text("Search")
                        .foregroundStyle(.white.opacity(0.7))
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onSubmit {
                    onSubmit(text)
                }
                
                Button {
                    onSubmit(text)
                } label: {
                    Image(.search)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }
            .padding(.vertical, 8)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.5))
        }
    }
}
