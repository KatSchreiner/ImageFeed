//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 16.03.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return } // 1
            singleImage.image = image // 2
        }
    }
    
    @IBOutlet weak var singleImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImage.image = image
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
