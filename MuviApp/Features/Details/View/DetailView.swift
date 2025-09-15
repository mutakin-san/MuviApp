//
//  DetailView.swift
//  MuviApp
//
//  Created by Mutakin on 11/09/25.
//
import UIKit

protocol DetailViewDelegate: NSObject {
    func didDataChange(detailMovie: Movie?) -> Void
}
