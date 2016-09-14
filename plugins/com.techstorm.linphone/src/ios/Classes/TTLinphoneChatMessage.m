//
//  TTLinphoneChatMessage.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneChatMessage.h"

@implementation TTLinphoneChatMessage

-(void)parseLinphoneChatMessage:(LinphoneChatMessage*)linphoneChatMessage {
    TTLinphoneChatMessageState* ttlinphoneChatMessageState = [[TTLinphoneChatMessageState alloc] init];
    [ttlinphoneChatMessageState parseLinphoneChatMessageState:linphone_chat_message_get_state(linphoneChatMessage)];
    self.chatMessageState = ttlinphoneChatMessageState;
    
    TTLinphoneAddress* ttfromlinphoneAddress = [[TTLinphoneAddress alloc] init];
    [ttfromlinphoneAddress parseLinphoneAddress:linphone_chat_message_get_from_address(linphoneChatMessage)];
    self.fromAddress = ttfromlinphoneAddress;
    
    TTLinphoneAddress* tttolinphoneAddress = [[TTLinphoneAddress alloc] init];
    [tttolinphoneAddress parseLinphoneAddress:linphone_chat_message_get_to_address(linphoneChatMessage)];
    self.toAddress = tttolinphoneAddress;
    
    const char* string = linphone_chat_message_get_external_body_url(linphoneChatMessage);
    if (string) {
        self.externalBodyUrl = [NSString stringWithUTF8String:string];
    }
    
    TTLinphoneContent *ttlinphoneContent = [[TTLinphoneContent alloc] init];
    [ttlinphoneContent parseLinphoneContent:linphone_chat_message_get_file_transfer_information(linphoneChatMessage)];
    self.content = ttlinphoneContent;
    
    self.isRead = [NSNumber numberWithBool:linphone_chat_message_is_read(linphoneChatMessage)];
    self.isOutgoing = [NSNumber numberWithBool:linphone_chat_message_is_outgoing(linphoneChatMessage)];
    self.storageId = [NSNumber numberWithUnsignedInteger:linphone_chat_message_get_storage_id(linphoneChatMessage)];
    self.storage = [NSNumber numberWithUnsignedInteger:linphone_chat_message_store(linphoneChatMessage)];
    
    TTLinphoneReason *ttlinphoneReason = [[TTLinphoneReason alloc] init];
    [ttlinphoneReason parseLinphoneReason:linphone_chat_message_get_reason(linphoneChatMessage)];
    self.reason = ttlinphoneReason;
    
    TTLinphoneErrorInfo *ttlinphoneErrorInfo = [[TTLinphoneErrorInfo alloc] init];
    [ttlinphoneErrorInfo parseLinphoneErrorInfo:linphone_chat_message_get_error_info(linphoneChatMessage)];
    self.errorInfo = ttlinphoneErrorInfo;
    
    string = linphone_chat_message_get_file_transfer_filepath(linphoneChatMessage);
    if (string) {
        self.fileTransferFilepath = [NSString stringWithUTF8String:string];
    }
        
    TTLinphoneAddress* ttlocallinphoneAddress = [[TTLinphoneAddress alloc] init];
    [ttlocallinphoneAddress parseLinphoneAddress:linphone_chat_message_get_local_address(linphoneChatMessage)];
    self.localAddress = ttlocallinphoneAddress;
    
    TTLinphoneChatRoom* ttlinphoneChatRoom = [[TTLinphoneChatRoom alloc] init];
    [ttlinphoneChatRoom parseLinphoneChatRoom:linphone_chat_message_get_chat_room(linphoneChatMessage)];
    self.chatRoom = ttlinphoneChatRoom;
    
    TTLinphoneAddress* ttpeerlinphoneAddress = [[TTLinphoneAddress alloc] init];
    [ttpeerlinphoneAddress parseLinphoneAddress:linphone_chat_message_get_peer_address(linphoneChatMessage)];
    self.peerAddress = ttpeerlinphoneAddress;
    
    string = linphone_chat_message_get_text(linphoneChatMessage);
    if (string) {
        self.text = [NSString stringWithUTF8String:string];
    }
    string = linphone_chat_message_get_appdata(linphoneChatMessage);
    if (string) {
        self.appdata = [NSString stringWithUTF8String:string];
    }
    self.time = [NSNumber numberWithLong:linphone_chat_message_get_time(linphoneChatMessage)];
    
    TTLinphoneChatMessageCbs *ttlinphoneChatMessageCbs = [[TTLinphoneChatMessageCbs alloc] init];
    [ttlinphoneChatMessageCbs parseLinphoneChatMessageCbs:linphone_chat_message_get_callbacks(linphoneChatMessage)];
    self.chatMessageCbs = ttlinphoneChatMessageCbs;
}

@end
