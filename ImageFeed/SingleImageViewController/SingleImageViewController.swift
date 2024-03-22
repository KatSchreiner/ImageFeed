//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 16.03.2024.
//

import UIKit

final class SingleImageViewController: UIViewController, UIScrollViewDelegate {
    var image: UIImage? {
        didSet {
            guard let image, isViewLoaded else { return }
            singleImage.image = image
            singleImage.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var singleImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else { return }
        singleImage.image = image
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
    let shareController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareController, animated: true, completion: nil)
    }
    @IBAction func tapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        scrollView.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let scrollViewSize = scrollView.contentSize
        
        let widthScale = imageSize.width / visibleRectSize.width
        let heightScale = imageSize.height / visibleRectSize.height
        
        let minScale = min(widthScale, heightScale)
        let scale = min(maxZoomScale, max(minZoomScale, minScale))
        
        self.scrollView.setZoomScale(scale, animated: false)
        
        scrollView.layoutIfNeeded()
        let x = (visibleRectSize.width - scrollViewSize.width) / 2
        let y = (visibleRectSize.height - scrollViewSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)

    }
}

extension SingleImageViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
        }
}
