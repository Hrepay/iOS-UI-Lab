//
//  Lab11ViewController.swift
//  UI_Lab
//
//  Created by 황상환 on 11/9/25.
//

import UIKit

class Lab11ViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        // Home Tab
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // New Tab
        let newVC = NewViewController()
        let newNav = UINavigationController(rootViewController: newVC)
        newNav.tabBarItem = UITabBarItem(
            title: "New",
            image: UIImage(systemName: "square.grid.2x2"),
            selectedImage: UIImage(systemName: "square.grid.2x2.fill")
        )
        
        // Radio Tab
        let radioVC = RadioViewController()
        let radioNav = UINavigationController(rootViewController: radioVC)
        radioNav.tabBarItem = UITabBarItem(
            title: "Radio",
            image: UIImage(systemName: "dot.radiowaves.left.and.right"),
            selectedImage: UIImage(systemName: "dot.radiowaves.left.and.right")
        )
        
        // Set view controllers
        viewControllers = [homeNav, newNav, radioNav]
    }
}

// MARK: - Tab ViewControllers
class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        view.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        
        let label = UILabel()
        label.text = "Home Tab"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

class NewViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New"
        view.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
        
        let label = UILabel()
        label.text = "New Tab"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

class RadioViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Radio"
        view.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
        
        let label = UILabel()
        label.text = "Radio Tab"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
