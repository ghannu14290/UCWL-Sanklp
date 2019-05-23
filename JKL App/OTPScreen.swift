//
//  OTPScreen.swift
//  JKL App
//
//  Created by Ramandeep Singh Bakshi on 29/08/17.
//  Copyright © 2017 Ramandeep Singh Bakshi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD


class OTPScreen: UIViewController, UITextFieldDelegate , UIGestureRecognizerDelegate
{
    
    //OULETS.
    @IBOutlet var name: UILabel!
    @IBOutlet var membertype: UILabel!
    @IBOutlet var mobilenumber: UILabel!
    @IBOutlet var currentBalance: UILabel!
    @IBOutlet var state: UILabel!
    @IBOutlet var district: UILabel!
    @IBOutlet var otpTextfield: UITextField!
    
    //FOR PASSING THE VALUE TO NEXT VIEWCONTROLLER.
    var memberUserId = String()
    var membermobileNumber = String()
    var memberName = String()
    var membertyype = String()
    var balance = String()
    var membercomapnyName = String()
    var memberfirstName = String()
    var memberLastname = String()
    var memberEmailId = String()
    var membergender = String()
    var memberdob = String()
    var memberState = String()
    var memberDistrict = String()
    var memberprofileImage = String()
    var memberidProofImage = String()
    var memberaddress = String()
    
