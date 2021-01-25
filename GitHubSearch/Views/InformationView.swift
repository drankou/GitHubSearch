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
            if let newValue = newValue, newValue.length == .zero {
                label.attributedText = newValue
            } else {
                self.isHidden = true
            }
        }
    }
    
    init(image: UIImage?, label: UILabel) {
        self.image = image
        self.label = label
        super.init(frame: .zero)
        configureView()
    }
    
    lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconImageView, label])
        stack.axis = .horizontal
        stack.alignment = .center
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
            imageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)
        
        return imageView
    }()
    
    private func configureView() {
        addSubview(containerStack)
    
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        iconImageView.image = self.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
