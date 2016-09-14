//
//  TTLinphoneChatRoom.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneChatRoom.h"

@implementation TTLinphoneChatRoom

-(void)parseLinphoneChatRoom:(LinphoneChatRoom*)linphoneChatRoom {
    self.isRemoteComposing = [NSNumber numberWithBool:linphone_chat_room_is_remote_composing(linphoneChatRoom)];
    self.unreadMessagesCount = [NSNumber numberWithInt:linphone_chat_room_get_unread_messages_count(linphoneChatRoom)];
    
    TTLinphoneAddress *ttlinphoneAddress = [[TTLinphoneAddress alloc] init];
    [ttlinphoneAddress parseLinphoneAddress:linphone_chat_room_get_peer_address(linphoneChatRoom)];
    self.peerAddress = ttlinphoneAddress;
    
    self.chatRoomString = [NSNumber numberWithUnsignedInteger:linphone_chat_room_get_char(linphoneChatRoom)];
    
    LinphoneCall* call = linphone_chat_room_get_call(linphoneChatRoom);
    if (call) {
        TTLinphoneCall* ttlinphoneCall = [[TTLinphoneCall alloc] init];
        [ttlinphoneCall parseLinphoneCall:call];
        self.call = ttlinphoneCall;
    }
    
    self.historySize = [NSNumber numberWithInt:linphone_chat_room_get_history_size(linphoneChatRoom)];
}

@end
