//
//  File.swift
//
//
//  Created by Sebastian Sanchez on 23/01/23.
//

import Foundation
import WebKit
import CoreLocation


public class VatomLocationHandler: NSObject, WKScriptMessageHandler, CLLocationManagerDelegate{
    var userContentController: WKUserContentController?
    var webView: WKWebView?
    var locationManager: CLLocationManager?
    
    public init(userContentController: WKUserContentController? = nil, webView:WKWebView? = nil) {
        super.init()
        self.userContentController = userContentController
        self.webView = webView
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
//        let initialScript = "window.sendBridgeMessage = function() {window.webkit.messageHandlers.vatomLocationHandler.postMessage('getCurrentPosition')};"
//        let script = WKUserScript(source: initialScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
//        userContentController?.addUserScript(script)
    }
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "vatomLocationHandler" {
            let messageBody = message.body as AnyObject
            locationManager?.requestWhenInUseAuthorization()
            var script:String?;
            switch messageBody["name"] as? String{
            case "getCurrentPosition":
                if(locationManager?.location != nil){
                    script = "window.postMessage({id:'\(messageBody["id"] as! String)',name:'locationManager:getCurrentPosition', payload:{coords:{latitude:\(locationManager?.location?.coordinate.latitude ?? 0) ,longitude:\(locationManager?.location?.coordinate.longitude ?? 0)}}})"
                    print(script!)
                    print(locationManager!.location!)
                }
                break;
            default:
                script = "console.warn('Action not configured for \(messageBody["name"] as! String)')"
                break;
            }
            if(script != nil){
                webView?.evaluateJavaScript(script!)
            }
                
        }
    }
}
