//
//  ILMInLocoDemo.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Douglas Soares on 30/11/20.
//  Copyright © 2020 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILMUserAddress.h"

NS_ASSUME_NONNULL_BEGIN

@interface ILMInLocoDemo : NSObject

/**
 Records a login.
*/
+ (void)trackLogin:(NSString *)accountId;

/**
 Records a sign up.
*/
+ (void)trackSignUp:(NSString * _Nullable)signUpId address:(ILMUserAddress * _Nullable)userAddress;

@end

NS_ASSUME_NONNULL_END
