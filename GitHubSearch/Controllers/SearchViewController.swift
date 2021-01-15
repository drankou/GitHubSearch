//
//  ViewController.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

class SearchViewController: UIViewController {

    weak var coordinator: MainCoordinator?
    weak var searchButton: UIButton!
    weak var usernameTextField: UITextField!
    
    override func loadView() {
        super.loadView()
        
        let searchView = SearchView()
        searchButton = searchView.searchButton
        usernameTextField = searchView.usernameTextField
        
        view = searchView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: Private methods
    @objc private func searchButtonTapped() {
        if let username = usernameTextField.text, !username.isEmpty {
            coordinator?.searchForUser(username)
        } else {
            let ac = UIAlertController(title: "Username shouldn't be empty", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
}


// MARK: UITextFieldDelegate extension
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchButtonTapped()
        return true
    }
}

