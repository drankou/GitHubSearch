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
        self.hideKeyboardWhenTappedAround()
        
        usernameTextField.delegate = self
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    
    //MARK: Private methods
    @objc private func searchButtonTapped() {
        let username = usernameTextField.text ?? ""

        if !username.isEmpty{
            coordinator?.searchForUser(username)
        } else if username.isEmpty{
            let ac = UIAlertController(title: "Username shouldn't be empty", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        } else if username.count > 39 {
            let ac = UIAlertController(title: "Github username may contain maximum of \(String()) characters", message: nil, preferredStyle: .alert)
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let username = textField.text ?? ""
        
        guard let stringRange = Range(range, in: username) else { return false }
        let maximumInputText = username.replacingCharacters(in: stringRange, with: string)
        return maximumInputText.count <= 39
    }
}

// MARK: Keyboard dismissing
extension SearchViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
