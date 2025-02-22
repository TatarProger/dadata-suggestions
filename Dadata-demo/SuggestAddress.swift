//
//  Suggest.swift
//  Dadata-demo
//
//  Created by Rishat Zakirov on 19.02.2025.
//

import Foundation

struct SuggestAddress: Codable {
    var value, unrestrictedValue: String
    
    enum CodingKeys: String, CodingKey {
        case value
        case unrestrictedValue = "unrestricted_value"
    }
}

struct SuggestAddressResponse: Codable {
    let suggestions: [SuggestAddress]
}
