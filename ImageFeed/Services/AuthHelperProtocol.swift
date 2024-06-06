//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Екатерина Шрайнер on 17.05.2024.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
} 
