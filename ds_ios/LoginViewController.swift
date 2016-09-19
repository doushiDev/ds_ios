//
//  LoginViewController.swift
//  ds-ios 登录页面
//
//  Created by 宋立君 on 15/11/1.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import Alamofire
import Validator

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginUIButton: CornerRadiusButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alamofireManager =  Manager.sharedInstanceAndTimeOut
        
        phoneTextField.delegate = self
        pwdTextField.delegate = self
        
        
        phoneTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        pwdTextField.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        
        //设置登录按钮一开始为不可点击
        loginUIButton.isEnabled = false
        loginUIButton.alpha = 0.6
        
    }
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var pwdTextField: UITextField!
    
    
    @IBOutlet weak var phoneResultUILabel: UILabel!
    
    
    @IBOutlet weak var pwdResultUILabel: UILabel!
    
    var alamofireManager : Manager?
    
    
    
    /**
     检测正在输入
     
     - parameter textField: textField description
     */
    func textFieldDidChange(_ textField: UITextField){
        
        
//        print("我正在输入 \(textField.tag)")
        
        
        let phoneRule = ValidationRuleLength(min: 11, max: 11, failureError: ValidationError(message: "😫"))
        
        let pwdRule = ValidationRuleLength(min: 8, failureError: ValidationError(message: "😫"))
        let result:ValidationResult
        
        
        switch textField.tag{
        case 1://手机号
             result = textField.text!.validate(rule: phoneRule)
            if result.isValid {
                phoneResultUILabel.text = "😀"
            }else{
                phoneResultUILabel.text = "😫"
            }
        case 2://密码
             result = textField.text!.validate(rule: pwdRule)
            if result.isValid {
                pwdResultUILabel.text = "😀"
                
            }else{
                pwdResultUILabel.text = "😫"
            }
        default:
            break
        }
        
        //        //判断状态OK 恢复登录按钮点击时间
        if (phoneResultUILabel.text == "😀" &&  pwdResultUILabel.text == "😀") {
            loginUIButton.isEnabled = true
            loginUIButton.alpha = 1
        }
        
    }
    
    
    
    
    @IBAction func closeKeyBoard()
    {
        self.phoneTextField?.resignFirstResponder()
        self.pwdTextField?.resignFirstResponder()
        //这是点击背景触发的事件 用.调用方法
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        print("点击了登录")
        
        self.alamofireManager!.request(HttpClientByUser.DSRouter.loginUser(phoneTextField.text!, pwdTextField.text!)).responseJSON(completionHandler: { response in
            
            switch response.result {
            case .success:
                let JSON = response.result.value
                
                print("HTTP 状态码->\(response.response!.statusCode)")
                if response.response!.statusCode == 201{
                    print("登录成功")
                    let userDictionary = (JSON as! NSDictionary).value(forKey: "content") as! NSDictionary
                    //将用户信息保存到内存中
                    userDefaults.set(userDictionary, forKey: "userInfo")
                    let userInfo = User(id: userDictionary["id"] as! Int,
                        
                        nickName: userDictionary["nickName"] as! String,
                        password: "",
                        headImage: userDictionary["headImage"] as! String,
                        phone: userDictionary["phone"] as! String,
                        gender: userDictionary["gender"] as! Int,
                        platformId: userDictionary["platformId"] as! String,
                        platformName: userDictionary["platformName"] as! String)
                    
                    DataCenter.shareDataCenter.user = userInfo
                    //返回my页面
                    self.navigationController?.popToRootViewController(animated: true)
//
                }else{
                    print("登录失败")
                    let error_detail = (JSON as! NSDictionary).value(forKey: "error_detail") as! String
                    
                    let error = (JSON as! NSDictionary).value(forKey: "error") as! String
//                    print("\(error_detail)")
                    
                    let title = error
                    let message = error_detail
                    let cancelButtonTitle = "OK"
                    
                    let alertController = DOAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    // Create the action.
                    let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .destructive) { action in
                        NSLog("The simple alert's cancel action occured.")
                    }
                    
                    // Add the action.
                    alertController.addAction(cancelAction)
                    
                   self.present(alertController, animated: true, completion: nil)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
    
    /**
     qq登录
     
     - parameter sender: 按钮
     */
    @IBAction func qqLogin(_ sender: UIButton) {
        print("点击了QQ登录")
        self.phoneTextField?.resignFirstResponder()
        self.pwdTextField?.resignFirstResponder()
        //授权
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatform(withName: UMShareToQQ)
        
        snsPlatform?.loginClickHandler(self,UMSocialControllerService.default(),true,{(response :UMSocialResponseEntity!) ->Void in
            if response.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
                
                var snsAccount = UMSocialAccountManager.socialAccountDictionary()
                
                let qqUser:UMSocialAccountEntity =  snsAccount[UMShareToQQ] as! UMSocialAccountEntity
                
//                print("QQ用户数据\(qqUser)")
                
                let user = User()
                user.phone = ""
                user.password = ""
                user.gender = 1
                //用户id
                user.platformId = qqUser.usid
                user.platformName = "QQ"
                //微博昵称
                user.nickName = qqUser.userName
                //用户头像
                user.headImage = qqUser.iconURL
                userDefaults.setValue(qqUser.iconURL, forKey: "userHeadImage")
                if snsAccount != nil{
                    //注册用户
                    self.alamofireManager!.request(HttpClientByUser.DSRouter.registerUser(user)).responseJSON(completionHandler: { response -> Void in
                        
                        switch response.result {
                        case .success:
//                            print("HTTP 状态码->\(response?.statusCode)")
                            print("注册成功")
//                            print(result.value)
                            let JSON = response.result.value
                            let userDictionary = (JSON as! NSDictionary).value(forKey: "content") as! NSDictionary
                            //将用户信息保存到内存中
                            userDefaults.set(userDictionary, forKey: "userInfo")

                            
                            let userInfo = User(id: userDictionary["id"] as! Int,
                                
                                nickName: userDictionary["nickName"] as! String,
                                password: "",
                                 headImage: userDictionary["headImage"] as! String,
                                phone: userDictionary["phone"] as! String,
                                gender: userDictionary["gender"] as! Int,
                                platformId: userDictionary["platformId"] as! String,
                                platformName: userDictionary["platformName"] as! String)
                            
                    
                            DataCenter.shareDataCenter.user = userInfo
                            //返回my页面
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        case .failure(let error):
                            print(error)
                        }
                    })
                }else{
                    
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        });
    }
    
    
    @IBAction func weiboLogin(_ sender: UIButton) {
        print("点击了微博登录")
        self.phoneTextField?.resignFirstResponder()
        self.pwdTextField?.resignFirstResponder()
        //授权
        
        let snsPlatform = UMSocialSnsPlatformManager.getSocialPlatform(withName: UMShareToSina)
        
        snsPlatform?.loginClickHandler(self,UMSocialControllerService.default(),true,{(response :UMSocialResponseEntity!) ->Void in
            
            
            if response.responseCode.rawValue == UMSResponseCodeSuccess.rawValue {
                
                var snsAccount = UMSocialAccountManager.socialAccountDictionary()
                
                let weiBoUser:UMSocialAccountEntity =  snsAccount[UMShareToSina] as! UMSocialAccountEntity
//                print("微博用户数据\(weiBoUser)")
                
                let user = User()
                user.phone = ""
                user.password = ""
                user.gender = 1
                //用户id
                user.platformId = weiBoUser.usid
                user.platformName = "weiBo"
                //微博昵称
                user.nickName = weiBoUser.userName
                //用户头像
                user.headImage = weiBoUser.iconURL
                userDefaults.setValue(weiBoUser.iconURL, forKey: "userHeadImage")
                if snsAccount != nil{
                    //注册用户
                    self.alamofireManager!.request(HttpClientByUser.DSRouter.registerUser(user)).responseJSON(completionHandler: { response in
                        
                        switch response.result {
                        case .success:
//                            print("HTTP 状态码->\(response?.statusCode)")
                            print("注册成功")
                            print(response.result.value)
                            let JSON = response.result.value
                            let userDictionary = (JSON as! NSDictionary).value(forKey: "content") as! NSDictionary
                            //将用户信息保存到内存中
                            userDefaults.set(userDictionary, forKey: "userInfo")
                           
                            let userInfo = User(id: userDictionary["id"] as! Int,
                                
                                nickName: userDictionary["nickName"] as! String,
                                        password: "",
                                headImage: userDictionary["headImage"] as! String,
                                phone: userDictionary["phone"] as! String,
                                gender: userDictionary["gender"] as! Int,
                                platformId: userDictionary["platformId"] as! String,
                                platformName: userDictionary["platformName"] as! String)
                            
                            
                            DataCenter.shareDataCenter.user = userInfo
                            
                            //返回my页面
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        case .failure(let error):
                            print(error)
                        }
                    })
                }else{
                    
                }
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
        });
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
