//
//  UserCellConfiguration.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    public func defaultCellConfiguration() -> UserCellContentConfiguration {
        return UserCellContentConfiguration()
    }
}

struct UserCellContentConfiguration: UIContentConfiguration, Hashable {
    var userLogin: String?
    var userImage: UIImage?
    
    func makeContentView() -> UIView & UIContentView {
        return UserCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

class UserCellContentView: UIView, UIContentView {
   
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? UserCellContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private var appliedConfiguration: UserCellContentConfiguration!
    
    init(configuration: UserCellContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func apply(configuration: UserCellContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration

        imageView.image = configuration.userImage
        label.text = configuration.userLogin
    }

    private let imageView = UIImageView()
    private let label = UILabel()
    
    private func setupInternalViews() {
        let itemStackView = UIStackView()
        addSubview(itemStackView)
        itemStackView.axis = .vertical
        itemStackView.alignment = .center
        itemStackView.distribution = .fill
        itemStackView.spacing = 8
        
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            itemStackView.topAnchor.constraint(equalTo: self.topAnchor),
            itemStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            itemStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        let imageContainerView = UIView()
        itemStackView.addArrangedSubview(imageContainerView)
        
        imageContainerView.backgroundColor = UIColor.white
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOpacity = 0.5
        imageContainerView.layer.shadowOffset = CGSize(width: 2, height: 4)
        imageContainerView.layer.cornerRadius = 12
        
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageContainerView.widthAnchor.constraint(equalTo: itemStackView.widthAnchor),
            imageContainerView.heightAnchor.constraint(equalTo: itemStackView.widthAnchor)
        ])
        
        imageContainerView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
        ])
        
        itemStackView.addArrangedSubview(label)
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: UIFont.labelFontSize)!
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        label.translatesAutoresizingMaskIntoConstraints = false
    }
}
