//
//  MainCoordinator.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let searchVC = SearchViewController()
        searchVC.coordinator = self
        navigationController.pushViewController(searchVC, animated: true)
    }
    
    func searchForUser(_ name: String) {
        let resultsVC = SearchResultsViewController()
        resultsVC.coordinator = self
        resultsVC.username = name
        navigationController.pushViewController(resultsVC, animated: true)
    }
    
    func showUserDetails(for user: User) {
        let userDetailVC = UserDetailViewController()
        userDetailVC.coordinator = self
        userDetailVC.user = user
        navigationController.pushViewController(userDetailVC, animated: true)
    }
}