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
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
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
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private func configure() {
        addSubview(containerStack)
        containerStack.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
}
