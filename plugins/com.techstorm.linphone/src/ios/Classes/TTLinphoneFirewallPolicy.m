//
//  TTLinphoneFirewallPolicy.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneFirewallPolicy.h"

@implementation TTLinphoneFirewallPolicy

-(void)parseLinphoneFirewallPolicy:(LinphoneFirewallPolicy)linphoneFirewallPolicy {
    if (linphoneFirewallPolicy == LinphonePolicyNoFirewall) {
        self.firewallPolicy = @"PolicyNoFirewall";
    } else if (linphoneFirewallPolicy == LinphonePolicyUseNatAddress) {
        self.firewallPolicy = @"PolicyUseNatAddress";
    } else if (linphoneFirewallPolicy == LinphonePolicyUseStun) {
        self.firewallPolicy = @"PolicyUseStun";
    } else if (linphoneFirewallPolicy == LinphonePolicyUseIce) {
        self.firewallPolicy = @"PolicyUseIce";
    } else if (linphoneFirewallPolicy == LinphonePolicyUseUpnp) {
        self.firewallPolicy = @"PolicyUseUpnp";
    }
}
+(LinphoneFirewallPolicy)getLinphoneFirewallPolicyWithString:(NSString*)linphoneFirewallPolicyString {
    if ([linphoneFirewallPolicyString isEqualToString:@"PolicyNoFirewall"]) {
        return LinphonePolicyNoFirewall;
    } else if ([linphoneFirewallPolicyString isEqualToString:@"PolicyUseNatAddress"]) {
        return LinphonePolicyUseNatAddress;
    } else if ([linphoneFirewallPolicyString isEqualToString:@"PolicyUseStun"]) {
        return LinphonePolicyUseStun;
    } else if ([linphoneFirewallPolicyString isEqualToString:@"PolicyUseIce"]) {
        return LinphonePolicyUseIce;
    } else if ([linphoneFirewallPolicyString isEqualToString:@"PolicyUseUpnp"]) {
        return LinphonePolicyUseUpnp;
    }
    return NULL;
}

@end
