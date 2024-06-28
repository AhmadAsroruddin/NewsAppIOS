//
//  Category.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import Foundation

enum Category: String, CaseIterable{
    case general
    case technology
    case business
    case entertainment
    case sport
    case science
    case health
    
    var text: String{
        if self == .general{
            return "Top Headline"
        }
        return rawValue.capitalized
    }
}

extension Category: Identifiable{
    var id: Self{self}
}
