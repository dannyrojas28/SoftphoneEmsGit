//
//  TTLinphoneChatMessageCbs.h
//  HelloCordova
//
//  Created by Thien on 5/22/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneChatMessageCbs : NSObject

//@property (nonatomic, strong) LinphoneChatMessageCbsMsgStateChangedCb msgStateChangedCb;
//@property (nonatomic, strong) LinphoneChatMessageCbsFileTransferRecvCb fileTransferRecvCb;
//@property (nonatomic, strong) LinphoneChatMessageCbsFileTransferSendCb fileTransferSendCb;
//@property (nonatomic, strong) LinphoneChatMessageCbsFileTransferProgressIndicationCb fileTransferProgressIndicationCb;

-(void)parseLinphoneChatMessageCbs:(LinphoneChatMessageCbs*)linphoneChatMessageCbs;

@end
