//
//  UserDetailView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 19.01.2021.
//

import UIKit

class UserDetailView: UIView {
    var user: User? {
        didSet {
            apply()
        }
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply() {
        guard let user = user else { return }
        userImage.image = user.avatarImage.roundedImage
        
        if let name = user.name, !name.isEmpty {
            nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            loginLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        } else {
            loginLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        }
        
        nameLabel.text = user.name
        loginLabel.text = user.login
        bioLabel.text = user.bio
        companyInformationView.text = user.company
        locationInformationView.text = user.location
        mailInformatioView.text = user.email
        blogInformationView.text = user.blog
        
        followersFollowingInformationView.attributedText = NSMutableAttributedString()
            .append("\(user.followers?.abbreviationValue ?? "0")", font: .numbers)
            .append(" followers \u{2022} ", font: .text)
            .append("\(user.following?.abbreviationValue ?? "0")", font: .numbers)
            .append(" following", font: .text)
    }
    
    private func configureView() {
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStack, bioLabel, companyInformationView, locationInformationView,
                                                   mailInformatioView, blogInformationView, followersFollowingInformationView])
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false

        return stack
    }()
    
    lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImage, nameStack])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 65),
            imageView.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        return imageView
    }()
    
    lazy var nameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, loginLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        
        return label
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray

        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        return label
    }()
    
    private let companyInformationView: InformationView = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 14)
        
        return InformationView(image: SFSymbols.company, label: label)
    }()
    
    private let locationInformationView: InformationView = {
        let label = UILabel()
        label.setContentHuggingPriority(.init(249), for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        return InformationView(image: SFSymbols.location, label: label)
    }()
    
    private let mailInformatioView: InformationView = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        return InformationView(image: SFSymbols.mail, label: label)
    }()
    
    private let blogInformationView: InformationView = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        return InformationView(image: SFSymbols.link, label: label)
    }()
    
    private let followersFollowingInformationView: InformationView = {
        let label = UILabel()
        
        return InformationView(image: SFSymbols.person, label: label)        
    }()
}
