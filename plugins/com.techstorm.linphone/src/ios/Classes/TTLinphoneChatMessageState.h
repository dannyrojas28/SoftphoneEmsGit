//
//  TTLinphoneChatMessageState.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>
#include "linphone/linphonecore.h"

@interface TTLinphoneChatMessageState : NSObject

@property (nonatomic, strong) NSString* chatMessageState;
@property (nonatomic, strong) NSString* chatMessageStateString;

-(void)parseLinphoneChatMessageState:(LinphoneChatMessageState)linphoneChatMessageState;
+(LinphoneChatMessageState)getLinphoneChatMessageStateWithString:(NSString*)linphoneChatMessageStateString;

@end
