//
//  HomeViewController.swift
//  PageController
//
//  Created by Songlijun on 15/10/10.
//  Copyright © 2015年 Songlijun. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?

  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setNav();
        
        var controllerArray : [UIViewController] = []

        // Do any additional setup after loading the view.
        let aStoryboard = UIStoryboard(name: "Home", bundle:Bundle.main)

        
        let newVideoTableViewController = aStoryboard.instantiateViewController(withIdentifier: "VideoTableViewController") as! VideoTableViewController
        
        newVideoTableViewController.type = 0
        
        newVideoTableViewController.videoInfos =
            DataCenter.shareDataCenter.getVideosFromType(0)
        
        let hotVideoTableViewController = aStoryboard.instantiateViewController(withIdentifier: "VideoTableViewController") as! VideoTableViewController
        
        hotVideoTableViewController.type = 2
        hotVideoTableViewController.title = "热门"
        
        hotVideoTableViewController.videoInfos =
            DataCenter.shareDataCenter.getVideosFromType(2)
        
        
        let popVideoTableViewController = aStoryboard.instantiateViewController(withIdentifier: "VideoTableViewController") as! VideoTableViewController
        popVideoTableViewController.type = 1
        popVideoTableViewController.title = "精华"
        
        popVideoTableViewController.videoInfos =
            DataCenter.shareDataCenter.getVideosFromType(1)
        
        controllerArray.append(newVideoTableViewController)
        controllerArray.append(hotVideoTableViewController)
        controllerArray.append(popVideoTableViewController)
      
        let parameters: [CAPSPageMenuOption] = [
            .selectedMenuItemLabelColor(UIColor(rgba:"#f0a22a")),
            .unselectedMenuItemLabelColor(UIColor(rgba:"#939395")),
            .scrollMenuBackgroundColor(UIColor(rgba: "#f2f2f2")),
            .viewBackgroundColor(UIColor.white),
            .selectionIndicatorColor(UIColor(rgba:"#fea113")),
            .bottomMenuHairlineColor(UIColor(rgba:"#f2f2f2")),
            
            .menuItemFont(UIFont(name: "AvenirNextCondensed-DemiBold", size: 13.0)!),
            .menuHeight(40.0),
            .menuItemWidth(90.0),
            
            
            .centerMenuItems(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 112), pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
 
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    视图开始加载 出现
    
    - parameter animated: animated description
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("viewWillAppear")
//        self.navigationController?.navigationBar.hidden = false

    }
    
    /**
    视图全部加载完 出现
    
    - parameter animated: animated description
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false

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
