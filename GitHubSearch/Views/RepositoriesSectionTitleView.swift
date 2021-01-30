//
//  RepositoriesSectionTitleView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 30.01.2021.
//

import UIKit

class RepositoriesSectionTitleView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let popularImageView: UIImageView = {
        let imageView = UIImageView(image: SFSymbols.star)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 25),
            imageView.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Popular"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        return label
    }()
    
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [popularImageView, label])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private func configure() {
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
