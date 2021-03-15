//
//  ILMInLocoPush.h
//  InLocoMedia-iOS-SDK-Engage
//
//  Created by Marcel Rebouças on 10/06/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILMPushProvider.h"
#import "ILMPushProviders.h"
#import "ILMFirebaseProvider.h"
#import "ILMAirshipProvider.h"
#import "ILMPushMessage.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

typedef void (^ILMBlock)(void);
typedef void (^ILMNSErrorBlock)(NSError *_Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface ILMInLocoPush : NSObject

/**
 Sets the Push Provider. This method should be called everytime that a new push provider token is generated. This value is persisted.
 */
+ (void)setPushProvider:(ILMPushProvider *)pushProvider;

/**
 Clears last set Push Provider.
 */
+ (void)clearPushProvider;

/**
 Enables or disables the device from targeted push notifications. This value is persisted. Default: YES.
 */
+ (void)setPushNotificationsEnabled:(BOOL)pushNotificationsEnabled;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"

/**
 Registers tapped pushes that caused the application to start.
 
 Must be called inside [-application:didFinishLaunchingWithOptions:].
 */
+ (void)appDidFinishLaunchingWithMessage:(ILMPushMessage *)message;

/**
 Registers tapped pushes.
 
 Must be called inside [-userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:].
 */
+ (void)didReceiveNotificationResponse:(ILMPushMessage *)message;
+ (void)didReceiveNotificationResponse:(ILMPushMessage *)message
                       completionBlock:(nullable ILMBlock)completionBlock;

#pragma clang diagnostic pop
#endif

@end

NS_ASSUME_NONNULL_END
