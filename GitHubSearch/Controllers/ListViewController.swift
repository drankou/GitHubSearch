//
//  ListViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 31.01.2021.
//

import UIKit

class ListViewController: UIViewController {
    weak var coordinator: MainCoordinator?
    
    var user: User!
    var listType: ListItem.Category!
    var tableView: UITableView!
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = listType.rawValue
        
        tableView = UITableView(frame: view.bounds)
        tableView.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
}
