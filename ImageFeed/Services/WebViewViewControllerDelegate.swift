//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 01.04.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
} 
