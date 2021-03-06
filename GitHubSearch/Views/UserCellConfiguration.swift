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

        userImageView.image = configuration.userImage
        loginLabel.text = configuration.userLogin
    }
    
    private func setupInternalViews() {
        addSubview(containerStack)
        containerStack.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        //so image height and width is equal to dynamically calculated width of parent view from
        userImageView.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.height.equalTo(self.snp.width)
        }
    }
    
    lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageContainerView, loginLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageContainerView)
        }
        
        return stack
    }()

    private let imageContainerView: UIView = {
        let containerView = UIView()
        
        containerView.backgroundColor = UIColor.white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 2, height: 4)
        containerView.layer.cornerRadius = 12
        containerView.layer.shouldRasterize = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
                        
        return containerView
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
    
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: UIFont.labelFontSize)!
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
}
