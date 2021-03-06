//
//  ViewController.swift
//  Swift web hybrid template
//
//  Created by Willson Smith on 2015-11-09.
//
//

import Cocoa
import WebKit

class ViewController: NSViewController, WKScriptMessageHandler {

//    var webView: WKWebView?
    @IBOutlet weak var webView: DragWebView!

    override func loadView() {
        super .loadView();
        let contentController = WKUserContentController();
        contentController.add(self, name: "callbackHandler");

        let config = WKWebViewConfiguration();
        config.userContentController = contentController;

        webView = DragWebView(frame: self.view.frame, configuration: config);
        webView.uiDelegate = self as? WKUIDelegate;
        view = webView;
    }

    override func viewDidLoad() {
        super.viewDidLoad();

        // enable developer tools in webview
        self.webView?.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")


        // static files for build
//        let url = Bundle.main.url(forResource: "index", withExtension:"html", subdirectory: "react-swift-webview/build");
//        self.webView!.loadFileURL(url!, allowingReadAccessTo: url!);

        // localhost for dev
        let url = NSURL(string: "http://localhost:3000")! as URL;
        self.webView.load(URLRequest(url: url));
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let messageBody:NSDictionary = message.body as? NSDictionary {
            let functionToRun = String(describing: messageBody.value(forKey: "functionToRun")!);
            let promiseId = String(describing: messageBody.value(forKey: "promiseId" )!);

            switch(functionToRun) {
            case "getCurrentVersion":
                getCurrentVersion(promiseId: promiseId);
            case "beginConversion":
                let uri = String(describing: messageBody.value(forKey: "uri")!);
                let fps = String(describing: messageBody.value(forKey: "fps")!);
                let scale = String(describing: messageBody.value(forKey: "scale")!);
                var result = "s";
                
                DispatchQueue.global(qos: .background).async {
                    result = runffmpeg(uri, fps: fps, scale: scale);
                    DispatchQueue.main.async {
//                        This is run on the main queue, after the previous code in outer block
                        self.webView!.executeJavascript("resolvePromise", arguments:[promiseId, "'\(result)'"]);
                    }
                }
                
                
            default:
                return {}();
            }
        }
    }

    func currentVersion() -> String {
        return "'0.0.1'";
    }
    
    func getCurrentVersion(promiseId: String) {
        self.webView!.executeJavascript("resolvePromise", arguments:[promiseId, currentVersion()])
    }

    func handleJavascriptCompletion(_ object:AnyObject?, error:NSError?) -> Void {
        if (error != nil) {
            print(error as Any);
        }
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning();
//        // Dispose of any resources that can be recreated.
//    }

}
