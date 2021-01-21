//
//  UserDetailViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

class UserDetailViewController: UIViewController {
    var user: User!
    weak var coordinator: MainCoordinator?
    var activityIndicator = UIActivityIndicatorView()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserDetails()
    }
    
    private func fetchUserDetails() {
        showActivityIndicator()
        let dataLoader = DataLoader()
        dataLoader.request(.userInfo(for: user.login), of: User.self) { (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.activityIndicator.stopAnimating()

                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac, animated: true)
                }
            case .success(let user):
                //copy existing image to new user instance
                if self.user.avatarImage != ImageCache.publicCache.placeholderImage {
                    user.avatarImage = self.user.avatarImage
                }
                
                self.user = user
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    self.activityIndicator.stopAnimating()
                    
                    let userDetail = UserDetailView(user: user)
                    self.view.addSubview(userDetail)
                    userDetail.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        userDetail.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                        userDetail.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                        userDetail.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                    ])
                }
            }
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.color = .lightGray
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
}

