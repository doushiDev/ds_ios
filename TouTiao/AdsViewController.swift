//
//  AdsViewController.swift
//  TouTiao
//
//  Created by Songlijun on 2017/2/26.
//  Copyright © 2017年 Songlijun. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdsViewController: UIViewController, GADBannerViewDelegate {
    @IBOutlet weak var adsView: GADBannerView!
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7191090490730162~9203267530")
        
        interstitial = createAndLoadInterstitial()


        // Do any additional setup after loading the view.
        adsView.delegate = self
        adsView.adUnitID = "ca-app-pub-7191090490730162/9842395935"
        adsView.rootViewController = self
        let request = GADRequest()
        // Requests test ads on test devices.
        
//        request.testDevices = ["e2c6cbd54759890e2fb3ac1bdb5abd2f"]

//        adsView.load(request)
        interstitial.load(request)

        gameOver()
    }
    func gameOver() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        }
        // Rest of game over logic goes here.
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-7191090490730162~9203267530")
//        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        interstitial = createAndLoadInterstitial()
    }

    
    func adViewDidReceiveAd(bannerView: GADBannerView!) {
        adsView.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        adsView.isHidden = false
    }
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    override var shouldAutorotate: Bool {
        
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
