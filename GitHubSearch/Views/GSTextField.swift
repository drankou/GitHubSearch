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
    
    var textPadding = UIEdgeInsets(
        top: 5,
        left: 5,
        bottom: 5,
        right: 5
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    private func setupView() {
        layer.cornerRadius = 12
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray3.cgColor
        
        autocorrectionType = .no
        placeholder = "Enter username"
        returnKeyType = .search
        textAlignment = .center
        textColor = .label
        font = .preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 20
        clearButtonMode = .always
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
