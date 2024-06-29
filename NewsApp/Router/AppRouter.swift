import UIKit
import SwiftUI
protocol AppRouter {
    func start()
    // tambahkan fungsi navigasi lainnya sesuai kebutuhan
}

class AppRouterImplementation: AppRouter, ObservableObject {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    @MainActor
    func start() {
        // Initialize your main view here
        let presenter = ArticlePresenter()
        let mainView = ArticleTabView(articlePresenter: presenter)
        
        // Setup the root view controller
        let rootViewController = UIHostingController(rootView: mainView)
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
