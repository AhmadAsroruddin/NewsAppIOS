//
//  PagingModel.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 28/06/24.
//

import Foundation

actor PagingModel{
    private(set) var currentPage = 0
    private(set) var hasReachedTheBottom = false
    
    let itemsPerPage: Int
    let maxPageLimit: Int
    
    init(itemsPerPage: Int, maxPageLimit:Int){
        assert(itemsPerPage > 0 && maxPageLimit > 0, "Minimum Article per Page can't be below than 1")
        
        self.itemsPerPage = itemsPerPage
        self.maxPageLimit = maxPageLimit
    }
    
    var nextPage: Int {currentPage + 1}
    var shoudLoadNextPage: Bool{
        !hasReachedTheBottom && nextPage <= maxPageLimit
    }
        
    func reset(){
        currentPage = 0
        hasReachedTheBottom = false
    }
    
    func loadNextPage<T>(dataFetchProvider: @escaping(Int) async throws ->[T]) async throws -> [T]{
        if Task.isCancelled {return []}
        
        guard shoudLoadNextPage else {return []}
        
        let nextPage = self.nextPage
        let data = try await dataFetchProvider(nextPage)
        
        if Task.isCancelled || nextPage != self.nextPage{
            return []
        }
        
        currentPage = nextPage
        hasReachedTheBottom = data.count < itemsPerPage
        
        return data
    }
}
