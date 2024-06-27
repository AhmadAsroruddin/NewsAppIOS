//
//  ArticleListView.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import SwiftUI

struct ArticleListView: View {
    let articles:[Article]
    var body: some View {
        List{
            ForEach(articles) { article in
                ArticleView(article: article)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView(articles:Article.previewData)
    }
}
