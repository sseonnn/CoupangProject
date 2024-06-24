//
//  PaymentViewController.swift
//  Cproject
//
//  Created by 이정선 on 6/23/24.
//

import UIKit
import WebKit

final class PaymentViewController: UIViewController {
    private var webView: WKWebView?
    private let getMessageSciptName: String = "receiveMessage"
    private let getPaymentCompleteSciptName: String = "paymentComplete"

    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name: getMessageSciptName)
        contentController.add(self, name: getPaymentCompleteSciptName)
    
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: config)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView()
        setUserAgent()
        
        let button: UIButton = UIButton(frame: CGRect(x: 0, y: 400, width: 100, height: 100))
        button.setTitle("call javascript", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.callJavaScript()
        }), for: .touchUpInside)
        
        view.addSubview(button)
    }
    
    private func loadWebView() {
        guard let path = Bundle.main.path(forResource: "test", ofType: "html") else {return}
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        
        webView?.load(request)
    }
    
    private func setUserAgent() {
        webView?.customUserAgent = "Cproject/1.0.0/iOS"
    }
    
    private func callJavaScript() {
        webView?.evaluateJavaScript("javascriptFunction();")
    }
}

extension PaymentViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == getMessageSciptName {
            print("\(message.body)")
        } else if message.name == getPaymentCompleteSciptName {
            print("\(message.body)")
        }
    }
    
    
}

#Preview {
    PaymentViewController()
}
