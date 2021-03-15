//
//  ILMPushProvider.h
//  InLocoMedia-iOS-SDK-Engage
//
//  Created by Gabriel Falcone on 1/20/18.
//  Copyright © 2018 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class holds the properties to request a device register.
 */
@interface ILMPushProvider : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *token;

- (instancetype)initWithName:(NSString *)providerName
                       token:(NSString *)providerToken;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
