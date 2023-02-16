//
//  ErrorHandler.swift
//  SuperHero
//
//  Created by Andrei on 14.02.23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
    case otherError(String)
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .requestFailed:
            return "Request failed"
        case .otherError(let message):
            return message
        }
    }
}

