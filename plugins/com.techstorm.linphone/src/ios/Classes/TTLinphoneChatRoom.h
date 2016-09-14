//
//  TTLinphoneChatRoom.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphoneAddress.h"
#import "TTLinphoneCall.h"

@interface TTLinphoneChatRoom : NSObject

@property (nonatomic, strong) NSNumber *isRemoteComposing; // BOOL
@property (nonatomic, strong) NSNumber *unreadMessagesCount; // int
@property (nonatomic, strong) TTLinphoneAddress *peerAddress;
@property (nonatomic, strong) NSNumber *chatRoomString; // unsigned int
@property (nonatomic, strong) TTLinphoneCall *call;
@property (nonatomic, strong) NSNumber *historySize; // int

-(void)parseLinphoneChatRoom:(LinphoneChatRoom*)linphoneChatRoom;

@end
