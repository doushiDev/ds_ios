#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "QNAssessment.h"
#import "QNIpModel.h"
#import "QNDnsManager.h"
#import "QNDomain.h"
#import "QNLruCache.h"
#import "QNNetworkInfo.h"
#import "QNRecord.h"
#import "QNResolverDelegate.h"
#import "HappyDNS.h"
#import "QNDnspodEnterprise.h"
#import "QNDnspodFree.h"
#import "QNHijackingDetectWrapper.h"
#import "QNHosts.h"
#import "QNResolver.h"
#import "QNResolvUtil.h"
#import "QNTxtResolver.h"
#import "QNRefresher.h"
#import "QNDes.h"
#import "QNGetAddrInfo.h"
#import "QNHex.h"
#import "QNIP.h"

FOUNDATION_EXPORT double HappyDNSVersionNumber;
FOUNDATION_EXPORT const unsigned char HappyDNSVersionString[];

