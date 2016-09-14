//
//  TTLinphoneChatMessage.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphoneChatMessageState.h"
#import "TTLinphoneAddress.h"
#import "TTLinphoneContent.h"
#import "TTLinphoneReason.h"
#import "TTLinphoneErrorInfo.h"
#import "TTLinphoneChatRoom.h"
#import "TTLinphoneChatMessageCbs.h"

@interface TTLinphoneChatMessage : NSObject

@property (nonatomic, strong) TTLinphoneChatMessageState *chatMessageState;
@property (nonatomic, strong) TTLinphoneAddress *fromAddress;
@property (nonatomic, strong) TTLinphoneAddress *toAddress;
@property (nonatomic, strong) NSString *externalBodyUrl;
@property (nonatomic, strong) TTLinphoneContent *content;
@property (nonatomic, strong) NSNumber *isRead; //BOOL
@property (nonatomic, strong) NSNumber *isOutgoing; //BOOL
@property (nonatomic, strong) NSNumber *storageId; //unsigned int
@property (nonatomic, strong) NSNumber *storage; //unsigned int
@property (nonatomic, strong) TTLinphoneReason *reason;
@property (nonatomic, strong) TTLinphoneErrorInfo *errorInfo;
@property (nonatomic, strong) NSString *fileTransferFilepath;
@property (nonatomic, strong) TTLinphoneAddress *localAddress;
@property (nonatomic, strong) TTLinphoneChatRoom *chatRoom;
@property (nonatomic, strong) TTLinphoneAddress *peerAddress;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *appdata;
@property (nonatomic, strong) NSNumber *time; // long
@property (nonatomic, strong) TTLinphoneChatMessageCbs *chatMessageCbs;



-(void)parseLinphoneChatMessage:(LinphoneChatMessage*)linphoneChatMessage;

@end
