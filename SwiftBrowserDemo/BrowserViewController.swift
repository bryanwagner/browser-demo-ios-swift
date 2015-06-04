//
//  ViewController.swift
//  SwiftBrowserDemo
//
//  Created by Bryan Wagner on 6/4/15.
//  Copyright (c) 2015 Bryan Wagner. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController, UIWebViewDelegate, UITextFieldDelegate {

    let BROWSER_REFRESH_TEXT = "R"
    let BROWSER_STOP_TEXT    = "X"

    var loading : Bool = false

    @IBOutlet weak var webView:       UIWebView!
    @IBOutlet weak var urlTextField:  UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var backButton:    UIButton!
    @IBOutlet weak var forwardButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loading                   = false
        self.urlTextField.keyboardType = UIKeyboardType.WebSearch
        self.urlTextField.becomeFirstResponder()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    // internal methods
    func updateUI() {
        backButton.enabled    = webView.canGoBack
        forwardButton.enabled = webView.canGoForward
        refreshButton.setTitle(loading ? BROWSER_STOP_TEXT : BROWSER_REFRESH_TEXT, forState: UIControlState.Normal)
    }

    func navigateTo(var urlString: String) {
        let words = urlString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        urlString = "".join(words)
        if urlString.rangeOfString("http", options: NSStringCompareOptions.CaseInsensitiveSearch)? == nil {
            urlString = "http://" + urlString
        }
        let url           = NSURL(string: urlString)
        let urlRequest    = NSURLRequest(URL: url!)
        webView.loadRequest(urlRequest)
        urlTextField.text = urlString
        urlTextField.resignFirstResponder()
        updateUI()
    }

    func navigateToUrlTextField() {
        navigateTo(urlTextField.text)
    }

    func navigateReload() {
        webView.reload()
        urlTextField.resignFirstResponder()
        updateUI()
    }

    func navigateStop() {
        webView.stopLoading()
        loading = false
        urlTextField.resignFirstResponder()
        updateUI()
    }

    func navigateBack() {
        webView.goBack()
        urlTextField.resignFirstResponder()
        updateUI()
    }

    func navigateForward() {
        webView.goForward()
        urlTextField.resignFirstResponder()
        updateUI()
    }

    // UI action methods
    @IBAction func onReloadButton(sender: AnyObject) {
        if loading {
            navigateStop()
        }
        else {
            navigateReload()
        }
    }

    @IBAction func onBackButton(sender: AnyObject) {
        navigateBack()
    }

    @IBAction func onForwardButton(sender: AnyObject) {
        navigateForward()
    }

    // UIWebViewDelegate methods
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }

    func webViewDidStartLoad(webView: UIWebView) {
        loading = true
        updateUI()
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        loading = false
        if let urlString = webView.request?.URL.absoluteString? {
            if !urlString.isEmpty {
                urlTextField.text = urlString
            }
        }
        updateUI()
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        updateUI()
        println("webView:didFailLoadWithError: \(error.description)")
    }

    // UITextFieldDelegate methods
    func textFieldDidEndEditing(textField: UITextField) {
        self.urlTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        navigateToUrlTextField()
        return true
    }
}

