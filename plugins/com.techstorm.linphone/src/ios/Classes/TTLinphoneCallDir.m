//
//  TTLinphoneCallDir.m
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import "TTLinphoneCallDir.h"

@implementation TTLinphoneCallDir

@synthesize callDir;

-(void)parseLinphoneCallDirection:(LinphoneCallDir)linphoneCallDir {
    if (linphoneCallDir == LinphoneCallOutgoing) {
        callDir = @"CallOutgoing";
    } else if (linphoneCallDir == LinphoneCallIncoming) {
        callDir = @"CallIncoming";
    }
}

+(LinphoneCallDir)getLinphoneCallDirectionWithString:(NSString*)linphoneCallDirString {
    if ([linphoneCallDirString isEqualToString:@"CallOutgoing"]) {
        return LinphoneCallOutgoing;
    } else if ([linphoneCallDirString isEqualToString:@"CallIncoming"]) {
        return LinphoneCallIncoming;
    }
    return NULL;
}

@end
