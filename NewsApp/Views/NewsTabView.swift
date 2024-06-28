//
//  TabView.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import SwiftUI

struct ArticleTabView: View {
    @StateObject var articlePresenter = ArticlePresenter()
    
    var body: some View {
        NavigationStack{
            ArticleListView(articles: articles)
                .overlay(overlayView)
                .refreshable {
                    Task{
                        await articlePresenter.loadArticle()
                    }
                }
                .onAppear{
                    Task{
                        await articlePresenter.loadArticle()
                    }
                }
            
                .navigationTitle(articlePresenter.selectedCategory.text)
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        menu
                    }
                }
                .onChange(of: articlePresenter.selectedCategory){_ in
                    Task{
                        await articlePresenter.loadArticle()
                    }
                }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View{
        switch articlePresenter.phase{
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyNewsView(text: "No Articles")
        case .error(let error):
            RetryView(text: error.localizedDescription){
                Task{
                    await articlePresenter.loadArticle()
                }
            }
        default:
            EmptyView()
            
        }
    }
    
    private var articles: [Article]{
        if case let .success(articles) = articlePresenter.phase{
            return articles
        } else {
            return []
        }
    }
    
    
    private var menu: some View{
        Menu{
            Picker("Category", selection: $articlePresenter.selectedCategory){
                ForEach(Category.allCases){
                    Text($0.text).tag($0)
                }
            }
        }label: {
            Image(systemName: "fiberchannel")
                .imageScale(.large)
        }
    }
}

struct ArticleTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleTabView()
    }
}
