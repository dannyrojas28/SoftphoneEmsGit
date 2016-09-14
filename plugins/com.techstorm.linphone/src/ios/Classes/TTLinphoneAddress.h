//
//  TTLinphoneAddress.h
//  HelloCordova
//
//  Created by Thien on 5/14/16.
//
//

#import <Foundation/Foundation.h>
#include "linphone/linphonecore.h"

#import "TTLinphoneTransportType.h"

@interface TTLinphoneAddress : NSObject

@property (nonatomic, strong) NSString* scheme;
@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* domain;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) TTLinphoneTransportType* transportType;
@property (nonatomic, strong) NSString* asString;
@property (nonatomic, strong) NSString* stringUriOnly;
@property (nonatomic, strong) NSNumber* isSecure; // BOOL
@property (nonatomic, strong) NSNumber* secure; // BOOL
@property (nonatomic, strong) NSNumber* isSip; // BOOL
@property (nonatomic, strong) NSNumber* port; // int



-(void)parseLinphoneAddress:(const LinphoneAddress*)linphoneAddress;
+(LinphoneAddress*)getLinphoneAddressWithUsername:(NSString*)username domain:(NSString*)domain;

@end
