//
//  InformationView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 21.01.2021.
//

import UIKit

class InformationView: UIView {
    var image: UIImage?
    var label: UILabel
    
    init(image: UIImage?, label: UILabel) {
        self.image = image
        self.label = label
        super.init(frame: .zero)
        configureView()
    }
    
    private func configureView() {
        let stackView = UIStackView()
        addSubview(stackView)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        let imageView = UIImageView(frame: .zero)
        imageView.image = self.image
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])

        [imageView, label].forEach { stackView.addArrangedSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
