//
//  GADMRewardBasedVideoAdNetworkConnector.h
//  Google Mobile Ads SDK
//
//  Copyright 2015 Google. All rights reserved.
//

#import <GoogleMobileAds/GoogleMobileAds.h>

#import "GADMRewardBasedVideoAdNetworkAdapterProtocol.h"

/// Reward based video ad network adapters interact with the mediation SDK using an object that
/// conforms to the GADMRewardBasedVideoAdNetworkConnector protocol. The connector object can be
/// used to obtain information for ad requests and to call back to the mediation SDK on ad responses
/// and user interactions.
@protocol GADMRewardBasedVideoAdNetworkConnector<NSObject>

/// Publisher ID set by the publisher on the AdMob frontend.
- (NSString *)publisherId;

/// Mediation configurations set by the publisher on the AdMob frontend.
- (NSDictionary *)credentials;

/// Returns YES if the publisher is requesting test ads.
- (BOOL)testMode;

/// The adapter's ad network extras specified in GADRequest.
- (id<GADAdNetworkExtras>)networkExtras;

/// Returns the value of childDirectedTreatment supplied by the publisher. Returns nil if the
/// publisher hasn't specified child directed treatment. Returns @YES if child directed treatment is
/// enabled.
- (NSNumber *)childDirectedTreatment;

/// The end user's gender set by the publisher in GADRequest. Returns kGADGenderUnknown if it has
/// not been specified.
- (GADGender)userGender;

/// The end user's birthday set by the publisher. Returns nil if it has not been specified.
- (NSDate *)userBirthday;

/// Returns YES if the publisher has specified latitude and longitude location.
- (BOOL)userHasLocation;

/// Returns the user's latitude or 0 if location isn't specified.
- (CGFloat)userLatitude;

/// Returns the user's longitude or 0 if location isn't specified.
- (CGFloat)userLongitude;

/// Returns the user's location accuracy or 0 if location isn't specified.
- (CGFloat)userLocationAccuracyInMeters;

/// Returns user's location description. May return a value even if userHasLocation is NO.
- (NSString *)userLocationDescription;

/// Keywords describing the user's current activity. Example: @"Sport Scores".
- (NSArray *)userKeywords;

#pragma mark - Adapter Callbacks

/// Tells the delegate that the adapter successfully set up a reward based video ad.
- (void)adapterDidSetUpRewardBasedVideoAd:
        (id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter;

/// Tells the delegate that the adapter failed to set up a reward based video ad.
- (void)adapter:(id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter
    didFailToSetUpRewardBasedVideoAdWithError:(NSError *)error;

/// Tells the delegate that a reward based video ad was clicked.
- (void)adapterDidGetAdClick:(id<GADMRewardBasedVideoAdNetworkAdapter>)adapter;

/// Tells the delegate that a reward based video ad has loaded.
- (void)adapterDidReceiveRewardBasedVideoAd:
        (id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter;

/// Tells the delegate that a reward based video ad has opened.
- (void)adapterDidOpenRewardBasedVideoAd:
        (id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter;

/// Tells the delegate that a reward based video ad has started playing.
- (void)adapterDidStartPlayingRewardBasedVideoAd:
        (id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter;

/// Tells the delegate that a reward based video ad has closed.
- (void)adapterDidCloseRewardBasedVideoAd:
        (id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter;

/// Tells the delegate that the adapter has rewarded the user.
- (void)adapter:(id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAd
    didRewardUserWithReward:(GADAdReward *)reward;

/// Tells the delegate that a reward based video ad's action will leave the application.
- (void)adapterWillLeaveApplication:
        (id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter;

/// Tells the delegate that a reward based video ad failed to load.
- (void)adapter:(id<GADMRewardBasedVideoAdNetworkAdapter>)rewardBasedVideoAdAdapter
    didFailToLoadRewardBasedVideoAdwithError:(NSError *)error;

@end
