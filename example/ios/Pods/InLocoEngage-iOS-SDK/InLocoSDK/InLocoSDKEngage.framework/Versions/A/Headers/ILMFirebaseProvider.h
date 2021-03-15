//
//  ILMFirebaseProvider.h
//  InLocoMedia-iOS-SDK-Engage
//
//  Created by Gabriel Falcone on 1/20/18.
//  Copyright © 2018 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILMPushProvider.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This class holds the properties to build an ILMPushProvider instance for Firebase.
*/
@interface ILMFirebaseProvider : ILMPushProvider

- (instancetype)initWithToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
