//
//  ILMConsentResult.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Júlia Godoy on 06/04/20.
//  Copyright © 2020 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
* The result obtained after a consent check operation
*/
@interface ILMConsentResult : NSObject

- (instancetype)initWithResult:(NSDictionary<NSString*, NSString*> *)result;

/**
 * Verifies if the the state of all consent types searched are GIVEN
 * Returns true if all requested consent types are given.
 */
- (BOOL)areAllConsentTypesGiven;

/**
 * Verifies if the the state of all consent types are either GIVEN or DENIED.
 * Returns true if all requested consent types are not given neither denied.
 */
- (BOOL)isWaitingConsent;

/**
 * Verifies if the operation has finished or was incomplete due to any error that occurred.
 * Returns true if the operation has finished and false if any exception was thrown in the process.
 */
- (BOOL)hasFinished;

/**
 * Gets the NSDictionary containing the state for each requested consent type
 * Returns the NSDictionary with each requested consent type and its state
 */
- (NSDictionary<NSString*, NSString*> *)getResult;

@end

NS_ASSUME_NONNULL_END
