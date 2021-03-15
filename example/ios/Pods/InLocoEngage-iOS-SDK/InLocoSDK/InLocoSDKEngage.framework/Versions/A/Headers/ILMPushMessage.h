//
//  ILMPushMessage.h
//  InLocoMedia-iOS-SDK-Engage
//
//  Created by Dicksson Oliveira on 23/01/18.
//  Copyright © 2018 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class holds the properties from received Push messages.
 */
@interface ILMPushMessage : NSObject

/**
 The notification title.
 */
@property (readonly, nullable) NSString *title;

/**
  The notification body.
 */
@property (readonly, nullable) NSString *body;

/**
 The list of push actions.
 */
@property (readonly, nullable) NSArray<NSString *> *actions;


/**
 The -init method is unavailable. Please use -initWithDictionary:.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Creates a PushMessage object from a dictionary.
 
 This dictionary will either be the application's launch options, if the application was open from a tapped notification,
 or a userInfo dictionary resulting from one of the AppDelegate's notification callbacks.

 @param dictionary A dictionary containing the In Loco Engage's push data.
 @return A instance of PushMessage.
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 Verifies if a dictionary is a valid In Loco Engage message.
 */
+ (BOOL)isInLocoMessage:(NSDictionary *)message;

@end

NS_ASSUME_NONNULL_END
