

import Foundation
import Alamofire
import MJRefresh
import Kingfisher

//登录状态
var loginState:Bool  = false
//缓存用户信息
var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()

let user =  userDefaults.objectForKey("userInfo")



var alamofireManager : Manager = Manager.sharedInstanceAndTimeOut

let width = UIScreen.mainScreen().bounds.size.width
let height = UIScreen.mainScreen().bounds.size.height




