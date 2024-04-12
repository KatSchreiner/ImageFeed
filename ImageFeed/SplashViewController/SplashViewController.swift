//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 08.04.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    private let tokenStorage = OAuth2TokenStorage()
    private let showAuthScreenIdentifier = "showAuthenticationScreenSegue"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token {
            switchToBarController()
        } else {
            performSegue(withIdentifier: showAuthScreenIdentifier, sender: nil)
        }
    }
    
    private func switchToBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthScreenIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthScreenIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToBarController()
    }
}
