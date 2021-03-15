//
//  ILMConsentDialogOptions.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Júlia Godoy on 06/04/20.
//  Copyright © 2020 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILMError.h"

NS_ASSUME_NONNULL_BEGIN

/**
* The parameters that will be used to create the consent dialog
*/

@interface ILMConsentDialogOptions : NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *message;
@property(nonatomic, strong) NSString *acceptText;
@property(nonatomic, strong) NSString *denyText;
@property(nonatomic, strong) NSSet <NSString *> *consentTypes;

@end

@interface ILMConsentDialogOptionsBuilder : NSObject

/**
 * The title that will be shown on the dialog that will be presented on the screen
 *
 * You must set this property, otherwise the alert can't be shown
 */
@property(nonatomic, strong) NSString *title;

/**
 * The message that will be shown on the dialog that will be presented on the screen
 *
 * You must set this property, otherwise the alert can't be shown
 */
@property(nonatomic, strong) NSString *message;

/**
 * The text that will be shown on the dialog's accept button that will be presented on the screen
 *
 * You must set this property, otherwise the alert can't be shown
 */
@property(nonatomic, strong) NSString *acceptText;

/**
* The denyText that will be shown on the dialog's deny text that will be presented on the screen.
*
* You must set this property, otherwise the alert can't be shown
*/
@property(nonatomic, strong) NSString *denyText;

/**
 * The consent types that will requested in the dialog. You must set the dialog message according to the requested consent type.
 *
 * You must set this property, otherwise the alert can't be shown
 */
@property(nonatomic, strong) NSSet <NSString *> *consentTypes;

- (ILMConsentDialogOptions *)build:(ILMError **)error;

@end
NS_ASSUME_NONNULL_END
