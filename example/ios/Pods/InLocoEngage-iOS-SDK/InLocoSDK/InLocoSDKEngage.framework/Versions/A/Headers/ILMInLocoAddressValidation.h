//
//  ILMInLocoAddressValidation.h
//  InLocoMedia-iOS-SDK-Engage
//
//  Created by Marcel Rebouças on 11/06/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILMUserAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface ILMInLocoAddressValidation : NSObject

/**
 Sets the user address.
 This value is persisted locally.
 */
+ (void)setUserAddress:(ILMUserAddress *)userAddress;

/**
 Clears the current persisted user address.
 */
+ (void)clearUserAddress;

@end

NS_ASSUME_NONNULL_END
