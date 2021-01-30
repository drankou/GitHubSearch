//
//  NSMutableAttributedString+Append.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 21.01.2021.
//

import UIKit

extension NSMutableAttributedString {
    enum FollowersFont {
        case numbers
        case text
    }
    
    func append(_ value:String, font: FollowersFont) -> NSMutableAttributedString {
        let attributes:[NSAttributedString.Key : Any] = [
            .font : font == .numbers ? UIFont.systemFont(ofSize: 14, weight: .bold) : UIFont.systemFont(ofSize: 14, weight: .regular),
            .foregroundColor: font == .numbers ? UIColor.label : UIColor.systemGray
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
