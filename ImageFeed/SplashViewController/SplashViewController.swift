//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 08.04.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties

    private let tokenStorage = OAuth2TokenStorage()
    
    private var splashLogo: UIImageView = {
        let imageLogo = UIImage(named: "logo_launchscreen")
        let splashLogo = UIImageView(image: imageLogo)
        return splashLogo
    }()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashLogo()
        self.view.backgroundColor = .ypBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = tokenStorage.token {
            fetchProfile(token)
        } else {
            goToAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Private Methods
    private func setupSplashLogo() {
        splashLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashLogo)
        NSLayoutConstraint.activate([
            splashLogo.widthAnchor.constraint(equalToConstant: 75),
            splashLogo.heightAnchor.constraint(equalToConstant: 78),
            splashLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func didTapLoginButton() {
        
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

// MARK: - SplashViewController: AuthViewControllerDelegate

extension SplashViewController {
    func goToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            fatalError("Unable to instantiate AuthViewController from storyboard")
        }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true, completion: nil)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        if let token = OAuth2Service.shared.oauthToken {
            fetchProfile(token)
        }
    }
    
    func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                if let username = ProfileService.shared.profile?.username {
                    ProfileImageService.shared.fetchProfileImage(username: username) { _ in }
                }
                switchToBarController()
            case .failure(let error):
                print(error.localizedDescription)
            }
            UIBlockingProgressHUD.dismiss()
        }

    }
}
