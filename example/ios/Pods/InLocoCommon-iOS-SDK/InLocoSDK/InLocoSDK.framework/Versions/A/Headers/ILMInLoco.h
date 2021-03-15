//
//  ILMInLoco.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Marcel Rebouças on 31/05/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILMOptions.h"
#import "ILMConsentTypes.h"
#import "ILMConsentDialogOptions.h"
#import "ILMConsentResult.h"
#import "ILMUserAddress.h"

typedef void (^ILMFetchResultBlock)(UIBackgroundFetchResult);
typedef void (^ILMBoolBlock)(BOOL);
typedef void (^ILMStringBlock)(NSString *_Nullable);
typedef void (^ILMConsentBlock)(ILMConsentResult *);

NS_ASSUME_NONNULL_BEGIN

@interface ILMInLoco : NSObject

/**
 Initializes the In Loco SDK with the options parameters.
 */
+ (void)initSdkWithOptions:(ILMOptions *)options;

/**
 Initializes the In Loco SDK with the InLocoOptions.plist properties file. To know more, please refer to the In Loco documentation.
 */
+ (void)initSdk;

/**
 Allows background operations.

 Should be called inside [-application:performFetchWithCompletionHandler:].
 */
+ (void)performFetchWithCompletionBlock:(nullable ILMFetchResultBlock)fetchResultBlock;

/**
 If the SDK is set to require the user's privacy consent, this method should be called once the user does or
 doesn't provide privacy consent. If the consent is true, this method is equivalent to calling [ILMInLoco giveUserPrivacyConsentForTypes:]
 with ILM_CONSENT_SET_ALL as the consent types parameter. Otherwise, it is equivalent to using ILM_CONSENT_SET_NONE.
 This value is persisted through initializations.
 */
+ (void)giveUserPrivacyConsent:(BOOL)userPrivacyConsent __deprecated;

/**
 If the SDK is set to require the user's privacy consent, this method should be called with the
 consent types the user has accepted. Predefined types can be found on ILM_CONSENT_TYPE_.
 This value is persisted through initializations.
 */
+ (void)giveUserPrivacyConsentForTypes:(NSSet <NSString *> *)consentTypes __deprecated;

/**
Sets consent types allowed by the user.
All other predefined consent types not present in ILM_CONSENT_TYPE_ are considered denied by the user.
A call to this method replaces any other consent information previously set.
*/
+ (void)setAllowedConsentTypes:(NSSet <NSString *> *)consentTypes;

/**
Allows consent for the functionality types specified in ILM_CONSENT_TYPE_.
A call to this method does not modify other consent types not present in ILM_CONSENT_TYPE_.
*/
+ (void)allowConsentType:(NSString *)consentType;

/**
Allows consents for the functionality types specified in ILM_CONSENT_TYPE_.
A call to this method does not modify other consent types not present in ILM_CONSENT_TYPE_.
*/
+ (void)allowConsentTypes:(NSSet <NSString *> *)consentTypes;

/**
Denies consent for the functionality types specified in ILM_CONSENT_TYPE_.
A call to this method does not modify other consent types not present in ILM_CONSENT_TYPE_.
*/
+ (void)denyConsentType:(NSString *)consentType;

/**
Denies consent for the functionality types specified in ILM_CONSENT_TYPE_.
A call to this method does not modify other consent types not present in ILM_CONSENT_TYPE_.
*/
+ (void)denyConsentTypes:(NSSet <NSString *> *)consentTypes;

/**
 Returns through a block if the SDK is waiting for the user privacy consent to be set.

 If YES, the method [ILMInLoco giveUserPrivacyConsent:] has not been called yet - neither to give or deny the consent.
 If NO, the method [ILMInLoco giveUserPrivacyConsent:] has already been called or the SDK isn't set to require privacy consent.
 */
+ (void)checkPrivacyConsentMissing:(ILMBoolBlock)block __deprecated;

/**
 Presents to the user a Dialog for consent request. If the user allows it, it will give the privacy consent for the consentTypes
 present on the given ILMConsentDialogOptions. Otherwise, it will deny consent for the given consentTypes.

 Returns through a block a NSDictionary containing the consent status for each consentType present on the consentTypes field ot the
 given ILMConsentDialogOptions.
 */
+ (void)requestPrivacyConsentWithOptions:(ILMConsentDialogOptions *)options andConsentBlock:(nullable ILMConsentBlock)block;

/**
 Presents to the user a Dialog for consent request. If the user allows it, it will give the privacy consent for the consentTypes
 present on the given ILMConsentDialogOptions. Otherwise, it will deny consent for the given consentTypes.
 */
+ (void)requestPrivacyConsentWithOptions:(ILMConsentDialogOptions *)options;

/**
Returns through a block a NSDictionary containing the consent status for each consentType present on the given set.
*/
+ (void)checkConsentForTypes:(NSSet <NSString *> *)consentTypes withBlock:(nullable ILMConsentBlock)block;

/**
 Sets the current user id. This information will be used on the In Loco services (i.e., for events).
 This value is persisted.
 */
+ (void)setUserId:(NSString *)userId;

/**
 Clears the current persisted user id.
 */
+ (void)clearUserId;

/**
 Sets the user address.
 This value is persisted locally.
*/
+ (void)setUserAddress:(ILMUserAddress *)userAddress;

/**
 Clears the current persisted user address.
*/
+ (void)clearUserAddress;

/**
Asynchronously retrieves the current installation id.
*/
+ (void)getInstallationId:(ILMStringBlock)block;

@end

NS_ASSUME_NONNULL_END
