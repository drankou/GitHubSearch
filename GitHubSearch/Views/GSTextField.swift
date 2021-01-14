//
//  GSTextField.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

class GSTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    private func setupView() {
        layer.cornerRadius = 12
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray3.cgColor
        
        autocorrectionType = .no
        placeholder = "Enter username"
        returnKeyType = .search
        textAlignment = .center
        font = .preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 20
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
