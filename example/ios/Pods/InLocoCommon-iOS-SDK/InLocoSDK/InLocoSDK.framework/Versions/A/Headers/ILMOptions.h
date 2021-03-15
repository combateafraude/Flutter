//
//  ILMOptions.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Marcel Rebouças on 04/06/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class holds the necessary properties to configure the In Loco SDK initialization.
 */
@interface ILMOptions : NSObject

/**
 The application ID.
 */
@property (nonatomic, strong) NSString *applicationId;

/**
 An NSArray that identifies the devices used in development.
 */
@property (nonatomic, strong) NSArray <NSString *> *developmentDevices;

/**
 Activates the verbose mode logging. Default: YES
 */
@property (nonatomic, assign) BOOL logEnabled;

/**
 Allows visit detection and location data to be generated. Default: YES
 */
@property (nonatomic, assign, getter = isLocationEnabled) BOOL locationEnabled;

/**
 This property delays the full SDK initialization until your application calls [ILMInLoco giveUserPrivacyConsent:YES].
 If consent is not given, the SDK will initialize in limited mode.
 
 It should be set to YES for GDPR users.
 
 Default: NO
 */
@property (nonatomic, assign) BOOL userPrivacyConsentRequired;

/**
 Allows the SDK to track the user's screen navigation. This is used to improve app events. Default: NO
 */
@property (nonatomic, assign) BOOL screenTrackingEnabled;

- (instancetype)initWithApplicationId:(NSString *)applicationId;

- (instancetype)initFromPlist;

/**
 Validates the ILMOptions properties.
 
 @param options The ILMOptions object to be validated.
 @return Returns YES if the applicationId is not nil, NO otherwise.
 */
+ (BOOL)checkCredentialsForOptions:(ILMOptions *)options;

/**
 Validates if there is a Plist to be loaded
 */
+ (BOOL)hasPlist;

@end

NS_ASSUME_NONNULL_END
