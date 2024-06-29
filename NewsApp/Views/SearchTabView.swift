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
            ArticleListView(articles: articles)
                .overlay{
                    Group {
                        if shouldShowOverlay {
                            overlayView
                        }
                    }
                }
                .navigationTitle("Search")
        }
        .searchable(text: $articlePresenter.searchQuery)
        .onSubmit(of:.search, search)
        .onChange(of: articlePresenter.searchQuery){ newValue in
            if newValue.isEmpty{
                articlePresenter.phase = .empty
            }else{
                search()
            }
        }
    }
    private var shouldShowOverlay: Bool {
            switch articlePresenter.phase {
            case .empty, .error:
                return true
            case .success(let articles):
                return articles.isEmpty
            
            case .fetchingNextPage(_):
                return false
            }
        }
    private var articles: [Article]{
        if case .success(let articles) = articlePresenter.phase{
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var suggestionView: some View{
        ForEach(["Real Madrid", "F1"], id: \.self){ text in
            Button{
                articlePresenter.searchQuery = text
                search()
            } label: {
                Text(text)
            }
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
