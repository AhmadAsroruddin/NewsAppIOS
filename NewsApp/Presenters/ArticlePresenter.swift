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
}

protocol ArticlePresenterProtocol{
    func loadArticle() async
    func searchArticle() async
}

@MainActor
class ArticlePresenter: ArticlePresenterProtocol, ObservableObject{
    
    @Published var phase = DataPhase<[Article]>.empty
    @Published var selectedCategory: Category
    @Published var searchQuery = ""
    private let articleInteractor = ArticleInteraction.shared
    
    init(articles: [Article]?=nil, selectedCategory: Category = .general){
        if let articles = articles{
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.selectedCategory = selectedCategory
    }
    
    func loadArticle()async{
        phase = .empty
        do{
            let articles = try await articleInteractor.fetchNews(from: selectedCategory)
            phase = .success(articles)
        } catch{
            phase = .error(error)
        }
        
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
