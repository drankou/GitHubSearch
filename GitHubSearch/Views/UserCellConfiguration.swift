//
//  UserCellConfiguration.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {}

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
    init(configuration: UserCellContentConfiguration) {
        super.init(frame: .zero)
        setupInternalViews()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var configuration: UIContentConfiguration {
        get { appliedConfiguration }
        set {
            guard let newConfig = newValue as? UserCellContentConfiguration else { return }
            apply(configuration: newConfig)
        }
    }
    
    private let imageView = UIImageView()
    private let label = UILabel()
    
    private func setupInternalViews() {
        let itemStackView = UIStackView()
        addSubview(itemStackView)
        itemStackView.axis = .vertical
        itemStackView.alignment = .center
        itemStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemStackView.centerXAnchor.constraint(equalTo: self.layoutMarginsGuide.centerXAnchor),
            itemStackView.centerYAnchor.constraint(equalTo: self.layoutMarginsGuide.centerYAnchor),
            itemStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
            itemStackView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])

        itemStackView.addArrangedSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        itemStackView.addArrangedSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: itemStackView.widthAnchor),
        ])
    }

    
    private var appliedConfiguration: UserCellContentConfiguration!
    
    private func apply(configuration: UserCellContentConfiguration) {
        guard appliedConfiguration != configuration else { return }
        appliedConfiguration = configuration

        imageView.image = configuration.userImage ?? UIImage(named: "user-default.png")?.roundedImage
        label.text = configuration.userLogin
    }
}
