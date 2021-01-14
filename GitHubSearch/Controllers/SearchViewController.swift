//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

class SearchViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    
    override func loadView() {
        super.loadView()
        let searchView = SearchView()
        searchView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        searchView.usernameTextField.delegate = self
        
        view = searchView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: Private methods
    @objc private func searchButtonTapped() {

    }
}


// MARK: UITextFieldDelegate extension
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

