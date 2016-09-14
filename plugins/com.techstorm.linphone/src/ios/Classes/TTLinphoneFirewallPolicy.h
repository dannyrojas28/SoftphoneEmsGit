//
//  TTLinphoneFirewallPolicy.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneFirewallPolicy : NSObject

@property (nonatomic, strong) NSString* firewallPolicy;

-(void)parseLinphoneFirewallPolicy:(LinphoneFirewallPolicy)linphoneFirewallPolicy;
+(LinphoneFirewallPolicy)getLinphoneFirewallPolicyWithString:(NSString*)linphoneFirewallPolicyString;

@end
