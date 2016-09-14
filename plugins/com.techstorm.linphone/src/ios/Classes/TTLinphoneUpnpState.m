//
//  TTLinphoneUpnpState.m
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import "TTLinphoneUpnpState.h"

@implementation TTLinphoneUpnpState

-(void)parseLinphoneUpnpState:(LinphoneUpnpState)linphoneUpnpState {
    if (linphoneUpnpState == LinphoneUpnpStateIdle) {
        self.upnpState = @"UpnpStateIdle";
    } else if (linphoneUpnpState == LinphoneUpnpStatePending) {
        self.upnpState = @"UpnpStatePending";
    } else if (linphoneUpnpState == LinphoneUpnpStateAdding) {
        self.upnpState = @"UpnpStateAdding";
    } else if (linphoneUpnpState == LinphoneUpnpStateRemoving) {
        self.upnpState = @"UpnpStateRemoving";
    } else if (linphoneUpnpState == LinphoneUpnpStateNotAvailable) {
        self.upnpState = @"UpnpStateNotAvailable";
    } else if (linphoneUpnpState == LinphoneUpnpStateOk) {
        self.upnpState = @"UpnpStateOk";
    } else if (linphoneUpnpState == LinphoneUpnpStateKo) {
        self.upnpState = @"UpnpStateKo";
    } else if (linphoneUpnpState == LinphoneUpnpStateBlacklisted) {
        self.upnpState = @"UpnpStateBlacklisted";
    }
}

+(LinphoneUpnpState)getLinphoneUpnpStateWithString:(NSString*)LinphoneUpnpStateString {
    if ([LinphoneUpnpStateString isEqualToString:@"UpnpStateIdle"]) {
        return LinphoneUpnpStateIdle;
    } else if ([LinphoneUpnpStateString isEqualToString:@"UpnpStatePending"]) {
        return LinphoneUpnpStatePending;
    } else if ([LinphoneUpnpStateString isEqualToString:@"UpnpStateAdding"]) {
        return LinphoneUpnpStateAdding;
    } else if ([LinphoneUpnpStateString isEqualToString:@"UpnpStateRemoving"]) {
        return LinphoneUpnpStateRemoving;
    } else if ([LinphoneUpnpStateString isEqualToString:@"UpnpStateNotAvailable"]) {
        return LinphoneUpnpStateNotAvailable;
    } else if ([LinphoneUpnpStateString isEqualToString:@"UpnpStateOk"]) {
        return LinphoneUpnpStateOk;
    } else if ([LinphoneUpnpStateString isEqualToString:@"UpnpStateKo"]) {
        return LinphoneUpnpStateKo;
    } else if ([LinphoneUpnpStateString isEqualToString:@"UpnpStateBlacklisted"]) {
        return LinphoneUpnpStateBlacklisted;
    }
    return NULL;
}

@end
