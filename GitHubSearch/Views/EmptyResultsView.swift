//
//  EmptyResultsView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 17.01.2021.
//

import UIKit

class EmptyResultsView: UIView {
    init(query: String) {
        super.init(frame: UIScreen.main.bounds)
        configureView(with: query)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(with query: String) {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Couldn't find any matching user for: \"\(query)\""
        label.textColor = .systemGray
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
}