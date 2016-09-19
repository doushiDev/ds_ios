//
//  RegisterUserViewController.swift
//  ds-ios
//
//  Created by 宋立君 on 15/11/7.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MobileCoreServices
import Qiniu
import Validator



class RegisterUserViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var resultUILabel: UILabel!
    
    
    @IBOutlet weak var pwdResultUILabel: UILabel!
    
    @IBOutlet weak var codeUILabel: UILabel!
    
    @IBOutlet weak var phoneTextField: UITextField! //手机号
    @IBOutlet weak var code: UITextField! //验证码
    @IBOutlet weak var passwordTextField: UITextField! //密码
    @IBOutlet weak var headImageView: UIImageView! 
    
    @IBOutlet weak var registerUserButton: CornerRadiusButtonByRes!
    var imagePicker = UIImagePickerController()
    
    var alamofireManager : Manager?
    
    @IBOutlet weak var sendCodeButton: BackgroundColorButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alamofireManager =  Manager.sharedInstanceAndTimeOut
        headImageView.isUserInteractionEnabled = true
        
        let tapGestureRecognizer  = UITapGestureRecognizer(target: self, action: #selector(RegisterUserViewController.uploadHeadImage(_:)))
        headImageView.addGestureRecognizer(tapGestureRecognizer)
        
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        
        
         phoneTextField.addTarget(self, action: #selector(RegisterUserViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
         passwordTextField.addTarget(self, action: #selector(RegisterUserViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        
        //设置注册按钮一开始为不可点击
        registerUserButton.isEnabled = false
        registerUserButton.alpha = 0.6
        
    }
    
    
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
                resultUILabel.text = "😀"
             }else{
                resultUILabel.text = "😫"
            }
        case 2://密码
             result = textField.text!.validate(rule: pwdRule)
            if result.isValid {
                pwdResultUILabel.text = "😀"
 
            }else{
                pwdResultUILabel.text = "😫"
            }
        case 3: //验证码
            print("验证码")
            
        default:
            break
        }
        
