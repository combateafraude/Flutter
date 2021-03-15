//
//  InLoco.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Marcel Rebouças on 11/06/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#ifndef InLoco_h
#define InLoco_h

#import "ILMInLoco.h"
#import "ILMInLocoEvents.h"
#import "ILMInLocoDemo.h"

#if !defined(__has_include)
#error "InLoco.h won't import headers because your compiler doesn't support __has_include. Please import the headers individually."
#else

#if __has_include(<InLocoSDKCore/InLocoCore.h>)
#import <InLocoSDKCore/InLocoCore.h>
#endif

#if __has_include(<InLocoSDKAds/InLocoAds.h>)
#import <InLocoSDKAds/InLocoAds.h>
#endif

#if __has_include(<InLocoSDKLocation/InLocoLocation.h>)
#import <InLocoSDKLocation/InLocoLocation.h>
#endif

#if __has_include(<InLocoSDKEngage/InLocoEngage.h>)
#import <InLocoSDKEngage/InLocoEngage.h>
#endif

#endif  // defined(__has_include)

#endif /* InLoco_h */
