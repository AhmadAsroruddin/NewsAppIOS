//
//  NewsPresenter.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import Foundation

enum DataPhase<T>{
    case empty
    case success(T)
    case error(Error)
    case fetchingNextPage(T)
    var value: T?{
        if case .success(let value) = self{
            return value
        } else if case .fetchingNextPage(let value) = self {
            return value
        } else {
            return nil
        }
    }
}

protocol ArticlePresenterProtocol{
    func loadFirstPage() async
    func searchArticle() async
}

@MainActor
class ArticlePresenter: ArticlePresenterProtocol, ObservableObject{
    
    @Published var phase = DataPhase<[Article]>.empty
    @Published var selectedCategory: Category
    @Published var searchQuery = ""
    private let articleInteractor = ArticleInteraction.shared
    private let pagingData = PagingModel(itemsPerPage: 5, maxPageLimit: 500)
    
    var articles:[Article]{
        return phase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        
        return false
    }
    
    init(articles: [Article]?=nil, selectedCategory: Category = .general){
        if let articles = articles{
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.selectedCategory = selectedCategory
    }
    
    func loadFirstPage()async{
        phase = .empty
        do{
            await pagingData.reset()
            
            let articles = try await pagingData.loadNextPage(dataFetchProvider: loadArticle(page:))
            if Task.isCancelled{return}
            phase = .success(articles)
        } catch{
            phase = .error(error)
        }
        
    }
    
    func loadNextPage()async{
        if Task.isCancelled {return}
        
        let articles = self.phase.value ?? []
        phase = .fetchingNextPage(articles)
        
        do{
            let nextArticle = try await pagingData.loadNextPage(dataFetchProvider: loadArticle(page:))
            phase = .success(articles + nextArticle)
        } catch {
            phase = .error(error)
        }
    }
    
    private func loadArticle(page: Int) async throws -> [Article]{
        let articles = try await articleInteractor.fetchNews(
            from: selectedCategory, pageSize: pagingData.itemsPerPage, page: page)
        
        return articles
    }
    
    func searchArticle()async{
        let searchQuery = self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        phase = .empty
        
        if searchQuery.isEmpty{
            return
        }
        
        do{
            let articles = try await articleInteractor.fetchNews(query: searchQuery)
            phase = .success(articles)
        } catch{
            phase = .error(error)
        }
    }
}
