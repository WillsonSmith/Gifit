//
//  DragWebView.swift
//  SwiftServe
//
//  Created by Willson Smith on 2015-11-24.
//
//

import WebKit

class DragWebView : WKWebView {
    
    func dropOccured(url: String) -> String {
        executeJavascript("dragEvent", arguments: ["'\(url)'"]);
        return url;
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy;
    }
    
    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy;
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        
        // sends message to JS to get valuse needed for ffmpeg
        // JS responds with values & calls ffmpeg
        
        let pboardItem = sender.draggingPasteboard();
        let url: Array<String> = pboardItem.propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType")) as! Array<String>;
        
        _ = dropOccured(url: url.first!);
        
        return false;
    }
    
    func executeJavascript(_ functionToRun:String, arguments:Array<String>?) {
        var function:String;
        var args:String;
        
        if (arguments != nil) {
            args = arguments!.joined(separator: ", ");
        } else {
            args = "";
        }
        
        function = "\(functionToRun)(\(args))";
        self.evaluateJavaScript(function, completionHandler: handleJavascriptCompletion as? (Any?, Error?) -> Void);
    }
    
    func handleJavascriptCompletion(_ object:AnyObject?, error:NSError?) -> Void {
        if (error != nil) {
            printView(error as Any);
        }
    }
    
}
