//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 15.03.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private var userPhoto = UIImageView()
    private var nameLabel = UILabel()
    private var loginLabel = UILabel()
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
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
        let imageProfile = UIImage(named: "Photo")
        userPhoto = UIImageView(image: imageProfile)
        userPhoto.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userPhoto)
        userPhoto.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userPhoto.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userPhoto.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        userPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    }
    
    private func setupNameProfile() {
        nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23.0)
        nameLabel.leadingAnchor.constraint(equalTo: userPhoto.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: userPhoto.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupLoginProfile() {
        loginLabel = UILabel()
        loginLabel.text = "@ekaterina_nov"
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel)
        loginLabel.textColor = .ypGray
        loginLabel.font = UIFont.systemFont(ofSize: 13.0)
        loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
    }
    
    private func setupDescriptionProfile() {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13.0)
        descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginLabel.leadingAnchor).isActive = true
    }

    private func setupLogoutButton() {
        let logoutButton = UIButton(type: .system)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        let image = UIImage(named: "Exit")
        logoutButton.setImage(image, for: .normal)
        logoutButton.addTarget(self, action: #selector(self.didTapLogoutButton), for: .touchUpInside)
        logoutButton.tintColor = .ypRed
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: userPhoto.centerYAnchor).isActive = true
    }
}
