//
//  TTLinphonePresenceActivity.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphonePresenceActivityType.h"

@interface TTLinphonePresenceActivity : NSObject

@property (nonatomic, strong) NSString* presenceActivityString;
@property (nonatomic, strong) TTLinphonePresenceActivityType* presenceActivityType;
@property (nonatomic, strong) NSString* activityDescription;


-(void) parseLinphonePresenceActivity:(LinphonePresenceActivity*)linphonePresenceActivity;
@end
