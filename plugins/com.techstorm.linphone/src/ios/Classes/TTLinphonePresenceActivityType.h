//
//  TTLinphonePresenceActivityType.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphonePresenceActivityType : NSObject

@property (nonatomic, strong) NSString* presenceActivityType;

-(void) parseLinphonePresenceActivityType:(LinphonePresenceActivityType)linphonePresenceActivityType;
+(LinphonePresenceActivityType)getLinphonePresenceActivityTypeWithString:(NSString*)linphonePresenceActivityTypeString;
@end
