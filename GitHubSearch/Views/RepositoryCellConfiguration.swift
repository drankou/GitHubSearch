//
//  RepositoryCellConfiguration.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 22.01.2021.
//

import UIKit

class RepositoryCell: UICollectionViewCell {
    func defaultContentConfiguration() -> RepositoryCellContentConfiguration {
        return RepositoryCellContentConfiguration()
    }
}

struct RepositoryCellContentConfiguration: UIContentConfiguration, Hashable {
    var userImage: UIImage?
    var userLogin: String?
    var repositoryName: String?
    var repositoryDescription: String?
    var repositoryLanguage: String?
    var stargazersCount: Int?
    
    func makeContentView() -> UIView & UIContentView {
        return RepositoryCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

class RepositoryCellContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? RepositoryCellContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }

    init(configuration: RepositoryCellContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var appliedConfiguration: RepositoryCellContentConfiguration!

    private func apply(configuration: RepositoryCellContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration
        
        userImageView.image = configuration.userImage?.roundedImage ?? ImageCache.publicCache.placeholderImage
        userLogin.text = configuration.userLogin
        repositoryName.text = configuration.repositoryName
        
        if let description = configuration.repositoryDescription{
            repositoryDescription.text = description.isEmpty ? " " : description
        }
        
        repositoryDescription.sizeToFit()
        stargazersCount.text = "\(configuration.stargazersCount ?? 0)"
        repositoryLanguage.text = configuration.repositoryLanguage
    }
    
    private func setupInternalViews() {
        //parent view corner radius
        self.layer.borderWidth = 0.3
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        
        addSubview(containerStack)
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
        
    lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageLoginStack, nameDescriptionStack, stargazersLanguageStack])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 5
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    lazy var imageLoginStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImageView, userLogin])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 8 //weird spacing constraint conflict possible due to fractional width low value
                
        return stack
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25),
        ])
        
        imageView.setContentHuggingPriority(.required, for: .vertical)
        imageView.setContentHuggingPriority(.required, for: .horizontal)

        return imageView
    }()
    
    private let userLogin: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .gray
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
    }()
    
    lazy var nameDescriptionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [repositoryName, repositoryDescription])
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.axis = .vertical
        
        return stack
    }()
    
    private let repositoryName: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private let repositoryDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 2
        label.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        
        return label
    }()
    
    lazy var stargazersLanguageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [stargazersStack, languageStack])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.spacing = 8

        return stack
    }()
    
    lazy var stargazersStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [starImageView, stargazersCount])
        stack.axis = .horizontal
        stack.spacing = 2

        return stack
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: SFSymbols.star)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 16),
        ])
        
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .vertical)

        return imageView
    }()
    
    private let stargazersCount: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
    }()

    lazy var languageStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [repositoryLanguage])
        stack.axis = .horizontal
        stack.spacing = 2
        
        return stack
    }()
    
    private let repositoryLanguage: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        
        return label
    }()
}
