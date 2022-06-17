//
//  WebView.swift
//  Examen Tecnico
//
//  Created by Alejandro Villordo on 17/06/22.
//

import Foundation
import WebKit
import SwiftUI

struct WebView:UIViewRepresentable{
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request  = URLRequest(url:url)
        
        webView.load(request)
    }
}
