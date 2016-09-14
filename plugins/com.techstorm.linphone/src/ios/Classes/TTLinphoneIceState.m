//
//  TTLinphoneIceState.m
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import "TTLinphoneIceState.h"

@implementation TTLinphoneIceState

-(void)parseLinphoneIceState:(LinphoneIceState)linphoneIceState {
    if (linphoneIceState == LinphoneIceStateNotActivated) {
        self.iceState = @"IceStateNotActivated";
    } else if (linphoneIceState == LinphoneIceStateFailed) {
        self.iceState = @"IceStateFailed";
    } else if (linphoneIceState == LinphoneIceStateInProgress) {
        self.iceState = @"IceStateInProgress";
    } else if (linphoneIceState == LinphoneIceStateHostConnection) {
        self.iceState = @"IceStateHostConnection";
    } else if (linphoneIceState == LinphoneIceStateReflexiveConnection) {
        self.iceState = @"IceStateReflexiveConnection";
    } else if (linphoneIceState == LinphoneIceStateRelayConnection) {
        self.iceState = @"IceStateRelayConnection";
    }
    self.iceStateString = [NSString stringWithUTF8String:linphone_ice_state_to_string(linphoneIceState)];
}

+(LinphoneIceState)getLinphoneIceStateWithString:(NSString*)linphoneIceStateString {
    if ([linphoneIceStateString isEqualToString:@"IceStateNotActivated"]) {
        return LinphoneIceStateNotActivated;
    } else if ([linphoneIceStateString isEqualToString:@"IceStateFailed"]) {
        return LinphoneIceStateFailed;
    } else if ([linphoneIceStateString isEqualToString:@"IceStateInProgress"]) {
        return LinphoneIceStateInProgress;
    } else if ([linphoneIceStateString isEqualToString:@"IceStateHostConnection"]) {
        return LinphoneIceStateHostConnection;
    } else if ([linphoneIceStateString isEqualToString:@"IceStateReflexiveConnection"]) {
        return LinphoneIceStateReflexiveConnection;
    } else if ([linphoneIceStateString isEqualToString:@"IceStateRelayConnection"]) {
        return LinphoneIceStateRelayConnection;
    }
    return NULL;
}

@end
