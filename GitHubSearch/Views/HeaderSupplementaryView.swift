//
//  HeaderSupplementaryView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 27.01.2021.
//

import UIKit

class HeaderSupplementaryView: UICollectionReusableView {    
    var user: User! {
        didSet {
            applyUserData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private func applyUserData(){
        userImage.image = user.avatarImage.roundedImage
        
        if let name = user.name, !name.isEmpty {
            nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            loginLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        } else {
            loginLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        }
        
        nameLabel.text = user.name
        loginLabel.text = user.login
        
        if let bio = user.bio, !bio.isEmpty {
            bioLabel.text = bio
        } else {
            bioLabel.isHidden = true
        }
        
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
    
    private func configure() {
        addSubview(containerStack)
        containerStack.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(15)
        }
    }
    
    lazy var containerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [headerStack, bioLabel, companyInformationView, locationInformationView,
                                                   mailInformatioView, blogInformationView, followersFollowingInformationView])
        stack.isLayoutMarginsRelativeArrangement = true
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        //?: enable layoutMargins break layout and scrolling areas in collection view

        return stack
    }()
    
    lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [userImage, nameStack])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.snp.makeConstraints { (make) in
            make.height.equalTo(80)
        }

        return stack
    }()
    
    private let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(70)
            make.height.equalTo(70)
        }
        
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
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private let companyInformationView = InformationView(image: SFSymbols.company)
    private let locationInformationView = InformationView(image: SFSymbols.location)
    private let mailInformatioView = InformationView(image: SFSymbols.mail)
    private let blogInformationView = InformationView(image: SFSymbols.link)
    private let followersFollowingInformationView = InformationView(image: SFSymbols.person)
}
