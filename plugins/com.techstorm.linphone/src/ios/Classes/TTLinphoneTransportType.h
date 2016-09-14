//
//  TTLinphoneTransportType.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneTransportType : NSObject

@property (nonatomic, strong) NSString* transportType;

-(void)parseLinphoneTransportType:(LinphoneTransportType)linphoneTransportType;
+(LinphoneTransportType)getLinphoneTransportTypeWithString:(NSString*)linphoneTransportTypeString;

@end
