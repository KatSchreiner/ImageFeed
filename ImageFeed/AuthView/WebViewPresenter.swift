//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 17.05.2024.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var authHelper: AuthHelperProtocol
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    weak var view: WebViewControllerProtocol?
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else { 
            assertionFailure("[WebViewPresenter: viewDidLoad] - неверный запрос")
            return }
        
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    // MARK: - Public Mhetods
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}




