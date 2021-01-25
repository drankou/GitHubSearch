//
//  EmptyResultsView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 17.01.2021.
//

import UIKit

class EmptyResultsView: UIView {
    init(text: String) {
        super.init(frame: UIScreen.main.bounds)
        configureView(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(with text: String) {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "No results for: \"\(text)\""
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
