//
//  TTLinphoneFriend.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphoneSubscribePolicy.h"
#import "TTLinphonePresenceModel.h"
#import "TTLinphoneAddress.h"

@interface TTLinphoneFriend : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSNumber* subscribesEnable; // BOOL
@property (nonatomic, strong) TTLinphoneSubscribePolicy* subscribePolicy;
//@property (nonatomic, strong) TTLinphonePresenceModel* presenceModel;
//@property (nonatomic, strong) BuddyInfo buddyInfo;
@property (nonatomic, strong) NSNumber* isInList; // BOOL
@property (nonatomic, strong) TTLinphoneAddress* address;


-(void)parseLinphoneFriend:(LinphoneFriend*)linphoneFriend;

@end
