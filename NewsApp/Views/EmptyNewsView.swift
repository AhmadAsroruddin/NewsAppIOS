//
//  EmptyView.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import SwiftUI

struct EmptyNewsView: View {
    let text: String
    
    var body: some View {
        VStack{
            Text("no articles")
                .font(.title)
                
        }
    }
}

struct EmptyNewsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyNewsView(text: "No Articles")
    }
}
