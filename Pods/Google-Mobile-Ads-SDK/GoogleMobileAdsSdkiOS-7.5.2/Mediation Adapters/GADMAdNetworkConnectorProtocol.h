//
//  GADMAdNetworkConnectorProtocol.h
//  Google Mobile Ads SDK
//
//  Copyright 2011 Google. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UIKit/UIKit.h>

@protocol GADAdNetworkExtras;
@protocol GADMAdNetworkAdapter;

/// Ad network adapters interact with the mediation SDK using an object that implements the
/// GADMAdNetworkConnector protocol. The connector object can be used to obtain necessary
/// information for ad requests, and to call back to the mediation SDK on ad request returns and
/// user interactions.
@protocol GADMAdNetworkConnector<NSObject>

#pragma mark - Information for Adapters

/// Single string publisher ID for the adapter, supplied by the mediation server and set by the user
/// in mediation.admob.com . For SDKs requiring more than one string, use the -credentials method.
- (NSString *)publisherId;

/// For SDKs requiring more than one string to identify the publisher, use this method to obtain
/// credentials.
- (NSDictionary *)credentials;

/// Whether the user has specified test ads.
- (BOOL)testMode;

/// The extras provided in GADRequest for this adapter's ad network.
- (id<GADAdNetworkExtras>)networkExtras;

/// When you need to show a landing page or any other modal view, such as when a user clicks or when
/// your Ads SDK needs to show an interstitial, use this method to obtain a UIViewController that
/// you can use to show your modal view. Call the -presentViewController:animated:completion: method
/// of the returned UIViewController .
- (UIViewController *)viewControllerForPresentingModalView;

/// Returns value of childDirectedTreatment supplied by the publisher. Returns nil if the publisher
/// hasn't specified child directed treatment. Returns NSNumber representation of YES if child
/// directed treatment is enabled.
- (NSNumber *)childDirectedTreatment;

/// The end user's gender set by the App in GADRequest. If none specified, returns
/// kGADGenderUnknown.
- (GADGender)userGender;

/// The end user's birthday set by the App. If none specified, returns nil.
- (NSDate *)userBirthday;

/// The end user's latitude, longitude and accuracy, set in GADRequest. If none specified,
/// hasLocation retuns NO, and userLatitude, userLongitude and userLocationAccuracyInMeters will all
/// return 0. You may use these to construct CLLocation objects. According to Apple's guidelines,
/// app publishers should not to use Core Location just for advertising. By not requiring
/// CLLocation, publishers will not have to include the Core Location framework if it is not
/// desired.
- (BOOL)userHasLocation;
- (CGFloat)userLatitude;
- (CGFloat)userLongitude;
- (CGFloat)userLocationAccuracyInMeters;

/// Description of the user's location, in free form text, set in GADRequest. If not available,
/// returns nil. This may be set even if userHasLocation is NO.
- (NSString *)userLocationDescription;

/// Keywords describing the current activity of the user such as @"Sport Scores", set by the App. If
/// none, returns nil.
- (NSArray *)userKeywords;

#pragma mark - Adapter Callbacks

/// Tells the connector that the adapter failed to receive an ad.
- (void)adapter:(id<GADMAdNetworkAdapter>)adapter didFailAd:(NSError *)error;

/// Tells the connector that the adapter received a banner ad.
- (void)adapter:(id<GADMAdNetworkAdapter>)adapter didReceiveAdView:(UIView *)view;

/// Tells the connector that the adapter received an interstitial.
- (void)adapterDidReceiveInterstitial:(id<GADMAdNetworkAdapter>)adapter;

/// Tells the connector that the adapter has received a mediated native ad. |mediatedNativeAd| is
/// used by the Google Mobile Ads SDK for constructing a native ad object.
- (void)adapter:(id<GADMAdNetworkAdapter>)adapter
    didReceiveMediatedNativeAd:(id<GADMediatedNativeAd>)mediatedNativeAd;

#pragma mark Ad events

// Adapter should call as many of these as possible, during the lifecycle of the loaded banner or
// interstitial ad.

/// Tells the connector that the adapter recorded a user click.
- (void)adapterDidGetAdClick:(id<GADMAdNetworkAdapter>)adapter;
/// Tells the connector that the adapter will leave the application because of a user action.
- (void)adapterWillLeaveApplication:(id<GADMAdNetworkAdapter>)adapter;

// Adapter should call as many of these as possible, during the lifecycle of the loaded banner ad.

/// Tells the connector that the adapter will present a full screen modal.
- (void)adapterWillPresentFullScreenModal:(id<GADMAdNetworkAdapter>)adapter;
/// Tells the connector that the adapter will dismiss a full screen modal.
- (void)adapterWillDismissFullScreenModal:(id<GADMAdNetworkAdapter>)adapter;
/// Tells the connector that the adapter dismissed a full screen modal.
- (void)adapterDidDismissFullScreenModal:(id<GADMAdNetworkAdapter>)adapter;

// Adapter should call these methods during the lifecycle of the loaded interstitial ad.

/// Tells the connector that the adapter will present an interstitial.
- (void)adapterWillPresentInterstitial:(id<GADMAdNetworkAdapter>)adapter;
/// Tells the connector that the adapter will dismiss an interstitial.
- (void)adapterWillDismissInterstitial:(id<GADMAdNetworkAdapter>)adapter;
/// Tells the connector that the adapter did dismiss an interstitial.
- (void)adapterDidDismissInterstitial:(id<GADMAdNetworkAdapter>)adapter;

#pragma mark Deprecated

- (void)adapter:(id<GADMAdNetworkAdapter>)adapter
    didReceiveInterstitial:(NSObject *)interstitial
    GAD_DEPRECATED_MSG_ATTRIBUTE("Use adapterDidReceiveInterstitial:.");

- (void)adapter:(id<GADMAdNetworkAdapter>)adapter
    clickDidOccurInBanner:(UIView *)view GAD_DEPRECATED_MSG_ATTRIBUTE("Use adapterDidGetAdClick:.");

- (void)adapter:(id<GADMAdNetworkAdapter>)adapter
    didFailInterstitial:(NSError *)error GAD_DEPRECATED_MSG_ATTRIBUTE("Use adapter:didFailAd:");

@end
