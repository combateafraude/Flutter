//
//  ILMAirshipProvider.h
//  InLocoMedia-iOS-SDK-Engage
//
//  Created by Marcel Rebouças on 02/08/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILMPushProvider.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This class holds the properties to build an ILMPushProvider instance for Airship.
 */
@interface ILMAirshipProvider : ILMPushProvider

- (instancetype)initWithChannelId:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END
