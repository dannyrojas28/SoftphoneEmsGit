//
//  TTLinphoneCallStats.m
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import "Utils.h"
#import "TTLinphoneCallStats.h"


@implementation TTLinphoneCallStats

-(void)parseLinphoneCallStats:(const LinphoneCallStats*)linphoneCallStats {
    self.senderLossRate = [NSNumber numberWithFloat:linphone_call_stats_get_sender_loss_rate(linphoneCallStats)];
    self.receiverLossRate = [NSNumber numberWithFloat:linphone_call_stats_get_receiver_loss_rate(linphoneCallStats)];
    self.downloadBandwidth = [NSNumber numberWithFloat:linphone_call_stats_get_download_bandwidth(linphoneCallStats)];
    self.uploadBandwidth = [NSNumber numberWithFloat:linphone_call_stats_get_upload_bandwidth(linphoneCallStats)];
    
    TTLinphoneIceState *ttlinphoneIceState = [[TTLinphoneIceState alloc] init];
    [ttlinphoneIceState parseLinphoneIceState:linphone_call_stats_get_ice_state(linphoneCallStats)];
    self.iceState = ttlinphoneIceState;
    
    TTLinphoneUpnpState *ttlinphoneUpnpState = [[TTLinphoneUpnpState alloc] init];
    [ttlinphoneUpnpState parseLinphoneUpnpState:linphone_call_stats_get_upnp_state(linphoneCallStats)];
    self.upnpState = ttlinphoneUpnpState;
    
//    self.rtpStats = linphone_call_stats_get_rtp_stats(linphoneCallStats);
    
    LinphoneCall *call = linphone_core_get_current_call(LC);
    self.senderInterarrivalJitter = [NSNumber numberWithFloat:linphone_call_stats_get_sender_interarrival_jitter(linphoneCallStats, call)];
    self.receiverInterarrivalJitter = [NSNumber numberWithFloat:linphone_call_stats_get_receiver_interarrival_jitter(linphoneCallStats, call)];
    self.latePacketsCumulativeNumber = [NSNumber numberWithUnsignedLongLong:linphone_call_stats_get_late_packets_cumulative_number(linphoneCallStats, call)];
    
}

@end
