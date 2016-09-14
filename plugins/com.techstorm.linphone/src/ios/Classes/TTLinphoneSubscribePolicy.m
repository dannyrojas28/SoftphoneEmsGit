//
//  LinphoneSubscribePolicy.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphoneSubscribePolicy.h"

@implementation TTLinphoneSubscribePolicy

-(void)parseLinphoneSubscribePolicy:(LinphoneSubscribePolicy)linphoneSubscribePolicy {
    if (linphoneSubscribePolicy == LinphoneSPWait) {
        self.subscribePolicy = @"SPWait";
    } else if (linphoneSubscribePolicy == LinphoneSPDeny) {
        self.subscribePolicy = @"SPDeny";
    } else if (linphoneSubscribePolicy == LinphoneSPAccept) {
        self.subscribePolicy = @"SPAccept";
    }
}
+(LinphoneSubscribePolicy)getLinphoneSubscribePolicyWithString:(NSString*)linphoneSubscribePolicyString {
    if ([linphoneSubscribePolicyString isEqualToString:@"SPWait"]) {
        return LinphoneSPWait;
    } else if ([linphoneSubscribePolicyString isEqualToString:@"SPDeny"]) {
        return LinphoneSPDeny;
    } else if ([linphoneSubscribePolicyString isEqualToString:@"SPAccept"]) {
        return LinphoneSPAccept;
    }
    return NULL;
}

@end
