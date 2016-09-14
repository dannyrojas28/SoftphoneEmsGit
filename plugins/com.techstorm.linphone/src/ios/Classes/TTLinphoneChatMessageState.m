//
//  TTLinphoneChatMessageState.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneChatMessageState.h"

@implementation TTLinphoneChatMessageState

-(void)parseLinphoneChatMessageState:(LinphoneChatMessageState)linphoneChatMessageState {
    if (linphoneChatMessageState == LinphoneChatMessageStateIdle) {
        self.chatMessageState = @"ChatMessageStateIdle";
    } else if (linphoneChatMessageState == LinphoneChatMessageStateInProgress) {
        self.chatMessageState = @"ChatMessageStateInProgress";
    } else if (linphoneChatMessageState == LinphoneChatMessageStateDelivered) {
        self.chatMessageState = @"ChatMessageStateDelivered";
    } else if (linphoneChatMessageState == LinphoneChatMessageStateNotDelivered) {
        self.chatMessageState = @"ChatMessageStateNotDelivered";
    } else if (linphoneChatMessageState == LinphoneChatMessageStateFileTransferError) {
        self.chatMessageState = @"ChatMessageStateFileTransferError";
    } else if (linphoneChatMessageState == LinphoneChatMessageStateFileTransferDone) {
        self.chatMessageState = @"ChatMessageStateFileTransferDone";
    }
    
    self.chatMessageStateString = [NSString stringWithUTF8String:linphone_chat_message_state_to_string(linphoneChatMessageState)];
}
+(LinphoneChatMessageState)getLinphoneChatMessageStateWithString:(NSString*)linphoneChatMessageStateString {
    if ([linphoneChatMessageStateString isEqualToString:@"ChatMessageStateIdle"]) {
        return LinphoneChatMessageStateIdle;
    } else if ([linphoneChatMessageStateString isEqualToString:@"ChatMessageStateInProgress"]) {
        return LinphoneChatMessageStateInProgress;
    } else if ([linphoneChatMessageStateString isEqualToString:@"ChatMessageStateDelivered"]) {
        return LinphoneChatMessageStateDelivered;
    } else if ([linphoneChatMessageStateString isEqualToString:@"ChatMessageStateNotDelivered"]) {
        return LinphoneChatMessageStateNotDelivered;
    } else if ([linphoneChatMessageStateString isEqualToString:@"ChatMessageStateFileTransferError"]) {
        return LinphoneChatMessageStateFileTransferError;
    } else if ([linphoneChatMessageStateString isEqualToString:@"ChatMessageStateFileTransferDone"]) {
        return LinphoneChatMessageStateFileTransferDone;
    }
    return NULL;
}

@end
