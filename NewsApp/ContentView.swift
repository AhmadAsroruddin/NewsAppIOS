//
//  ContentView.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       
            ArticleTabView()
                .tabItem{
                    Label("news", systemImage: "newspaper")
                }
           
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
