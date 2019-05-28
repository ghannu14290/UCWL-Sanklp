//
//  RedeemPointsMemberVC.swift
//  JKL App
//
//  Created by New User on 9/29/17.
//  Copyright © 2017 Ramandeep Singh Bakshi. All rights reserved.
//

import UIKit
import MBProgressHUD

class RedeemPointsMemberVC: UIViewController, UIWebViewDelegate{

    var membermobileNumber = String()
    var memberguid = String()
    var membertype = String()
    var checkViewController: String! = "leftmenu"
    
    //WEBVIEW.
    let myWebView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Redeem Your Points"
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 238.0/255, green: 49.0/255, blue: 53.0/255, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        
        //BACKBUTTON ON NAVIGATION BAR.
        let backButn: UIButton = UIButton()
        backButn.setImage(UIImage(named: "ic_action_back (1)"), for: .normal)
        backButn.frame = CGRect(x: 0,y: 0,width: 30,height: 30)
        backButn.addTarget(self, action: #selector(back), for:.touchUpInside)
        backButn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20.0, bottom: 0, right: 13.0)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButn), animated: true)
        //CALL THE CREATE WEBVIEW FUNC TO DISPLAY THE WEBVIEW ON VIEW.
        self.createWebview()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func back()
    {
        if checkViewController == "leftmenu"
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.leftmenu()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }

    func createWebview()
    {
        var strings = String()
        self.view.addSubview(myWebView)
        myWebView.delegate = self
        
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                NSLog("\(cookie)")
            }
        }
        
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        self.showProgress()
        
        
        
        if membertype == "Retailer" || membertype == "Influencer"
        {
            strings = "http://ucwldemo.netcarrots.in/UCWLMobileApplication/default.aspx?guid=\(memberguid)&Mobileno=\(membermobileNumber)"
            print("webview when retailer and influencer redeem the points\(strings)")
        }
        else
        {
            //MOBILENUMBER IN USERDEFAULT.
            let number = UserDefaults.standard.object(forKey:"mobileNumber") as! String
            
            //GUID IN USERDEFAULT.
            let guid = UserDefaults.standard.object(forKey:"guid") as! String
            
            strings =  "http://ucwldemo.netcarrots.in/UCWLMobileApplication/default.aspx?guid=\(guid)&Mobileno=\(number)"
            print("webview when dealer redeeing the points\(strings)")
        }
        
        print(strings)
        let url = NSURL (string:strings );
        let requestObj = NSURLRequest(url: url! as URL)
        self.hideProgress()
        myWebView.loadRequest(requestObj as URLRequest);
        self.hideProgress()
        
    }
    //DELEGATE METHODS OF WEBVIEW
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        self.showProgress()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        self.hideProgress()
    }
    
    
    
    //PROGRESS BAR.
    func showProgress()
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.myWebView, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
    }
    
    
    func hideProgress()
    {
        MBProgressHUD.hide(for: self.myWebView, animated: true)
        
    }


}
