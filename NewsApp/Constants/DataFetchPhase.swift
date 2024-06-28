//
//  DataFetchPhase.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 28/06/24.
//

import Foundation

enum DataFetchPhase<T>{
    case empty
    case success(T)
    case nextPage(T)
    case error(Error)
    
    var value: T?{
        if case .success(let value) = self{
            return value
        } else if case .nextPage(let value) = self {
            return value
        } else {
            return nil
        }
    }
}
