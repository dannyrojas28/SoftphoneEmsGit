//
//  TTLinphoneFriend.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphoneFriend.h"

@implementation TTLinphoneFriend

-(void)parseLinphoneFriend:(LinphoneFriend*)linphoneFriend {
    const char* string = linphone_friend_get_name(linphoneFriend);
    if (string) {
        self.name = [NSString stringWithUTF8String:string];
    }
    self.subscribesEnable = [NSNumber numberWithBool:linphone_friend_subscribes_enabled(linphoneFriend)];
    
    TTLinphoneSubscribePolicy *ttlinphoneSubscribePolicy = [[TTLinphoneSubscribePolicy alloc] init];
    [ttlinphoneSubscribePolicy parseLinphoneSubscribePolicy:linphone_friend_get_inc_subscribe_policy(linphoneFriend)];
    self.subscribePolicy = ttlinphoneSubscribePolicy;
    
//    TTLinphonePresenceModel *ttlinphonePresenceModel = [[TTLinphonePresenceModel alloc] init];
//    [ttlinphonePresenceModel parseLinphonePresenceModel:linphone_friend_get_presence_model(linphoneFriend)];
//    self.presenceModel = ttlinphonePresenceModel;
    
//    self.buddyInfo = *(linphone_friend_get_info(linphoneFriend));
    self.isInList = [NSNumber numberWithBool:linphone_friend_in_list(linphoneFriend)];
    
    TTLinphoneAddress* ttlinphoneAddress = [[TTLinphoneAddress alloc] init];
    [ttlinphoneAddress parseLinphoneAddress:linphone_friend_get_address(linphoneFriend)];
    self.address = ttlinphoneAddress;
}

@end
