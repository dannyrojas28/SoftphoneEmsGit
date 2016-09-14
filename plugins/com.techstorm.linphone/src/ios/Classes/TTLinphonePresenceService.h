//
//  TTLinphonePresenceService.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphonePresenceBasicStatus.h"

@interface TTLinphonePresenceService : NSObject

@property (nonatomic, strong) TTLinphonePresenceBasicStatus* basicStatus;
@property (nonatomic, strong) NSString* contact;
@property (nonatomic, strong) NSNumber* numberOfNotes;
@property (nonatomic, strong) NSString* serviceId;

-(void) parseLinphonePresenceService:(LinphonePresenceService*)linphonePresenceService;

@end
