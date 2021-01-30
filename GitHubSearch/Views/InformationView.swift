//
//  InformationView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 21.01.2021.
//

import UIKit

class InformationView: UIView {
    var text: String? {
        willSet {
            if let newValue = newValue, !newValue.isEmpty {
                label.text = newValue
            } else {
                self.isHidden = true
            }
        }
    }
        
    var attributedText: NSAttributedString? {
        willSet {
            if let newValue = newValue, newValue.length != .zero {
                label.attributedText = newValue
            } else {
                self.isHidden = true
            }
        }
    }
    
    init(image: UIImage) {
        super.init(frame: .zero)
        self.iconImageView.image = image
        configureView()
    }
    
    lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, label])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])

        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        
        return label
    }()
    
    private func configureView() {
        addSubview(containerStack)
    
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
