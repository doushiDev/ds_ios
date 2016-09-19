

import Foundation
import Alamofire
import MJRefresh
import Kingfisher

//登录状态
var loginState:Bool  = false
//缓存用户信息
var userDefaults:UserDefaults = UserDefaults.standard

let user =  userDefaults.object(forKey: "userInfo")



var alamofireManager : Manager = Manager.sharedInstanceAndTimeOut

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height




