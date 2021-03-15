//
//  ILMInLocoEvents.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Marcel Rebouças on 07/06/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ILMInLocoEvents : NSObject

/**
 Registers an in-app event.
 Note that custom properties must have key-value pairs of NSStrings.
 */
+ (void)trackEvent:(NSString *)eventName;
+ (void)trackEvent:(NSString *)eventName properties:(NSDictionary <NSString *, NSString *> *)properties;

@end

NS_ASSUME_NONNULL_END
