//
//  SearchView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit
import SnapKit

class SearchView: UIView {
    let queryTextField = GSTextField()

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        backgroundColor = .systemBackground
        addSubview(containerStack)
        containerStack.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-70)
        }
        
        logoImageView.tintColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [logoImageView, queryTextField, searchButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "github-logo.png")?.withRenderingMode(.alwaysTemplate)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(230)
            make.height.equalTo(230)
        }
        
        return imageView
    }()
    
    let searchButton = GSSearchButton()
}
