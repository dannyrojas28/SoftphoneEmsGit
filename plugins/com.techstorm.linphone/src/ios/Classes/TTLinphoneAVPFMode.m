//
//  TTLinphoneAVPFMode.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneAVPFMode.h"

@implementation TTLinphoneAVPFMode

-(void)parseLinphoneAVPFMode:(LinphoneAVPFMode)linphoneAVPFMode {
    if (linphoneAVPFMode == LinphoneAVPFDefault) {
        self.avpfMode = @"AVPFDefault";
    } else if (linphoneAVPFMode == LinphoneAVPFDisabled) {
        self.avpfMode = @"AVPFDisabled";
    } else if (linphoneAVPFMode == LinphoneAVPFEnabled) {
        self.avpfMode = @"AVPFEnabled";
    }
}

+(LinphoneAVPFMode)getLinphoneAVPFModeWithString:(NSString*)linphoneAVPFModeString {
    if ([linphoneAVPFModeString isEqualToString:@"AVPFDefault"]) {
        return LinphoneAVPFDefault;
    } else if ([linphoneAVPFModeString isEqualToString:@"AVPFDisabled"]) {
        return LinphoneAVPFDisabled;
    } else if ([linphoneAVPFModeString isEqualToString:@"AVPFEnabled"]) {
        return LinphoneAVPFEnabled;
    }
    return NULL;
}

@end
