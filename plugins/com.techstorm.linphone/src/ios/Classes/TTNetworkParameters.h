//
//  TTNetworkParameters.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTRange.h"
#import "TTLinphoneUpnpState.h"
#import "TTLinphoneFirewallPolicy.h"

@interface TTNetworkParameters : NSObject

@property (nonatomic, strong) NSNumber* audioPort; // int
@property (nonatomic, strong) NSNumber* videoPort; // int
@property (nonatomic, strong) NSNumber* textPort; // int
@property (nonatomic, strong) TTRange* audioPortRange;
@property (nonatomic, strong) TTRange* videoPortRange;
@property (nonatomic, strong) TTRange* textPortRange;

@property (nonatomic, strong) NSNumber* sipPort; // int
@property (nonatomic, strong) NSNumber* isIpv6Enabled; // BOOL
@property (nonatomic, strong) NSNumber* sipDscp; // int
@property (nonatomic, strong) NSNumber* audioDscp; // int
@property (nonatomic, strong) NSNumber* videoDscp; // int
@property (nonatomic, strong) NSString* stunServer;
@property (nonatomic, strong) NSNumber* isUpnpAvailable; // BOOL
@property (nonatomic, strong) TTLinphoneUpnpState* upnpState;
@property (nonatomic, strong) NSString* upnpExternalIpAddress;
@property (nonatomic, strong) NSString* natAddress;
@property (nonatomic, strong) TTLinphoneFirewallPolicy* firewallPolicy;
@property (nonatomic, strong) NSNumber* isNetworkReachable; // BOOL
@property (nonatomic, strong) NSNumber* keepAliveEnabled; // BOOL
@property (nonatomic, strong) NSNumber* isSdp200AckEnabled; // BOOL

@property (nonatomic, strong) NSNumber* udpPort; // int
@property (nonatomic, strong) NSNumber* tcpPort; // int
@property (nonatomic, strong) NSNumber* dtlsPort; // int
@property (nonatomic, strong) NSNumber* tlsPort; // int




-(void)parseLinphoneCore:(LinphoneCore*)LC;

@end
