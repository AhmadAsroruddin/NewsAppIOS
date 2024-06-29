//
//  ArticleView.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import SwiftUI

struct ArticleView: View {
    let article: Article
    var body: some View {
        VStack(alignment: .leading, spacing: 16){
            AsyncImage(url: article.imageUrl){
                phase in switch phase{
                case .empty:
                    HStack{
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    HStack{
                        Spacer()
                        Image(systemName: "photo")
                            .imageScale(.large )
                        Spacer()
                    }
                @unknown default:
                    fatalError()
                }
            }
            .frame(minWidth: 200, minHeight: 300, maxHeight: 300)
            .background(Color.gray.opacity(0.5))
            .clipped()
            
            VStack(alignment: .leading, spacing: 10){
                Text(article.title)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(3 )
                
                HStack{
                    Spacer()
                    Text(article.captionText)
                        .foregroundColor(.secondary)
                        .font(.caption)
                   
                }
                .padding(.top,5)
            }
            .padding([.horizontal, .bottom])
            
        }
    }
}
  
struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            ArticleView(article: .previewData[0])
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .listStyle(.plain)
    }
    
}
