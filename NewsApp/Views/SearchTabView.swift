//
//  SearchTabView.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 28/06/24.
//

import SwiftUI

struct SearchTabView: View {
    @StateObject var articlePresenter = ArticlePresenter()
    
    var body: some View {
        NavigationStack{
            ArticleListView(articles:articles)
                .overlay(overlayView)
                .navigationTitle("Search")
        }
        .searchable(text: $articlePresenter.searchQuery)
        .onSubmit(of: .search,search)
    }
    
    private var articles: [Article]{
        if case let .success(articles) = articlePresenter.phase{
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View{
        switch articlePresenter.phase{
        case .empty:
            if !articlePresenter.searchQuery.isEmpty{
                ProgressView()
            } else {
                EmptyNewsView(text: "What are you looking for?")
            }
        case .success(let articles) where articles.isEmpty:
            EmptyNewsView(text: "No Article Found")
        case .error(let error):
            RetryView(text: "\(error), Please Try Again"){
                search()
            }
        default: EmptyNewsView(text: "Nothing")
        }
    }
    
    private func search(){
        Task{
            await articlePresenter.searchArticle()
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTabView()
    }
}
