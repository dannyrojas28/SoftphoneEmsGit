//
//  TTLinphoneReason.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneReason.h"

@implementation TTLinphoneReason

-(void)parseLinphoneReason:(LinphoneReason)linphoneReason{
    if (linphoneReason == LinphoneReasonNone) {
        self.reason = @"ReasonNone";
    } else if (linphoneReason == LinphoneReasonNoResponse) {
        self.reason = @"ReasonNoResponse";
    } else if (linphoneReason == LinphoneReasonForbidden) {
        self.reason = @"ReasonForbidden";
    } else if (linphoneReason == LinphoneReasonDeclined) {
        self.reason = @"ReasonDeclined";
    } else if (linphoneReason == LinphoneReasonNotFound) {
        self.reason = @"ReasonNotFound";
    } else if (linphoneReason == LinphoneReasonNotAnswered) {
        self.reason = @"ReasonNotAnswered";
    } else if (linphoneReason == LinphoneReasonBusy) {
        self.reason = @"ReasonBusy";
    } else if (linphoneReason == LinphoneReasonUnsupportedContent) {
        self.reason = @"ReasonUnsupportedContent";
    } else if (linphoneReason == LinphoneReasonIOError) {
        self.reason = @"ReasonIOError";
    } else if (linphoneReason == LinphoneReasonDoNotDisturb) {
        self.reason = @"ReasonDoNotDisturb";
    } else if (linphoneReason == LinphoneReasonUnauthorized) {
        self.reason = @"ReasonUnauthorized";
    } else if (linphoneReason == LinphoneReasonNotAcceptable) {
        self.reason = @"ReasonNotAcceptable";
    } else if (linphoneReason == LinphoneReasonNoMatch) {
        self.reason = @"ReasonNoMatch";
    } else if (linphoneReason == LinphoneReasonMovedPermanently) {
        self.reason = @"ReasonMovedPermanently";
    } else if (linphoneReason == LinphoneReasonGone) {
        self.reason = @"ReasonGone";
    } else if (linphoneReason == LinphoneReasonTemporarilyUnavailable) {
        self.reason = @"ReasonTemporarilyUnavailable";
    } else if (linphoneReason == LinphoneReasonAddressIncomplete) {
        self.reason = @"ReasonAddressIncomplete";
    } else if (linphoneReason == LinphoneReasonNotImplemented) {
        self.reason = @"ReasonNotImplemented";
    } else if (linphoneReason == LinphoneReasonBadGateway) {
        self.reason = @"ReasonBadGateway";
    } else if (linphoneReason == LinphoneReasonServerTimeout) {
        self.reason = @"ReasonServerTimeout";
    } else if (linphoneReason == LinphoneReasonUnknown) {
        self.reason = @"ReasonUnknown";
    }
}

+(LinphoneReason)getLinphoneReasonWithString:(NSString*)linphoneReasonString {
    if ([linphoneReasonString isEqualToString:@"ReasonNone"]) {
        return LinphoneReasonNone;
    } else if ([linphoneReasonString isEqualToString:@"ReasonNoResponse"]) {
        return LinphoneReasonNoResponse;
    } else if ([linphoneReasonString isEqualToString:@"ReasonForbidden"]) {
        return LinphoneReasonForbidden;
    } else if ([linphoneReasonString isEqualToString:@"ReasonDeclined"]) {
        return LinphoneReasonDeclined;
    } else if ([linphoneReasonString isEqualToString:@"ReasonNotFound"]) {
        return LinphoneReasonNotFound;
    } else if ([linphoneReasonString isEqualToString:@"ReasonNotAnswered"]) {
        return LinphoneReasonNotAnswered;
    } else if ([linphoneReasonString isEqualToString:@"ReasonBusy"]) {
        return LinphoneReasonBusy;
    } else if ([linphoneReasonString isEqualToString:@"ReasonUnsupportedContent"]) {
        return LinphoneReasonUnsupportedContent;
    } else if ([linphoneReasonString isEqualToString:@"ReasonIOError"]) {
        return LinphoneReasonIOError;
    } else if ([linphoneReasonString isEqualToString:@"ReasonDoNotDisturb"]) {
        return LinphoneReasonDoNotDisturb;
    } else if ([linphoneReasonString isEqualToString:@"ReasonUnauthorized"]) {
        return LinphoneReasonUnauthorized;
    } else if ([linphoneReasonString isEqualToString:@"ReasonNotAcceptable"]) {
        return LinphoneReasonNotAcceptable;
    } else if ([linphoneReasonString isEqualToString:@"ReasonNoMatch"]) {
        return LinphoneReasonNoMatch;
    } else if ([linphoneReasonString isEqualToString:@"ReasonMovedPermanently"]) {
        return LinphoneReasonMovedPermanently;
    } else if ([linphoneReasonString isEqualToString:@"ReasonGone"]) {
        return LinphoneReasonGone;
    } else if ([linphoneReasonString isEqualToString:@"ReasonTemporarilyUnavailable"]) {
        return LinphoneReasonTemporarilyUnavailable;
    } else if ([linphoneReasonString isEqualToString:@"ReasonAddressIncomplete"]) {
        return LinphoneReasonAddressIncomplete;
    } else if ([linphoneReasonString isEqualToString:@"ReasonNotImplemented"]) {
        return LinphoneReasonNotImplemented;
    } else if ([linphoneReasonString isEqualToString:@"ReasonBadGateway"]) {
        return LinphoneReasonBadGateway;
    } else if ([linphoneReasonString isEqualToString:@"ReasonServerTimeout"]) {
        return LinphoneReasonServerTimeout;
    } else if ([linphoneReasonString isEqualToString:@"ReasonUnknown"]) {
        return LinphoneReasonUnknown;
    }
    return NULL;
}

@end
