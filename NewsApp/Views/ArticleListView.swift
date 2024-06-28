//
//  ArticleListView.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import SwiftUI

struct ArticleListView: View {
    let articles:[Article]
    @State private var selectedArticle: Article?
    let webViewPresenter = WebViewPresenter()
    var isFetching = false
    var nextPageHandler: (() async -> ())? = nil
    
    var body: some View {
        List{
            ForEach(articles) { article in
                
                if let nextPageHandler = nextPageHandler, article == articles.last{
                    ArticleView(article: article)
                        .onTapGesture {
                            selectedArticle = article
                        }
                        .task {
                            await nextPageHandler()
                        }
                    if isFetching{
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                } else{
                    ArticleView(article: article)
                        .onTapGesture {
                            selectedArticle = article
                        }
                }
                
               
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectedArticle){article in
            webViewPresenter.presentWebView(url: article.articleUrl)
        }
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(articles:Article.previewData)
    }
}