    var Idstate : String!
    var IdDistrict : String!
 
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //NAVIGATION BAR
        self.navigationItem.title = "Update Member"
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
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: backButn), animated: true)
        
        
        //DETAILS
        self.details()
        
        
        // Gesture
      let  tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.myviewTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapGesture)
        self.otpTextfield.addToolBarInKeyBoard()
        self.registerKeyboardNotifications()
    }
    
    
    // TapGesture Handle
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        
       self.view.endEditing(true)
    }
    
    // Keyboard appears and scrolling handling
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
         scrollView.contentInset = contentInsets
       scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    
    
    
    
    //FUNCTION FOR BACKBUTTON ACTION FROM NAVIGATION BAR
    @objc func back()
    {
        self.navigationController?.popViewController(animated: true)
        
        
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //DISPLAY DETAILS.
    func details()
    {
        
        name.text = "Name : \(memberfirstName)\(memberLastname)"
        membertype.text  = "Member Type : \(membertyype)"
        mobilenumber.text = "Mobile No : \(membermobileNumber)"
        currentBalance.text = "Current Balance : \(balance)"
        state.text = "State : \(memberState)"
        district.text = "District : \(memberDistrict)"
        
        
    }
    
    //UPDATE RETAILER PROFILE API.
    func retailer()
    {
        //USERID IN USERDEFAULT.
        let userID = UserDefaults.standard.object(forKey:"userID") as! String
        print(userID)
        
        let postString = "http://jklakshmidemo.netcarrots.in/API/Service.svc/UpdateRetailerProfile"
        
        let newTodo: [String: Any] =  ["UserId": userID,
                                       "FirmName":membercomapnyName,
                                       "FirstName":memberfirstName,
                                       "LastName":memberLastname,
                                       "MobileNumber":membermobileNumber,
                                       "EmailId":memberEmailId,
                                       "Gender":membergender,
                                       "DateofBirth":memberdob,
                                       "Address1": memberaddress,
                                       "Address2":"",
                                       "State": Idstate,
                                       "District": IdDistrict,
                                       "ImageFileType1":"JPEG",
                                       "IdProofImage" :memberidProofImage ,
                                       "ImageFileType2":"JPEG",
                                       "ProfileImage":memberprofileImage,
                                       "Otp":otpTextfield.text!] as [String : Any]
        
        print(newTodo)
        
        let user = "lakshya"
        let password = "lakshya@001"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password)
        {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        self.showProgress()
        
        Alamofire.request(postString, method: .post, parameters: newTodo,
                          
                          encoding: JSONEncoding.default, headers: headers)
            
            .responseJSON { response in
                
                
                if((response.result.value) != nil)
                {
                    self.hideProgress()
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    
                    
                    let result = swiftyJsonVar["UpdateRetailerProfile"]["Result"].stringValue
                    print(result)
                    
                    
                    if swiftyJsonVar["UpdateRetailerProfile"]["ErrorCode"].intValue == 0
                    {
                        print ("Success")
                        self.hideProgress()
                        let alert = UIAlertController(title:"", message:result , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { action in
                            
                            //MOVE TO HOME SCREEN ON SUCCESS
                            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
                            self.navigationController?.pushViewController(secondViewController, animated: true)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.leftmenu()
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                        
                    else
                    {
                        self.hideProgress()
                        //SHOW ALERT WHEN USERID IS WRONG
                        let alert = UIAlertController(title:"", message:result , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { action in
                         self.hideProgress()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                }
                
        }
        
        
    }
    //OTP API.
    func RessendApi()
    {
        //USERID IN USERDEFAULT.
        let userID = UserDefaults.standard.object(forKey:"userID") as! String
        print(userID)
        
       
        let postString = "http://jklakshmidemo.netcarrots.in/API/Service.svc/UpdateRetailerProfile"
        
        let newTodo: [String: Any] =  ["UserId": userID,
                                       "FirmName":membercomapnyName,
                                       "FirstName":memberfirstName,
                                       "LastName":memberLastname,
                                       "MobileNumber":membermobileNumber,
                                       "EmailId":memberEmailId,
                                       "Gender":membergender,
                                       "DateofBirth":memberdob,
                                       "Address1": memberaddress,
                                       "Address2":"",
                                       "State": Idstate,
                                       "District": IdDistrict,
                                       "ImageFileType1":"JPEG",
                                       "IdProofImage" :memberidProofImage ,
                                       "ImageFileType2":"JPEG",
                                       "ProfileImage":memberprofileImage,
                                       "Otp":""] as [String : Any]
        
        print(newTodo)
        let user = "lakshya"
        let password = "lakshya@001"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password)
        {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        self.showProgress()
        
        Alamofire.request(postString, method: .post, parameters: newTodo,
                          
                          encoding: JSONEncoding.default, headers: headers)
            
            .responseJSON { response in
                
                
                if((response.result.value) != nil)
                {
                    self.hideProgress()
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    
                    
                    let result = swiftyJsonVar["UpdateRetailerProfile"]["Result"].stringValue
                    print(result)
                    
                    
                    if swiftyJsonVar["UpdateRetailerProfile"]["ErrorCode"].intValue == 0
                    {
                        print ("Success")
                        self.hideProgress()
                      
                    }
                        
                    else
                    {
                        self.hideProgress()
                        //SHOW ALERT WHEN USERID IS WRONG
                        let alert = UIAlertController(title:"", message:result , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { action in
                           self.hideProgress()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                }
                
        }
        
        
    }
    
    //INFLUENCER UPDATE API.
    func influencer()
    {
        //USERID IN USERDEFAULT.
        let userID = UserDefaults.standard.object(forKey:"userID") as! String
        print(userID)
        
        
        let postString = "http://ucwldemo.netcarrots.in/API/Service.svc/UpdateInfluencerProfile"
        
        let newTodo: [String: Any] =  ["UserId": userID,
                                       "FirmName":membercomapnyName,
                                       "FirstName":memberfirstName,
                                       "LastName":memberLastname,
                                       "MobileNumber":membermobileNumber,
                                       "EmailId":memberEmailId,
                                       "Gender":membergender,
                                       "DateofBirth":memberdob,
                                       "Address1": memberaddress,
                                       "Address2":"",
                                       "State": Idstate,
                                       "District": IdDistrict,
                                       "ImageFileType1":"JPEG",
                                       "IdProofImage" :memberidProofImage,
                                       "ImageFileType2":"JPEG",
                                       "ProfileImage":memberprofileImage,
                                       "Otp":otpTextfield.text!] as [String : Any]

        
        
        print(newTodo)
        
        
        let user = "lakshya"
        let password = "lakshya@001"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password)
        {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        self.showProgress()
        
        Alamofire.request(postString, method: .post, parameters: newTodo,
                          
                          encoding: JSONEncoding.default, headers: headers)
            
            .responseJSON { response in
                
                
                if((response.result.value) != nil)
                {
                    self.hideProgress()
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    
                    
                    let result = swiftyJsonVar["UpdateInfluencerProfile"]["Result"].stringValue
                    print(result)
                    
                    
                    if swiftyJsonVar["UpdateInfluencerProfile"]["Result"].stringValue == "Success"
                    {
                        print ("Success")
                        self.hideProgress()
                        let alert = UIAlertController(title:"", message:result , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { action in
                            
                            //MOVE TO HOME SCREEN ON SUCCESS
                            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as! HomeScreen
                            self.navigationController?.pushViewController(secondViewController, animated: true)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.leftmenu()
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                        
                    else
                    {
                        self.hideProgress()
                        //SHOW ALERT WHEN USERID IS WRONG
                        let alert = UIAlertController(title:"", message:result , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { action in
                          self.hideProgress()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                }
                
                
        }
        
        
    }
    
    //INFLUENCER OTP API.
    func resendOtpApi()
    {
        //USERID IN USERDEFAULT.
        let userID = UserDefaults.standard.object(forKey:"userID") as! String
        print(userID)
        
        
        let postString = "http://ucwldemo.netcarrots.in/API/Service.svc/UpdateInfluencerProfile"
        
        let newTodo: [String: Any] =  ["UserId": userID,
                                       "FirmName":membercomapnyName,
                                       "FirstName":memberfirstName,
                                       "LastName":memberLastname,
                                       "MobileNumber":membermobileNumber,
                                       "EmailId":memberEmailId,
                                       "Gender":membergender,
                                       "DateofBirth":memberdob,
                                       "Address1": memberaddress,
                                       "Address2":"",
                                       "State": Idstate,
                                       "District": IdDistrict,
                                       "ImageFileType1":"JPEG",
                                       "IdProofImage" :memberidProofImage ,
                                       "ImageFileType2":"JPEG",
                                       "ProfileImage":memberprofileImage,
                                       "Otp":""] as [String : Any]
        
        
        
        print(newTodo)
        
        let user = "lakshya"
        let password = "lakshya@001"
        
        var headers: HTTPHeaders = [:]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password)
        {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        self.showProgress()
        
        Alamofire.request(postString, method: .post, parameters: newTodo,
                          
                          encoding: JSONEncoding.default, headers: headers)
            
            .responseJSON { response in
                
                
                if((response.result.value) != nil)
                {
                    self.hideProgress()
                    
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    
                    
                    let result = swiftyJsonVar["UpdateInfluencerProfile"]["Result"].stringValue
                    print(result)
                    
                    
                    if swiftyJsonVar["UpdateInfluencerProfile"]["Result"].stringValue == "Success"
                    {
                        print ("Success")
                        self.hideProgress()
                        
                    
                    }
                        
                    else
                    {
                        self.hideProgress()
                        //SHOW ALERT WHEN USERID IS WRONG
                        let alert = UIAlertController(title:"", message:result , preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  { action in
                            self.hideProgress()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    }
                    
                    
                    
                }
                
                
        }
        
        
    }

    //PROGRESS BAR.
    func showProgress()
    {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
    }
    
    
    func hideProgress()
    {
        MBProgressHUD.hide(for: self.view, animated: true)
        
    }
    
    
    //TEXTFIELD DELEGATE METHODS
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
         otpTextfield.resignFirstResponder()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        otpTextfield.resignFirstResponder()
        
        return true;
    }
    
    //VALIDATIONS OF TEXTFIELDS.
     func areValidTextfields() -> Bool
    {
        
        if otpTextfield.text == ""
        {
            let alert = UIAlertController(title: "", message: "Please enter OTP", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        return true
        
    }
    
   //RESEND OTP ACTION
    @IBAction func resendOTP(_ sender: Any)
    {
        if membertyype == "Retailer"
        {
            self.RessendApi()
        }
            
        else if membertyype == "Influencer"
        {
            self.resendOtpApi()
        }
    }
    
    //SBUMIT BUTTON ACTION
    @IBAction func submit(_ sender: Any)
    {
        if areValidTextfields()
        {
        
            if membertyype == "Retailer"
            {
            self.retailer()
            }
            
            else if membertyype == "Influencer"
            {
              self.influencer()
            }
       
        }
    }
    
    
}


extension UITextField{
    
    func addToolBarInKeyBoard() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        self.inputAccessoryView = numberToolbar
            
      
        
       
    }
    
    @objc func cancelNumberPad() {
        //Cancel with number pad
        
        self.text = ""
        self.resignFirstResponder()
    }
    @objc func doneWithNumberPad() {
        //Done with number pad
        self.resignFirstResponder()
    }
    
}
