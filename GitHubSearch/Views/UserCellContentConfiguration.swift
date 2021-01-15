//
//  UserCellContentConfiguration.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    override func updateConfiguration(using state: UICellConfigurationState) {
        //
    }
}

struct UserCellContentConfiguration: UIContentConfiguration {    
    var username: String?
    var userImage: UIImage?
    
    func makeContentView() -> UIView & UIContentView {
        return UserCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}

class UserCellContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        configureCellView()
    }
    
    private func configureCellView(){
        guard let configuration = configuration as? UserCellContentConfiguration else { return }
        
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
        
        let userImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        userImageView.image = configuration.userImage?.roundedImage
        userImageView.contentMode = .scaleAspectFit
        userImageView.translatesAutoresizingMaskIntoConstraints = false

        let usernameLabel = UILabel()
        usernameLabel.text = configuration.username
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        [userImageView, usernameLabel].forEach({itemStackView.addArrangedSubview($0)})        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
