//
//  LinphoneSubscribePolicy.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneSubscribePolicy : NSObject

@property (nonatomic, strong) NSString* subscribePolicy;

-(void)parseLinphoneSubscribePolicy:(LinphoneSubscribePolicy)linphoneSubscribePolicy;
+(LinphoneSubscribePolicy)getLinphoneSubscribePolicyWithString:(NSString*)linphoneSubscribePolicyString;

@end
