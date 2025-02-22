//
//  AddressService.swift
//  Dadata-demo
//
//  Created by Rishat Zakirov on 05.02.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidBody
    case invalidDecode
}

protocol IAddressService {
    func loadSuggestions(query: String, completion: @escaping ((Result<[SuggestAddress], Error>) -> Void))
}
class AddressService: IAddressService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func loadSuggestions(query: String, completion: @escaping ((Result<[SuggestAddress], Error>) -> Void)) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "suggestions.dadata.ru"
        urlComponents.path = "/suggestions/api/4_1/rs/suggest/address"
    
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidUrl))
            return
        }
        let token = "d0f61311a2351aef2a20e94b703826426696d945"
        let secret = "dee06aef6482e537851b48668d602d100cbe895a"
        let query = "\(query)"
    
        var request = URLRequest.init(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Content-type" : "application/json", "Authorization" : "Token " + token, "X-Secret": secret]
        
        do {
            let bodyParams: [String: String] = ["query" : query]
            let bodyData = try JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
    
            request.httpBody = bodyData
        } catch {
            print(error)
            completion(.failure(NetworkError.invalidBody))
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data else {return}
            do {
                let addressData = try self.decoder.decode(SuggestAddressResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(addressData.suggestions))
                }
            } catch {
                print(error)
                completion(.failure(NetworkError.invalidDecode))
            }
            
        }
        task.resume()
    }
}
