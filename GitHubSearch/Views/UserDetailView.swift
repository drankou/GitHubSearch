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
    
    private func configureView() {
        self.backgroundColor = .white
        let userDetail = UIView(frame: .zero)
        addSubview(userDetail)

        userDetail.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userDetail.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            userDetail.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            userDetail.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            userDetail.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3),
        ])
        
        let userDetailStackView = UIStackView()
        userDetailStackView.axis = .vertical
        userDetailStackView.spacing = 10
        userDetail.addSubview(userDetailStackView)
        
        userDetailStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userDetailStackView.leadingAnchor.constraint(equalTo: userDetail.leadingAnchor),
            userDetailStackView.topAnchor.constraint(equalTo: userDetail.topAnchor),
            userDetailStackView.trailingAnchor.constraint(equalTo: userDetail.trailingAnchor),
        ])
        
        userDetailStackView.addArrangedSubview(header())
        
        let userStatus = UserStatusLabel()
        userStatus.layer.cornerRadius = 4
        userStatus.layer.masksToBounds = true
        userDetailStackView.addArrangedSubview(userStatus)
        userStatus.text = "🧠   Focusing"
        userStatus.backgroundColor = UIColor.init(white: 0.9, alpha: 0.35)
        userStatus.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userStatus.widthAnchor.constraint(equalTo: userDetailStackView.widthAnchor),
        ])
        
        let organizationLocationStack = UIStackView()
        organizationLocationStack.axis = .horizontal
        organizationLocationStack.alignment = .center
        organizationLocationStack.distribution = .fill
        organizationLocationStack.spacing = 20
        organizationLocationStack.translatesAutoresizingMaskIntoConstraints = false
        userDetailStackView.addArrangedSubview(organizationLocationStack)
        NSLayoutConstraint.activate([
            organizationLocationStack.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        [organization(), location()].forEach { organizationLocationStack.addArrangedSubview($0) }
        userDetailStackView.addArrangedSubview(mail())
        userDetailStackView.addArrangedSubview(followersFollowing())
        
    }
    
    func header() -> UIView {
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
        
        [userImage, names()].forEach { headerStackView.addArrangedSubview($0)}

        return headerStackView
    }
    
    func organization() -> UIView {
        let organizationLabel = UILabel()
        organizationLabel.text = "Cryptomood"
        organizationLabel.setContentHuggingPriority(.required, for: .horizontal)
        organizationLabel.font = UIFont.systemFont(ofSize: 14)
        
        return InformationView(image: UIImage(systemName: "building.2"), label: organizationLabel)
    }
    
    func location() -> UIView {
        let locationLabel = UILabel()
        locationLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        locationLabel.text = "Brno"
        locationLabel.textColor = .gray
        locationLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        
        return InformationView(image: UIImage(systemName: "mappin.and.ellipse"), label: locationLabel)
    }
    
    func mail() -> UIView {
        let mailLabel = UILabel()
        mailLabel.text = "drankovalexander@gmail.com"
        mailLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        return InformationView(image: UIImage(systemName: "envelope"), label: mailLabel)
    }
    
    func followersFollowing() -> UIView {
        let followers = 2
        let following = 4
        
        let attributedText = NSMutableAttributedString()
            .append("\(followers)", font: UIFont.systemFont(ofSize: 14, weight: .bold))
            .append(" followers \u{2022} ", font: UIFont.systemFont(ofSize: 14, weight: .regular))
            .append("\(following)", font: UIFont.systemFont(ofSize: 14, weight: .bold))
            .append(" following", font: UIFont.systemFont(ofSize: 14, weight: .regular))
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.attributedText = attributedText
        
        return InformationView(image: UIImage(systemName: "person"), label: label)
    }
    
    func names() -> UIView {
        let namesStackView = UIStackView()
        namesStackView.axis = .vertical
        namesStackView.alignment = .leading
        
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        nameLabel.text = "Aliaksandr Drankou"
        
        let loginLabel = UILabel()
        loginLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        loginLabel.text = user.login
        loginLabel.textColor = .gray
        
        [nameLabel, loginLabel].forEach { namesStackView.addArrangedSubview($0) }
        
        return namesStackView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NSMutableAttributedString {
    func append(_ value:String, font: UIFont) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}


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
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        
        addSubview(stackView)
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

class UserStatusLabel: UILabel {
    var topInset: CGFloat = 10
    var bottomInset: CGFloat = 10
    var leftInset: CGFloat = 10
    var rightInset: CGFloat = 10
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


