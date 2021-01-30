//
//  UIViewController+ActivityIndicator.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 23.01.2021.
//

import UIKit

var activityIndicatorView: UIView?

extension UIViewController {
    func showActivityIndicator(view: UIView) {
        let containerView = UIView(frame: view.bounds)
        containerView.backgroundColor = .systemBackground
        view.addSubview(containerView)
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubview(activityIndicator)
        activityIndicator.color = .systemGray2
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        activityIndicatorView = containerView
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            activityIndicatorView?.removeFromSuperview()
            activityIndicatorView = nil
        }
    }

    func showErrorMessageAlert(_ message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            ac.modalPresentationStyle = .overFullScreen
            ac.modalTransitionStyle = .crossDissolve
            
            self.present(ac, animated: true)
        }
    }
    
    func showEmptyView(over view: UIView, with text: String) {
        DispatchQueue.main.async {
            let emptyResultsView = EmptyResultsView(text: text)
            view.addSubview(emptyResultsView)
        }
    }
}
