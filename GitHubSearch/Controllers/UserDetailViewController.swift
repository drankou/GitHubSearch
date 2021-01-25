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
        showActivityIndicator(view: view)
        let dataLoader = DataLoader()
        dataLoader.request(.userInfo(for: user.login), of: User.self) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showErrorMessageAlert(error.localizedDescription)
                }
            case .success(let user):
                //copy existing image to new user instance
                if self.user.avatarImage != ImageCache.publicCache.placeholderImage {
                    user.avatarImage = self.user.avatarImage
                }
                self.user = user
                
                DispatchQueue.main.async {
                    self.userDetailView.user = user
                    self.hideActivityIndicator()
                    self.userDetailView.isHidden = false
                    self.collectionView.isHidden = false
                }
            }
        }
    }
    
        
        
    }
}

