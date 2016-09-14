//
//  TTLinphoneCallStats.h
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphoneIceState.h"
#import "TTLinphoneUpnpState.h"

@interface TTLinphoneCallStats : NSObject

@property (nonatomic, strong) NSNumber *senderLossRate; // float
@property (nonatomic, strong) NSNumber *receiverLossRate; // float
@property (nonatomic, strong) NSNumber *downloadBandwidth; // float
@property (nonatomic, strong) NSNumber *uploadBandwidth; // float
@property (nonatomic, strong) TTLinphoneIceState *iceState;
@property (nonatomic, strong) TTLinphoneUpnpState *upnpState;
//@property (nonatomic, strong) rtp_stats_t rtpStats;
@property (nonatomic, strong) NSNumber *senderInterarrivalJitter; // float
@property (nonatomic, strong) NSNumber *receiverInterarrivalJitter; // float
@property (nonatomic, strong) NSNumber *latePacketsCumulativeNumber; // unsigned long long



-(void)parseLinphoneCallStats:(const LinphoneCallStats*)linphoneCallStats;

@end
