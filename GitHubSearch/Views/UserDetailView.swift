//
//  UserDetailView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 19.01.2021.
//

import UIKit

class UserDetailView: UIView {
    var user: User
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        let userDetailStackView = UIStackView()
        addSubview(userDetailStackView)

        userDetailStackView.axis = .vertical
        userDetailStackView.spacing = 10
        userDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userDetailStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            userDetailStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            userDetailStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            userDetailStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
        
        [headerView(), bioView(), companyView(), locationView(), blogView(), emailView(), followersFollowingView()].forEach {
            if let subview = $0 {
                userDetailStackView.addArrangedSubview(subview)
            }
        }
    }
    
    private func headerView() -> UIView {
        let headerStackView = UIStackView()
        headerStackView.axis = .horizontal
        headerStackView.spacing = 16
        headerStackView.alignment = .center
        
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let userImage = UIImageView()
        userImage.image = user.avatarImage.roundedImage
        userImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImage.widthAnchor.constraint(equalToConstant: 65),
            userImage.heightAnchor.constraint(equalToConstant: 65)
        ])
        
        [userImage, nameView()].forEach { headerStackView.addArrangedSubview($0)}

        return headerStackView
    }
        
    private func nameView() -> UIView {
        let namesStackView = UIStackView()
        namesStackView.axis = .vertical
        namesStackView.alignment = .leading
        
        let nameLabel = UILabel()
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.75
        let loginLabel = UILabel()
        
        if let name = user.name, !name.isEmpty {
            nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            nameLabel.text = user.name
            
            loginLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
            loginLabel.text = user.login
            loginLabel.textColor = .gray
        } else {
            nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
            nameLabel.textColor = .gray
            nameLabel.text = user.login
        }
        
        [nameLabel, loginLabel].forEach { namesStackView.addArrangedSubview($0) }

        return namesStackView
    }
    
    private func bioView() -> UIView? {
        guard let bio = user.bio, !bio.isEmpty else { return nil}
        
        let bioLabel = UILabel()
        bioLabel.text = bio
        bioLabel.numberOfLines = 0
        bioLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        return bioLabel
    }
    
    private func companyView() ->  UIView? {
        guard let company = user.company, !company.isEmpty else { return nil }
        
        let companyLabel = UILabel()
        companyLabel.text = company
        companyLabel.setContentHuggingPriority(.required, for: .horizontal)
        companyLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        companyLabel.font = UIFont.systemFont(ofSize: 14)
        
        return InformationView(image: SFSymbols.company, label: companyLabel)
    }
    
    private func locationView() -> UIView? {
        guard let location = user.location, !location.isEmpty else { return nil }
        
        let locationLabel = UILabel()
        locationLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        locationLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        locationLabel.text = location
        locationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        return InformationView(image: SFSymbols.location, label: locationLabel)
    }
    
    private func emailView() -> UIView? {
        guard let email = user.email, !email.isEmpty else { return nil }
        
        let mailLabel = UILabel()
        mailLabel.text = email
        mailLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        return InformationView(image: SFSymbols.mail, label: mailLabel)
    }
    
    private func blogView() -> UIView? {
        guard let blog = user.blog, !blog.isEmpty else { return nil }
        
        let blogLabel = UILabel()
        blogLabel.text = blog
        blogLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        return InformationView(image: SFSymbols.link, label: blogLabel)
    }
    
    private func followersFollowingView() -> UIView? {
        guard user.type == .user else { return nil }
        let attributedText = NSMutableAttributedString()
            .append("\(user.followers?.abbreviationValue ?? "0")", font: .numbers)
            .append(" followers \u{2022} ", font: .text)
            .append("\(user.following?.abbreviationValue ?? "0")", font: .numbers)
            .append(" following", font: .text)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.attributedText = attributedText
        
        return InformationView(image: SFSymbols.person, label: label)
    }
}
