//
//  GSSearchButton.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

class GSSearchButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        layer.borderWidth = 0.1
        layer.borderColor = UIColor.systemGray5.cgColor
        backgroundColor = .systemGreen
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        setTitle("Search", for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.systemGray, for: .highlighted)
    }
}
