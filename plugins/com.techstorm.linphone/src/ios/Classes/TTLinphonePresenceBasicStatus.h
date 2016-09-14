//
//  TTLinphonePresenceBasicStatus.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphonePresenceBasicStatus : NSObject

@property (nonatomic, strong) NSString* basicStatus;

-(void) parseLinphonePresenceBasicStatus:(LinphonePresenceBasicStatus)linphonePresenceBasicStatus;
+(LinphonePresenceBasicStatus)getLinphonePresenceBasicStatusWithString:(NSString*)linphonePresenceBasicStatus;

@end
