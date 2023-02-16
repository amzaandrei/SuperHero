//
//  SuperHeroModel.swift
//  SuperHero
//
//  Created by Andrei on 14.02.23.
//

import Foundation

enum ResponseStatus: String, Codable {
    case success = "success"
    case failure = "failure"
}

class SearchByName: Codable {
    let response: String
    let resultsFor: String
    let results: [SuperHeroGeneral]
    
    enum CodingKeys: String, CodingKey {
        case response
        case resultsFor = "results-for"
        case results
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.response = try container.decode(String.self, forKey: .response)
        self.resultsFor = try container.decode(String.self, forKey: .resultsFor)
        self.results = try container.decode([SuperHeroGeneral].self, forKey: .results)
    }
    
}

class SuperHeroGeneral: GeneralResponse {
    var powerstats: Powerstats
    var biography: Biography
    var appearance: Appearance
    var work: Work
    var connections: Connections
    var image: Image

    enum CodingKeys: CodingKey {
        case response
        case id
        case name
        case powerstats
        case biography
        case appearance
        case work
        case connections
        case image
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.powerstats = try container.decode(Powerstats.self, forKey: .powerstats)
        self.biography = try container.decode(Biography.self, forKey: .biography)
        self.appearance = try container.decode(Appearance.self, forKey: .appearance)
        self.work = try container.decode(Work.self, forKey: .work)
        self.connections = try container.decode(Connections.self, forKey: .connections)
        self.image = try container.decode(Image.self, forKey: .image)
        try super.init(from: decoder)
    }
}

class Powerstats: GeneralResponse {
    let intelligence: String
    let strength: String
    let speed: String
    let durability: String
    let power: String
    let combat: String
    
    enum CodingKeys: String, CodingKey {
        case intelligence
        case strength
        case speed
        case durability
        case power
        case combat
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.intelligence = try container.decode(String.self, forKey: .intelligence)
        self.strength = try container.decode(String.self, forKey: .strength)
        self.speed = try container.decode(String.self, forKey: .speed)
        self.durability = try container.decode(String.self, forKey: .durability)
        self.power = try container.decode(String.self, forKey: .power)
        self.combat = try container.decode(String.self, forKey: .combat)
        try super.init(from: decoder)
    }
}

class Biography: GeneralResponse {
    let fullName: String
    let alterEgos: String
    let aliases: [String]
    let placeOfBirth: String
    let firstAppearance: String
    let publisher: String
    let alignment: String

    enum CodingKeys: String, CodingKey {
        case fullName = "full-name"
        case alterEgos = "alter-egos"
        case aliases
        case placeOfBirth = "place-of-birth"
        case firstAppearance = "first-appearance"
        case publisher
        case alignment
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fullName = try container.decode(String.self, forKey: .fullName)
        self.alterEgos = try container.decode(String.self, forKey: .alterEgos)
        self.aliases = try container.decode([String].self, forKey: .aliases)
        self.placeOfBirth = try container.decode(String.self, forKey: .placeOfBirth)
        self.firstAppearance = try container.decode(String.self, forKey: .firstAppearance)
        self.publisher = try container.decode(String.self, forKey: .publisher)
        self.alignment = try container.decode(String.self, forKey: .alignment)
        try super.init(from: decoder)
    }
}

class Appearance: GeneralResponse {
    let gender: String
    let race: String
    let height: [String]
    let weight: [String]
    let eyeColor: String
    let hairColor: String

    enum CodingKeys: String, CodingKey {
        case gender
        case race
        case height
        case weight
        case eyeColor = "eye-color"
        case hairColor = "hair-color"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.race = try container.decode(String.self, forKey: .race)
        self.height = try container.decode([String].self, forKey: .height)
        self.weight = try container.decode([String].self, forKey: .weight)
        self.eyeColor = try container.decode(String.self, forKey: .eyeColor)
        self.hairColor = try container.decode(String.self, forKey: .hairColor)
        try super.init(from: decoder)
    }
}

class Work: GeneralResponse {
    let occupation: String
    let base: String
    
    enum CodingKeys: String, CodingKey {
        case occupation
        case base
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.occupation = try container.decode(String.self, forKey: .occupation)
        self.base = try container.decode(String.self, forKey: .base)
        try super.init(from: decoder)
    }
}

class Connections: GeneralResponse {
    let groupAffiliation: String
    let relatives: String

    enum CodingKeys: String, CodingKey {
        case groupAffiliation = "group-affiliation"
        case relatives
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupAffiliation = try container.decode(String.self, forKey: .groupAffiliation)
        self.relatives = try container.decode(String.self, forKey: .relatives)
        try super.init(from: decoder)
    }
}

class Image: GeneralResponse {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        try super.init(from: decoder)
    }
    
}

