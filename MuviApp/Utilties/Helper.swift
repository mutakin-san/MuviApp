//
//  Helper.swift
//  MuviApp
//
//  Created by Mutakin on 10/09/25.
//

import UIKit

func formatRuntime(_ minutes: Int) -> String {
    let hours = minutes / 60
    let mins = minutes % 60
    
    if hours > 0 {
        return "\(hours)h \(mins)m"
    } else {
        return "\(mins)m"
    }
}

extension UIImageView {
    func loadImage(from url: URL?) {        
        // Add activity indicator
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        activityIndicator.startAnimating()
        
        // Load image
        guard url != nil else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            return
        }
        
        URLSession.shared.dataTask(with: url!) { [weak self] data, _, error in
            DispatchQueue.main.async {
               activityIndicator.stopAnimating()
               activityIndicator.removeFromSuperview()
            }
            
            if let data = data, error == nil, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}

