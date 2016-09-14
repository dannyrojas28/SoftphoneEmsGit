//
//  TTCallLog.m
//  HelloCordova
//
//  Created by Thien on 5/14/16.
//
//

#import "TTCallLog.h"

@implementation TTCallLog


-(void)parseLinphoneCallLog:(LinphoneCallLog*)linphoneCallLog {
    LinphoneAddress* fromAddress = linphone_call_log_get_from_address(linphoneCallLog);
    TTLinphoneAddress* ttfromLinphoneAddress = [[TTLinphoneAddress alloc] init];
    [ttfromLinphoneAddress parseLinphoneAddress:fromAddress];
    self.fromAddress = ttfromLinphoneAddress;
    
    LinphoneAddress* toAddress = linphone_call_log_get_to_address(linphoneCallLog);
    TTLinphoneAddress* tttoLinphoneAddress = [[TTLinphoneAddress alloc] init];
    [tttoLinphoneAddress parseLinphoneAddress:toAddress];
    self.toAddress = tttoLinphoneAddress;
    
    self.duration = [NSNumber numberWithInteger:linphone_call_log_get_duration(linphoneCallLog)];
    TTLinphoneCallDir* ttlinphoneCallDir = [[TTLinphoneCallDir alloc] init];
    [ttlinphoneCallDir parseLinphoneCallDirection:linphone_call_log_get_dir(linphoneCallLog)];
    self.callDir = ttlinphoneCallDir;
    
    self.callId = [NSString stringWithUTF8String:linphone_call_log_get_call_id(linphoneCallLog)];
//    const rtp_stats_t* localStats = linphone_call_log_get_local_stats(linphoneCallLog);
    self.quality = [NSNumber numberWithFloat:linphone_call_log_get_quality(linphoneCallLog)];
//    self.refKey = [NSString stringWithUTF8String:linphone_call_log_get_ref_key(linphoneCallLog)];
    
    LinphoneAddress* remoteAddress = linphone_call_log_get_remote_address(linphoneCallLog);
    TTLinphoneAddress* ttremoteLinphoneAddress = [[TTLinphoneAddress alloc] init];
    [ttremoteLinphoneAddress parseLinphoneAddress:remoteAddress];
    self.remoteAddress = ttremoteLinphoneAddress;
    
//    const rtp_stats_t* remoteStats = linphone_call_log_get_remote_stats(linphoneCallLog);
    self.startDate = [NSDate dateWithTimeIntervalSince1970:linphone_call_log_get_start_date(linphoneCallLog)];
    LinphoneCallStatus callStatus = linphone_call_log_get_status(linphoneCallLog);
    TTLinphoneCallStatus* ttlinphoneCallStatus = [[TTLinphoneCallStatus alloc] init];
    [ttlinphoneCallStatus parseLinphoneCallStatus:callStatus];
    self.callStatus = ttlinphoneCallStatus;
    
    self.callLogStr = [NSString stringWithUTF8String:linphone_call_log_to_str(linphoneCallLog)];
    self.videoEnabled = [NSNumber numberWithBool:linphone_call_log_video_enabled(linphoneCallLog)];
    self.wasConference = [NSNumber numberWithBool:linphone_call_log_was_conference(linphoneCallLog)];
}

@end
