//
//  UserDetailViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 14.01.2021.
//

import UIKit

class UserDetailViewController: UIViewController {
    var user: User?
    weak var coordinator: MainCoordinator?
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
