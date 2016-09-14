//
//  TTLinphoneCallStatus.m
//  HelloCordova
//
//  Created by Thien on 5/14/16.
//
//

#import "TTLinphoneCallStatus.h"


@implementation TTLinphoneCallStatus
@synthesize callStatus;

-(void)parseLinphoneCallStatus:(LinphoneCallStatus)linphoneCallStatus {
    if (linphoneCallStatus == LinphoneCallSuccess) {
        callStatus = @"CallSuccess";
    } else if (linphoneCallStatus == LinphoneCallAborted) {
        callStatus = @"CallAborted";
    } else if (linphoneCallStatus == LinphoneCallMissed) {
        callStatus = @"CallMissed";
    } else if (linphoneCallStatus == LinphoneCallDeclined) {
        callStatus = @"CallDeclined";
    }
}

+(LinphoneCallStatus)getLinphoneCallStatusWithString:(NSString*)linphoneCallStatusString {
    if ([linphoneCallStatusString isEqualToString:@"CallSuccess"]) {
        return LinphoneCallSuccess;
    } else if ([linphoneCallStatusString isEqualToString:@"CallAborted"]) {
        return LinphoneCallAborted;
    } else if ([linphoneCallStatusString isEqualToString:@"CallMissed"]) {
        return LinphoneCallMissed;
    } else if ([linphoneCallStatusString isEqualToString:@"CallDeclined"]) {
        return LinphoneCallDeclined;
    }
    
    return NULL;
}

@end
