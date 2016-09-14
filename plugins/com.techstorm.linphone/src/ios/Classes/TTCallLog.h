//
//  TTCallLog.h
//  HelloCordova
//
//  Created by Thien on 5/14/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"
#import "TTLinphoneAddress.h"
#import "TTLinphoneCallStatus.h"
#import "TTLinphoneCallDir.h"


@interface TTCallLog : NSObject

@property (nonatomic, strong) TTLinphoneAddress* fromAddress;
@property (nonatomic, strong) TTLinphoneAddress* toAddress;
@property (nonatomic, strong) NSNumber *duration; // int
@property (nonatomic, strong) TTLinphoneCallDir* callDir;
@property (nonatomic, strong) NSString *callId;
//@property (nonatomic, strong) const rtp_stats_t* localStats;
@property (nonatomic, strong) NSNumber *quality; // float
//@property (nonatomic, strong) NSString *refKey;
@property (nonatomic, strong) TTLinphoneAddress* remoteAddress;
//@property (nonatomic, strong) const rtp_stats_t* remoteStats;
@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) TTLinphoneCallStatus* callStatus;
@property (nonatomic, strong) NSString *callLogStr;
@property (nonatomic, strong) NSNumber *videoEnabled; // BOOL
@property (nonatomic, strong) NSNumber *wasConference; // BOOL

-(void)parseLinphoneCallLog:(LinphoneCallLog*)linphoneCallLog;

@end