//        //判断状态OK 恢复注册按钮点击时间
        if (resultUILabel.text == "😀" &&  pwdResultUILabel.text == "😀") {
            registerUserButton.isEnabled = true
            registerUserButton.alpha = 1
        }

    }
    
    
    @IBOutlet weak var headImageButton: UIButton!
     
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate var timer: Timer?
    fileprivate var timeLabel: UILabel!
    fileprivate var disabledText: String!
    fileprivate var remainingSeconds = 60

    
    /**
     获取验证码
     
     - parameter sender: sender description
     */
    @IBAction func getCode(_ sender: BackgroundColorButton) {
        //发送验证码
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: self.phoneTextField.text, zone: "+86", customIdentifier: nil) { (error) -> Void in
                        
            if ((error == nil)) {
                print("发送成功")
                
                sender.isEnabled = false
                sender.alpha = 0.6
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(RegisterUserViewController.updateTimer(_:)), userInfo: nil, repeats: true)
                self.sendCodeButton.setTitle("\(self.remainingSeconds)s", for: .disabled)
            }
        }
        
    }
    
    func updateTimer(_ timer: Timer) {
        remainingSeconds -= 1
        
        if remainingSeconds <= 0 {
             self.remainingSeconds = 0
            self.timer!.invalidate()
            sendCodeButton.isEnabled = true
            sendCodeButton.alpha = 1
            remainingSeconds = 60

        }
        sendCodeButton.setTitle("\(remainingSeconds)s", for: .disabled)
    }
    
    
    /**
     注册
     
     - parameter sender: sender description
     */
    @IBAction func registerUser(_ sender: UIButton) {
        
        //验证 验证码 
        SMSSDK.commitVerificationCode(self.code.text, phoneNumber: phoneTextField.text, zone: "+86") { (error) -> Void in
            
            if ((error == nil)) {
                print("验证成功")
                let user = User()
                user.nickName = "我是逗视 \(Int(arc4random()%1000)+1)"
                
                if (userDefaults.string(forKey: "userHeadImage") == nil){
                    
                    userDefaults.set("http://img.itjh.com.cn/FtXmR6PCXm1WgUyl4kvI6zJIFY6C", forKey: "userHeadImage")
                }
                
                user.headImage = userDefaults.string(forKey: "userHeadImage")!
                user.phone = self.phoneTextField.text!
                user.platformId = "9"
                user.platformName = "逗视"
                user.password = self.passwordTextField.text!
                user.gender = 1
                //注册用户
                
                self.alamofireManager!.request(HttpClientByUser.DSRouter.registerUser(user)).responseJSON(completionHandler: {  response in
                    
                    switch response.result {
                    case .success:
//                        print(result.value)
                        let JSON = response.result.value
                        print("HTTP 状态码->\(response.response?.statusCode)")
                        if response.response?.statusCode == 401 {
                            print("此手机号已经注册")
                             let message = (JSON as! NSDictionary).value(forKey: "message") as! String
                            
                            let cancelButtonTitle = "OK"
                            
                            let alertController = DOAlertController(title: message, message: "此手机号已经注册,请更换其他手机号", preferredStyle: .alert)
                            
                            // Create the action.
                            let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .destructive) { action in
                                NSLog("The simple alert's cancel action occured.")
                            }
                            
                            // Add the action.
                            alertController.addAction(cancelAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        }else{
                            print("注册成功")
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
                        }
                        
                        
                    case .failure(let error):
                        print(error)
                        
                    }
                })
            }else{
                print("验证码错误")
                let message = "验证码错误"
                
                let cancelButtonTitle = "OK"
                
                let alertController = DOAlertController(title: message, message: "", preferredStyle: .alert)
                
                // Create the action.
                let cancelAction = DOAlertAction(title: cancelButtonTitle, style: .destructive) { action in
                    NSLog("The simple alert's cancel action occured.")
                }
                
                // Add the action.
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    
    // MARK: 用户选择头像
    
    /**
    上传头像
    
    - parameter sender: sender description
    */
    func uploadHeadImage(_ recognizer: UITapGestureRecognizer) {
        
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "拍照", style: .default) { (action) in
            // ...
            self .initWithImagePickView("拍照")
            
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "从相册上传", style: .default) { (action) in
            print(action)
            self .initWithImagePickView("相册")
            
        }
        alertController.addAction(destroyAction)
        
        
        
//        //判断是否为pad
//        let decive = UIDevice.currentDevice().model
//        
//        if decive.isEmpty {
//            if decive == "iPhone" {
//                
//                self.presentViewController(alertController, animated: true) {
//                    
//                }
//            }else{
//                
//                let popOver =  UIPopoverController(contentViewController: alertController)
//                
//             
//            }
//        }
        
        
//        UIPopoverPresentationController *popPresenter = [alertController
//            popoverPresentationController];
//        popPresenter.sourceView = button;
//        popPresenter.sourceRect = button.bounds;
        
        
        
        

        // 判断是否为pad 弹出样式
        if let popPresenter = alertController.popoverPresentationController {
            popPresenter.sourceView = recognizer.view;
            popPresenter.sourceRect = (recognizer.view?.bounds)!;
        }
        
        self.present(alertController, animated: true) {
            
                            }
        
     }
    
    
    func initWithImagePickView(_ type:NSString){
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate   = self;
        self.imagePicker.allowsEditing = true;
        
        switch type{
        case "拍照":
            self.imagePicker.sourceType = .camera
         case "相册":
            self.imagePicker.sourceType = .photoLibrary
         case "录像":
            self.imagePicker.sourceType = .camera
            self.imagePicker.videoMaximumDuration = 60 * 3
            self.imagePicker.videoQuality = .type640x480
            self.imagePicker.mediaTypes = [String(kUTTypeMovie)]
            
        default:
            print("error")
        }
        
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    // 选择之后获取数据
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        let compareResult = CFStringCompare(mediaType as NSString!, kUTTypeMovie, CFStringCompareFlags.compareCaseInsensitive)
        
        //判读是否是视频还是图片
        if compareResult == CFComparisonResult.compareEqualTo {
            
            let moviePath = info[UIImagePickerControllerMediaURL] as? URL
            
            //获取路径
            let moviePathString = moviePath!.relativePath
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePathString){
                
                UISaveVideoAtPathToSavedPhotosAlbum(moviePathString, nil, nil, nil)
                
            }
            print("视频")
            
        }
        else {
            
            print("图片")
            
            let image = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            //上传七牛
            
            let upManager = QNUploadManager()
            //压缩图片
            let imageData =  UIImageJPEGRepresentation(image!, 0.5)
            self.alamofireManager!.request(HttpClientByUtil.DSRouter.getQiNiuUpToken()).responseJSON(completionHandler: { response in
                
                switch response.result {
                case .success:
                    if let JSON = response.result.value {
                        upManager.put(imageData, key: nil, token:((JSON as! NSDictionary).value(forKey: "content") as! String) , complete: { (info, key, resp) -> Void in
                            
                            if info.statusCode == 200 {
//                                print("图片上传成功 key－> \(resp["key"] as! String)" )
//                                print("img url -> http://img.itjh.com.cn/\(resp["key"] as! String)")
                                userDefaults.setValue("http://img.itjh.com.cn/\(resp["key"] as! String)", forKey: "userHeadImage")
                            }
                            
//                            print("info-> \(info)")
                            
//                            print("resp-> \(resp)")
                            
                            }, option: nil)

                    }
                    
                case .failure(let error):
                    print(error)
                    
                }
            })
            headImageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
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



