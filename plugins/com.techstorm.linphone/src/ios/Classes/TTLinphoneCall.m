//
//  TTLinphoneCall.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneCall.h"

#import "Utils.h"

@implementation TTLinphoneCall

-(void)parseLinphoneCall:(LinphoneCall*)call {
    self.playVolume = [NSNumber numberWithFloat:linphone_call_get_play_volume(call)];
    self.recordVolume = [NSNumber numberWithFloat:linphone_call_get_record_volume(call)];
    self.speakerVolumeGain = [NSNumber numberWithFloat:linphone_call_get_speaker_volume_gain(call)];
    self.microphoneVolumeGain = [NSNumber numberWithFloat:linphone_call_get_microphone_volume_gain(call)];
    self.currentQuality = [NSNumber numberWithFloat:linphone_call_get_current_quality(call)];
    self.averageQuality = [NSNumber numberWithFloat:linphone_call_get_average_quality(call)];
    self.mediaInProgress = [NSNumber numberWithBool:linphone_call_media_in_progress(call)];
    self.echoCancellationEnabled = [NSNumber numberWithBool:linphone_call_echo_cancellation_enabled(call)];
    self.echoLimiterEnabled = [NSNumber numberWithBool:linphone_call_echo_limiter_enabled(call)];
    self.callParams = [self createDefaultCallParameters:call];
    
    TTCallLog* ttcallLog = [[TTCallLog alloc] init];
    [ttcallLog parseLinphoneCallLog:linphone_call_get_call_log(call)];
    self.callLog = ttcallLog;
    
}

-(TTLinphoneCallParams*) createDefaultCallParameters:(LinphoneCall*)call {
    TTLinphoneCallParams *ttlinphoneCallParams = [[TTLinphoneCallParams alloc] init];
    [ttlinphoneCallParams parseLinphoneCallParams:linphone_core_create_call_params(LC, call)];
    return ttlinphoneCallParams;
}

@end
