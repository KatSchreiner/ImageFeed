//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 16.03.2024.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    // MARK: Private properties
    private var fullImageUrl: String?
    
    // MARK: - IB Outlets
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        loadImage()
        
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: IB Actions
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func tapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Public Methods
    
    func imageToURL(fullImageUrl: String) {
        self.fullImageUrl = fullImageUrl
    }
    
    // MARK: Private Methods
    
    private func loadImage() {
        guard let fullImageUrl = fullImageUrl, let url = URL(string: fullImageUrl) else {
            print("[SingleImageViewController: loadImage] - изображение не загрузилось")
            showError()
            return
        }
        
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                let image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: image)
            case .failure(_):
                if let placeholder = UIImage(named: "placeholder") {
                    self.imageView.image = placeholder
                    self.rescaleAndCenterImageInScrollView(image: placeholder)
                }
                self.showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        guard let scrollViewSize = scrollView?.bounds.size else { return }
        let imageSize = image.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let scale = max(widthScale, heightScale)
        let scaledImageSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
        
        let horizontalInset = max(0, (scrollViewSize.width - scaledImageSize.width) * 0.5)
        let verticalInset = max(0, (scrollViewSize.height - scaledImageSize.height) * 0.5)
        
        imageView.frame = CGRect(x: horizontalInset, y: verticalInset, width: scaledImageSize.width, height: scaledImageSize.height)
        
        scrollView.contentSize = scaledImageSize
    }
    
    private func showError() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Что-то пошло не так. Попробовать ещё раз?",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Нет",
            style: .default,
            handler: nil))
        alert.addAction(UIAlertAction(
            title: "Да",
            style: .default,
            handler: { _ in
                self.loadImage()
            }))
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale < 1.0 {
            scrollView.setZoomScale(1.0, animated: true)
        } else {
            let horizontalInset = max(0, (scrollView.bounds.width - imageView.frame.width) * 0.5)
            let verticalInset = max(0, (scrollView.bounds.height - imageView.frame.height) * 0.5)
            
            scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
    }
}
