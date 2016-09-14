//
//  TTLinphonePresenceModel.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphonePresenceActivity.h"
#import "TTLinphonePresenceBasicStatus.h"

@interface TTLinphonePresenceModel : NSObject

@property (nonatomic, strong) NSNumber* timestamp; // long
@property (nonatomic, strong) NSString* contact;
@property (nonatomic, strong) TTLinphonePresenceActivity* activity;
@property (nonatomic, strong) TTLinphonePresenceBasicStatus* basicStatus;
@property (nonatomic, strong) NSNumber* numberOfServices; // unsigned int
@property (nonatomic, strong) NSNumber* numberOfPersons; // unsigned int


-(void)parseLinphonePresenceModel:(LinphonePresenceModel*)linphonePresenceModel;

@end
