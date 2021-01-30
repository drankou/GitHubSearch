//
//  UICollectionReusableView+ReuseIdentifier.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 30.01.2021.
//

import UIKit

extension UICollectionReusableView {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
