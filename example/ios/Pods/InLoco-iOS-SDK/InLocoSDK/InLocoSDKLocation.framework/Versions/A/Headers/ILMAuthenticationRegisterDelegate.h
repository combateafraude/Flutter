//
//  ILMAuthenticationRegisterListener.h
//  InLocoMedia-iOS-SDK
//
//  Created by Lucas Cardoso on 11/03/20.
//  Copyright © 2020 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ILMAuthenticationRegisterDelegate <NSObject>

- (void)onSdkAuthenticationSuccess;
- (void)onSdkAuthenticationFailure;

@end
