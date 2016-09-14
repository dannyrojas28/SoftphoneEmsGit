//
//  TTLinphonePresenceNote.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphonePresenceNote : NSObject

@property (nonatomic, strong) NSString* lang;
@property (nonatomic, strong) NSString* content;


-(void) parseLinphonePresenceNote:(LinphonePresenceNote*)linphonePresenceNote;

@end
