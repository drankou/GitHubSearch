//
//  SearchView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

class SearchView: UIView {
    var usernameTextField: UITextField!
    var searchButton: UIButton!
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor, constant: 0),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: -70),
        ])
  
                
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "github-logo.png")
        stackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 230),
            imageView.widthAnchor.constraint(equalToConstant: 230),
        ])
        
        usernameTextField = GSTextField()
        stackView.addArrangedSubview(usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 45),
            usernameTextField.widthAnchor.constraint(equalTo: stackView.layoutMarginsGuide.widthAnchor),
        ])
        
        searchButton = GSSearchButton()
        stackView.addArrangedSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 45),
            searchButton.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
