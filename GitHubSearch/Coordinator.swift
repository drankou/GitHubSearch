//
//  Coordinator.swift
//  GitHubSearch
//
//  Created by Aliaksandr Drankou on 13.01.2021.
//

import UIKit

protocol Coordinator{
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] {get set}
    
    func start()
}
