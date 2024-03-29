//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 15.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let userPhoto: UIImageView = {
        let imageProfile = UIImage(named: "Photo")
        let userPhoto = UIImageView(image: imageProfile)
        return userPhoto
    }()
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()
    private let loginLabel: UILabel = {
        let loginLabel = UILabel()
        return loginLabel
    }()
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        return descriptionLabel
    }()
    private let logoutButton: UIButton = {
        let logoutButton = UIButton(type: .system)
        return logoutButton
    }()
    
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        let profileViews: [UIView] = [userPhoto, nameLabel, loginLabel, descriptionLabel, logoutButton]
        profileViews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
        setupUserPhoto()
        setupNameProfile()
        setupLoginProfile()
        setupDescriptionProfile()
        setupLogoutButton()
    }
    
    // MARK: - IB Actions
    @objc
    private func didTapLogoutButton() {
        
    }
    
    // MARK: - Private Methods
    private func setupUserPhoto() {
        NSLayoutConstraint.activate([
            userPhoto.widthAnchor.constraint(equalToConstant: 70),
            userPhoto.heightAnchor.constraint(equalToConstant: 70),
            userPhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            userPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
    }
    
    private func setupNameProfile() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupLoginProfile() {
        loginLabel.text = "@ekaterina_nov"
        loginLabel.textColor = .ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13.0)
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
        ])
    }
    
    private func setupDescriptionProfile() {
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13.0)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor)
        ])
    }
    
    private func setupLogoutButton() {
        let image = UIImage(named: "Exit")
        logoutButton.setImage(image, for: .normal)
        logoutButton.addTarget(self, action: #selector(self.didTapLogoutButton), for: .touchUpInside)
        logoutButton.tintColor = .ypRed
        NSLayoutConstraint.activate([
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            logoutButton.centerYAnchor.constraint(equalTo: userPhoto.centerYAnchor)
        ])
    }
}
