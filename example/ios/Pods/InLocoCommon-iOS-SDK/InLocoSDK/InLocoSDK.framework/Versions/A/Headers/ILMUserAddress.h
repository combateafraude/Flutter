//
//  ILMUserAddress.h
//  InLocoMedia-iOS-SDK
//
//  Created by Felipe Andrade on 05/09/18.
//  Copyright © 2018 InLocoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class holds the user address to be used during Check In or Address Validation.
 */
@interface ILMUserAddress : NSObject

// The country name. E.g: Brazil
@property (nonatomic, strong, nullable) NSString *countryName;
// The country code. E.g: BR
@property (nonatomic, strong, nullable) NSString *countryCode;
// The state. E.g: Pernambuco
@property (nonatomic, strong, nullable) NSString *adminArea;
// The country city. E.g: Recife
@property (nonatomic, strong, nullable) NSString *subAdminArea;
// The city. E.g: Recife
@property (nonatomic, strong, nullable) NSString *locality;
// The city neighborhood. E.g: Pina
@property (nonatomic, strong, nullable) NSString *subLocality;
// The street name. E.g: Av. Engenheiro Antônio de Goes
@property (nonatomic, strong, nullable) NSString *thoroughfare;
// The building number or number range. E.g: 300 (or 300-320)
@property (nonatomic, strong, nullable) NSString *subThoroughfare;
// The postal code. E.g: 51110-100
@property (nonatomic, strong, nullable) NSString *postalCode;
// Locale for the address information. E.g: pt-Br
@property (nonatomic, strong, nullable) NSLocale *locale;
// The address latitude. E.g: -8.071848
@property (nonatomic, strong, nullable) NSNumber *latitude;
// The address longitude. E.g: -34.881594
@property (nonatomic, strong, nullable) NSNumber *longitude;
// The complete address, in human-readable format. E.g: Av. Engenheiro Antônio de Goes, 300 - Pina, Recife, PE, 51110-100
@property (nonatomic, strong, nullable) NSString *addressLine;

@end
