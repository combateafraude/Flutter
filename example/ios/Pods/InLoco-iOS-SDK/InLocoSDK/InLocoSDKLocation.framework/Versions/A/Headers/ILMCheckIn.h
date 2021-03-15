//
//  ILMCheckIn.h
//  InLocoMedia-iOS-SDK-Location
//
//  Created by Douglas Soares on 16/03/20.
//  Copyright © 2020 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILMUserAddress.h"

@interface ILMCheckIn : NSObject

@property (nonatomic, strong, nullable) NSString *placeName;
@property (nonatomic, strong, nullable) NSString *placeId;
@property (nonatomic, strong, nullable) ILMUserAddress *userAddress;
@property (nonatomic, strong, nullable) NSDictionary <NSString *, NSString *> *extras;

@end
