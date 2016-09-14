//
//  TTChatInformation.m
//  HelloCordova
//
//  Created by Thien on 5/22/16.
//
//

#import "TTChatInformation.h"

#import "LinphoneHelper.h"

@implementation TTChatInformation

-(void)parseLinphoneCore:(LinphoneCore*)LC {
    self.chatEnabled = [NSNumber numberWithBool:linphone_core_chat_enabled(LC)];
    self.unreadTotalMessageCount = [NSNumber numberWithInt:[[LinphoneHelper instance] unreadTotalMessageCount]];
}

@end
