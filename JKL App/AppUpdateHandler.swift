//
//  AppUpdateHandler.swift
//  Sankalp
//
//  Created by ghanshaym gupta on 14/06/19.
//  Copyright © 2019 Ramandeep Singh Bakshi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import MBProgressHUD
class AppUpdateHandler: NSObject {
    static let shared = AppUpdateHandler()
    
    func checkAppUpdate(){
       // http://ucwldemo.netcarrots.in/API/Service.svc/GetVersionApi
        
        //USERID IN USERDEFAULT.
     
        let user = "lakshya"
        let password = "lakshya@001"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password)
        {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        
        let postString = "http://ucwldemo.netcarrots.in/API/Service.svc/GetVersionApi"
        
        let newTodo: [String: Any] =  ["ProgramType": "sankalp"] as [String : Any]
        
        print(newTodo)
        
        //self.showProgress()
        
        Alamofire.request(postString, method: .post, parameters: newTodo,
                          
                          encoding: JSONEncoding.default, headers: headers)
            
            .responseJSON { response in
                
                
                if((response.result.value) != nil)
                {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    
                    let error_code = swiftyJsonVar["GetVersionApi"]["ErrorCode"].intValue
                    print(error_code)
                    
                    let currentiOSVersion = String(swiftyJsonVar["GetVersionApi"]["AppVersionIOS"].string ?? "")
                    
                    
                   // print(currentiOSVersion as Any)
                    
                    let getAppVersion = self.getCurrentAppVersion()
                    
                    let numericValueCurrentAppVersion = Float(getAppVersion)
                    let numericValueCurrentUpdateVersion = Float(currentiOSVersion)


                    if  Double(numericValueCurrentAppVersion!) >= Double(numericValueCurrentUpdateVersion!) {
                            print("No update")
                        
                    }
                    else
                    {

                            print("Update Available")
                        
                        let alert = UIAlertController(title: "Sankalp - Needs to Be Updated", message: "This app will not work with the future version of iOS. The developer of this app needs to update it to improve it compatibility.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (result) in
                            self.redirectAppToAppStore()
                        }))
                        UIApplication.shared.keyWindow?.rootViewController!.present(alert, animated: true, completion: nil)
                        
                    }

                    
                    
                    
                }
                
                
        }
        
        
    }
    
    
    private func getCurrentAppVersion() -> String{
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return appVersion ?? "0.0"
        
    }
    
    
    private func redirectAppToAppStore(){
        
        UIApplication.shared.open((NSURL(string: "itms-apps://itunes.apple.com/us/app/magento2-mobikul-mobile-app/id1471501116")! as URL), options: ["":""], completionHandler: nil)
    }
    
}
