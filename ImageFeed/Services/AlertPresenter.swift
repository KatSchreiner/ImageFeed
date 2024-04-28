//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 25.04.2024.
//

import Foundation
import UIKit

class AlertPresenter {
    static func showAlertError(
        in viewController: UIViewController,
        title: String,
        message: String) {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "Oк",
                style: .default,
                handler: nil))
            
            viewController.present(alert, animated: true, completion: nil)
        }
}
