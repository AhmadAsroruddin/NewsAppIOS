//
//  NewsAppApp.swift
//  NewsApp
//
//  Created by Ahmad Asroruddin on 27/06/24.
//

import SwiftUI

@main
struct NewsAppApp: App {
    @StateObject var router = AppRouterImplementation(window: UIWindow())


    var body: some Scene {
        WindowGroup {
            ContentView()
           .environmentObject(router)
           .onAppear {
               router.start()
           }
        }
        
    }
}
