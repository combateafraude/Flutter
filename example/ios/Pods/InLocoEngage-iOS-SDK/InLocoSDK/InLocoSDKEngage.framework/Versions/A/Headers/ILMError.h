//
//  ILMrror.h
//  InLocoMediaAPI
//
//  Created by InLocoMedia on 11/20/13.
//  Copyright (c) 2013 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define ILME_ERROR_MESSAGE_REGEX_1 @"^errors:\\[(\\w+)\\.(\\w+)(\\-\\w+)*\\]$"
#define ILME_ERROR_MESSAGE_REGEX_1 @"(\\w+)\\.(\\w+)(\\-\\w+)*"

@interface ILMError : NSError

// FIXME: remove the properties below and use the NSError's userInfo Dictionary to store the data. (https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSError_Class/Reference/Reference.html)

@property (nonatomic, strong) NSDictionary *extraInfo;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description;

- (instancetype)initWithException:(NSException *)exception;

@end
