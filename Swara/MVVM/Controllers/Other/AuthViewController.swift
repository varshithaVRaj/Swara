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
    
        webView.load(URLRequest(url: url))
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("view.bounds: \(view.bounds)") // Debugging
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        guard let url = webView.url else {
            return
        }
       
        
        let component = URLComponents(string: url.absoluteString)
        guard let code = component?.queryItems?.first(where: { $0.name == "code" })?.value else {return}
        print("code: \(code)")
        webView.isHidden = true
        
        AuthManager.shared.exchangeCodeForToken(code: code) { [weak self] result in
            
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
            
            self?.completionHandler?(result)
            
        }
       
    }


}
