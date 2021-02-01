//
//  EmptyResultsView.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 17.01.2021.
//

import UIKit
import SnapKit

class EmptyResultsView: UIView {
    init(text: String) {
        super.init(frame: UIScreen.main.bounds)
        configureView(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView(with text: String) {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.textColor = .systemGray
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.8)
        }
    }
}
