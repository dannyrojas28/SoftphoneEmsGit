//
//  TTLinphoneReason.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneReason : NSObject

@property (nonatomic, strong) NSString* reason;

-(void)parseLinphoneReason:(LinphoneReason)linphoneReason;
+(LinphoneReason)getLinphoneReasonWithString:(NSString*)linphoneReasonString;

@end
