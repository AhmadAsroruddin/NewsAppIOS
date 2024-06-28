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
            ArticleListView(articles: articlePresenter.articles, isFetching: articlePresenter.isFetchingNextPage, nextPageHandler: {await articlePresenter.loadNextPage()})
                .overlay(overlayView)
                .refreshable {
                    Task{
                        await articlePresenter.loadFirstPage()
                    }
                }
                .onAppear{
                    Task{
                        await articlePresenter.loadFirstPage()
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
                        await articlePresenter.loadFirstPage()
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
            EmptyNewsView(text: "No")
        case .error(let error):
            RetryView(text: error.localizedDescription){
                Task{
                    await articlePresenter.loadFirstPage()
                }
            }
        default:
            EmptyView()
            
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
