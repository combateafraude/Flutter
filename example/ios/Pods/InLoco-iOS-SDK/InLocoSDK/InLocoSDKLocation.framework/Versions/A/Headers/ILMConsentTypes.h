//
//  ILMConsentTypes.h
//  InLocoMedia-iOS-SDK-Common
//
//  Created by Larissa Passos on 08/07/19.
//  Copyright © 2019 InLocoMedia. All rights reserved.
//

#ifndef ILMConsentTypes_h
#define ILMConsentTypes_h

// Consent Types
#define ILM_CONSENT_TYPE_ADDRESS_VALIDATION @"address_validation"
#define ILM_CONSENT_TYPE_ADVERTISEMENT      @"advertisement"
#define ILM_CONSENT_TYPE_ENGAGE             @"engage"
#define ILM_CONSENT_TYPE_EVENTS             @"analytics"
#define ILM_CONSENT_TYPE_LOCATION           @"location"
#define ILM_CONSENT_TYPE_CONTEXT_PROVIDER   @"context_provider"

// Consent sets
#define ILM_CONSENT_SET_ALL                 [NSSet setWithArray:@[ILM_CONSENT_TYPE_ADDRESS_VALIDATION, ILM_CONSENT_TYPE_ADVERTISEMENT, ILM_CONSENT_TYPE_ENGAGE, ILM_CONSENT_TYPE_EVENTS, ILM_CONSENT_TYPE_LOCATION, ILM_CONSENT_TYPE_CONTEXT_PROVIDER]]
#define ILM_CONSENT_SET_NONE                [[NSSet alloc] init]

#endif /* ILMConsentTypes_h */
