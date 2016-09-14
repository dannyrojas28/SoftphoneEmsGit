//
//  TTLinphonePresenceBasicStatus.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphonePresenceBasicStatus.h"

@implementation TTLinphonePresenceBasicStatus

-(void) parseLinphonePresenceBasicStatus:(LinphonePresenceBasicStatus)linphonePresenceBasicStatus {
    if (linphonePresenceBasicStatus == LinphonePresenceBasicStatusOpen) {
        self.basicStatus = @"PresenceBasicStatusOpen";
    } else if (linphonePresenceBasicStatus == LinphonePresenceBasicStatusClosed) {
        self.basicStatus = @"PresenceBasicStatusClosed";
    }
}
+(LinphonePresenceBasicStatus)getLinphonePresenceBasicStatusWithString:(NSString*)linphonePresenceBasicStatus {
    if ([linphonePresenceBasicStatus isEqualToString:@"PresenceBasicStatusOpen"]) {
        return LinphonePresenceBasicStatusOpen;
    } else if ([linphonePresenceBasicStatus isEqualToString:@"PresenceBasicStatusClosed"]) {
        return LinphonePresenceBasicStatusClosed;
    }
    return NULL;
}

@end
