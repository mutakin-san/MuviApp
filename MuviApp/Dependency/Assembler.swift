//
//  Assembler.swift
//  MuviApp
//
//  Created by Mutakin on 15/09/25.
//

import Foundation

protocol Assembler: MovieAssembler, FavoriteMovieAssembler {}

class AppAssembler: Assembler, ObservableObject {}
