//
//  GeneralResponse.swift
//  SuperHero
//
//  Created by Andrei on 14.02.23.
//

import Foundation

class GeneralResponse: Codable {
    let response: String?
    let id: String?
    let name: String?
    
    enum CodingKeys: CodingKey {
        case response
        case id
        case name
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decodeIfPresent(String.self, forKey: .response)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        
    }
}
