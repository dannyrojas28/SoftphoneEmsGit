//
//  TTChatInformation.h
//  HelloCordova
//
//  Created by Thien on 5/22/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"



@interface TTChatInformation : NSObject

@property (nonatomic, strong) NSNumber *chatEnabled; // BOOL
@property (nonatomic, strong) NSNumber *unreadTotalMessageCount; // int

-(void)parseLinphoneCore:(LinphoneCore*)LC;

@end
