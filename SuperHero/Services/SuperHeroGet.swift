//
//  SuperHeroService.swift
//  SuperHero
//
//  Created by Andrei on 14.02.23.
//

import Foundation
import Alamofire

enum SuperHeroGetService: String {
    case ID = "id",
        POWERSTATS = "powerstats",
        BIOGRAPHY = "biography",
        APPERANCE = "apperance",
        WORK = "work",
        CONNECTIONS = "connections",
        IMAGE = "image"
}

class SuperHeroGet {
    
    static let sharedInstance = SuperHeroGet()
    
    func getUrlBasedOnRequest(id: String?, type: SuperHeroGetService?, name: String?) -> String{
        if let typeExist = type, let idExist = id {
            return SuperHeroBaseUrl.apiBaseUrl + "/\(idExist)" + "/\(typeExist.rawValue)"
        } else if let idExist = id {
            return SuperHeroBaseUrl.apiBaseUrl + "/\(idExist)"
        }
        guard let nameExist = name else { return "" }
        return SuperHeroBaseUrl.apiBaseUrl + "/search/" + nameExist
    }
    
    func fetchSuperHeroData<T: GeneralResponse>(withId id: String, modelType: T.Type, requestType: SuperHeroGetService?, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let url = getUrlBasedOnRequest(id: id, type: requestType, name: nil)
        
        AF.request(url).responseDecodable(of: modelType.self) { response in
            switch response.result {
            case .success(let superhero):
                completion(.success(superhero))
            case .failure(let error):
                completion(.failure(NetworkError.otherError("Something undetected got wrong: \(error)")))
            }
        }
    }
    
    func fetchHeroByName(name: String, completion: @escaping (Result<SearchByName, NetworkError>) -> Void) {
        let url = getUrlBasedOnRequest(id: nil, type: nil, name: name)
        
        AF.request(url).responseDecodable(of: SearchByName.self) { response in
            switch response.result {
            case .success(let superhero):
                completion(.success(superhero))
            case .failure(let error):
                completion(.failure(NetworkError.otherError("Something undetected got wrong: \(error)")))
            }
        }
    }
    
}

