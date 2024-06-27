//
//  Article.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Article:Codable{
    let source:Source
    
    let title:String
    let url:String
    let publishedAt:Date
    
    let author:String?
    let description:String?
    let urlToImage:String?
    
    var authorText:String{
        author ?? ""
    }
    
    var descriptionText:String{
        description ?? ""
    }
    
    var imageUrl: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        
        return URL(string: urlToImage)
    }
}

extension Article:Identifiable{
    var id: String{url}
}
extension Article:Equatable{}

extension Article{
    var captionText : String{
        "\(source.name). \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
}

extension Article {
    static var previewData:[Article]{
        let previewDataUrl = Bundle.main.url(forResource: "newsdata", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataUrl)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let response = try! jsonDecoder.decode(NewsResponse.self, from: data)
        return response.articles ?? []
    }
}

struct Source{
    let name:String
}

extension Source:Codable{
    
}

extension Source:Equatable{}
