//
//  AuthViewController.swift
//  Swara
//
//  Created by Varshitha VRaj on 23/06/25.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private var webView: WKWebView!
    
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let prefs = WKWebpagePreferences()
            prefs.allowsContentJavaScript = true
            
        let config = WKWebViewConfiguration()
            config.defaultWebpagePreferences = prefs
            
        webView = WKWebView(frame: .zero, configuration: config)
            
        webView.navigationDelegate = self
        view.addSubview(webView)
       
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else {
            return
        }
        
        print("url to load is \(url)")
        webView.load(URLRequest(url: url))
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("view.bounds: \(view.bounds)") // Debugging
        webView.frame = view.bounds
    }


}
