//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import Foundation

struct NewsResponse : Decodable{
    let status : String
    let totalResult : Int?
    let articles : [Article]?
}
