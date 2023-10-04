import Foundation
import WebKit


public class VatomWallet: WKWebView, WKNavigationDelegate,WKUIDelegate {
    var businessId: String?
    var accessToken: String?
    var locationHandler: WKScriptMessageHandler?
    var contentController: WKUserContentController?
    var webConfig:WKWebViewConfiguration?
    var view: UIView?
    

    public init(businessId:String = "", accessToken:String, view:UIView ){
        self.webConfig = WKWebViewConfiguration()
        self.contentController = WKUserContentController()
        webConfig?.userContentController = contentController!
        webConfig?.preferences.javaScriptCanOpenWindowsAutomatically = true
        self.businessId = businessId
        self.accessToken = accessToken
        self.view = view
        super.init(frame:view.bounds, configuration: webConfig!)
        super.navigationDelegate = self
        super.uiDelegate = self
//        TODO: add code to inject accessToken and refreshToken
        let scriptSource = """
        sessionStorage.setItem('isIosEmbedded','true');
        localStorage.setItem("access_token","\(accessToken)");
        """
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController?.addUserScript(script)
        
    }
    
    required init?(coder:NSCoder){
        super.init(coder:coder)
    }
    
    @discardableResult
        public func load() -> WKNavigation? {
            self.locationHandler = VatomLocationHandler(userContentController: contentController, webView: self)
            contentController?.add(locationHandler!, name: "vatomLocationHandler")
            var url: String = "https://wow.vatom.com"
            if(self.businessId != ""){
                url = url + "/b/" + businessId!
            }
            if let url = URL(string:url) {
                let req = URLRequest(url: url)
                return super.load(req)
            }
            return nil
        }
    
    //public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //return webView
    //}
    
    
}




