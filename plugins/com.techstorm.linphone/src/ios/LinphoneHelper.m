//
//  LinphoneHelper.m
//  HelloCordova
//
//  Created by Apple on 4/23/16.
//
//

#import "LinphoneHelper.h"

#import "Utils.h"

static LinphoneHelper *theLinphoneHelper = nil;

@implementation LinphoneHelper

+ (LinphoneHelper *)instance {
    @synchronized(self) {
        if (theLinphoneHelper == nil) {
            theLinphoneHelper = [[LinphoneHelper alloc] init];
        }
    }
    return theLinphoneHelper;
}

- (void) startListener {
    // nothing
}

- (void) initLinphoneCore {
    [[LinphoneManager instance] startLinphoneCore];
}
- (void) destroyLinphoneCore {
    [[LinphoneManager instance] destroyLinphoneCore];
}
- (void) registerSIPWithUsername:(NSString*)username displayName:(NSString*)displayName domain:(NSString*)domain password:(NSString*)password transport:(NSString*)transport {
    LinphoneProxyConfig *cfg = linphone_core_create_proxy_config(LC);
    char *identity_str = ms_strdup_printf("sip:%s@%s", username.UTF8String, domain.UTF8String);
    LinphoneAddress *identity = linphone_address_new(identity_str);
    if (displayName.UTF8String) {
        linphone_address_set_display_name(identity, displayName.UTF8String);
        }

    linphone_proxy_config_set_identity(cfg, linphone_address_as_string(identity));
    linphone_proxy_config_set_server_addr(cfg, domain.UTF8String);
//    linphone_proxy_config_set_route(cfg, creator->route);
    linphone_proxy_config_enable_publish(cfg, FALSE);
    linphone_proxy_config_enable_register(cfg, TRUE);
    ms_free(identity_str);
    
    if (strcmp(domain.UTF8String, "sip.linphone.org") == 0) {
        linphone_proxy_config_enable_avpf(cfg, TRUE);
        // If account created on sip.linphone.org, we configure linphone to use TLS by default
        if (linphone_core_sip_transport_supported(LC, LinphoneTransportTls)) {
            LinphoneAddress *addr = linphone_address_new(linphone_proxy_config_get_server_addr(cfg));
            char *tmp;
            linphone_address_set_transport(addr, LinphoneTransportTls);
            tmp = linphone_address_as_string(addr);
            linphone_proxy_config_set_server_addr(cfg, tmp);
            linphone_proxy_config_set_route(cfg, tmp);
            ms_free(tmp);
            linphone_address_destroy(addr);
            }
        linphone_core_set_stun_server(LC, "stun.linphone.org");
        linphone_core_set_firewall_policy(LC, LinphonePolicyUseIce);
    }

    LinphoneAuthInfo* info = linphone_auth_info_new(linphone_address_get_username(identity), NULL, password.UTF8String, NULL, NULL, linphone_address_get_domain(identity));
    linphone_core_add_auth_info(LC, info);
    linphone_address_destroy(identity);
    
    if (linphone_core_add_proxy_config(LC, cfg) != -1) {
        linphone_core_set_default_proxy(LC, cfg);
        return;
    }
    
    linphone_core_remove_auth_info(LC, info);
    linphone_proxy_config_unref(cfg);
}

- (void) deregisterSIPWithUsername:(NSString*)username domain:(NSString*)domain {
    // remove previous proxy config, if any
    
    NSMutableArray *new_configs = [LinphoneHelper findAuthIndexOf:username domain:domain];
    for (int index = 0; index < new_configs.count; index++) {
        const MSList *proxyConfigList = linphone_core_get_proxy_config_list(LC);
        NSNumber* number = (NSNumber*)[new_configs objectAtIndex:index];
        LinphoneProxyConfig *new_config = ms_list_nth_data(proxyConfigList, [number integerValue]);
        if (new_config != NULL) {
            const LinphoneAuthInfo *auth = linphone_proxy_config_find_auth_info(new_config);
            linphone_core_remove_proxy_config(LC, new_config);
            if (auth) {
                linphone_core_remove_auth_info(LC, auth);
            }
        }
    }
    
}
- (bool) getRegisterStatusSIPWithUsername:(NSString*)username domain:(NSString*)domain {
    NSMutableArray *new_configs = [LinphoneHelper findAuthIndexOf:username domain:domain];
    for (int index = 0; index < new_configs.count; index++) {
        const MSList *proxyConfigList = linphone_core_get_proxy_config_list(LC);
        NSNumber* number = (NSNumber*)[new_configs objectAtIndex:index];
        LinphoneProxyConfig *new_config = ms_list_nth_data(proxyConfigList, [number integerValue]);
        if (new_config != NULL) {
            return linphone_proxy_config_is_registered(new_config);
        }
    }
    return FALSE;
}
- (void) makeCallWithUsername:(NSString*)username domain:(NSString*)domain displayName:(NSString*)displayName {
    LinphoneAddress *addr = [TTLinphoneAddress getLinphoneAddressWithUsername:username domain:domain];
    [LinphoneManager.instance call:addr];
    if (addr)
        linphone_address_destroy(addr);
}
- (void) acceptCall {
    LinphoneCall *call = linphone_core_get_current_call(LC);
    if (call) {
        [[LinphoneManager instance] acceptCall:call evenWithVideo:NO];
    }
}
- (void) declineCall {
    LinphoneCall *call = linphone_core_get_current_call(LC);
    linphone_core_terminate_call(LC, call);
}

- (int) getVolumeMax {
    // nothing
    return 0;
}
- (void) volume:(int)volume {
    // nothing
}
- (void) terminateCall:(LinphoneCall*)call {
    if (linphone_core_is_in_conference(LC) ||										   // In conference
        (linphone_core_get_conference_size(LC) > 0) // Only one conf
        ) {
        linphone_core_terminate_conference(LC);
    } else if (call != NULL) { // In a call
        linphone_core_terminate_call(LC, call);
    } else {
        const MSList *calls = linphone_core_get_calls(LC);
        if (ms_list_size(calls) == 1) { // Only one call
            linphone_core_terminate_call(LC, (LinphoneCall *)(calls->data));
        }
    }
}
- (void) muteCall {
    linphone_core_enable_mic(LC, FALSE);
}
- (void) unmuteCall {
    linphone_core_enable_mic(LC, TRUE);
}
- (void) enableSpeaker {
    [[LinphoneManager instance] setSpeakerEnabled:TRUE];
}
- (void) disableSpeaker {
    [[LinphoneManager instance] setSpeakerEnabled:FALSE];
}
- (void) holdCall:(LinphoneCall*)call {
    if (linphone_core_is_in_conference(LC) ||										   // In conference
        (linphone_core_get_conference_size(LC) > 0) // Only one conf
        ) {
        linphone_core_leave_conference(LC);
    } else if (call != NULL) { // In a call
        linphone_core_pause_call(LC, call);
    } else {
        const MSList *calls = linphone_core_get_calls(LC);
        if (ms_list_size(calls) == 1) { // Only one call
            linphone_core_pause_call(LC, (LinphoneCall *)(calls->data));
        }
    }
}
- (void) unholdCall:(LinphoneCall*)call {
    if (linphone_core_is_in_conference(LC) ||										   // In conference
        (linphone_core_get_conference_size(LC) > 0) // Only one conf
        ) {
        linphone_core_enter_conference(LC);
    } else if (call != NULL) { // In a call
        linphone_core_resume_call(LC, call);
    } else {
        const MSList *calls = linphone_core_get_calls(LC);
        if (ms_list_size(calls) == 1) { // Only one call
            linphone_core_resume_call(LC, (LinphoneCall *)(calls->data));
        }
    }
}

#pragma mark - Obtaining information about a running call: sound volumes, quality indicators Functions

-(LinphoneCall*) getCurrentCall {
    return linphone_core_get_current_call(LC);
}

-(void) setSpeakerVolumeGain:(LinphoneCall*)call volume:(int)volume {
    linphone_call_set_speaker_volume_gain(call, volume);
}

-(void) setMicrophoneVolumeGain:(LinphoneCall*)call volume:(int)volume {
    linphone_call_set_microphone_volume_gain(call, volume);
}

-(TTLinphoneCallStats*) getAudioStats:(LinphoneCall*)call {
    TTLinphoneCallStats *ttlinphoneCallStats = [[TTLinphoneCallStats alloc] init];
    [ttlinphoneCallStats parseLinphoneCallStats:linphone_call_get_audio_stats(call)];
    return ttlinphoneCallStats;
}

-(TTLinphoneCallStats*) getVideoStats:(LinphoneCall*)call {
    TTLinphoneCallStats *ttlinphoneCallStats = [[TTLinphoneCallStats alloc] init];
    [ttlinphoneCallStats parseLinphoneCallStats:linphone_call_get_video_stats(call)];
    return ttlinphoneCallStats;
}

-(TTLinphoneCallStats*) getTextStats:(LinphoneCall*)call {
    TTLinphoneCallStats *ttlinphoneCallStats = [[TTLinphoneCallStats alloc] init];
    [ttlinphoneCallStats parseLinphoneCallStats:linphone_call_get_text_stats(call)];
    return ttlinphoneCallStats;
}

-(void) startRecording:(LinphoneCall*)call {
    linphone_call_start_recording(call);
}

-(void) stopRecording:(LinphoneCall*)call {
    linphone_call_stop_recording(call);
}

-(void) linphoneCallEnableEchoCancellation:(BOOL)enabled linphoneCall:(LinphoneCall*)call {
    linphone_call_enable_echo_cancellation(call, enabled);
}

-(void) linphoneCallEnableEchoLimiter:(BOOL)enabled linphoneCall:(LinphoneCall*)call {
    linphone_call_enable_echo_limiter(call, enabled);
}

-(TTLinphoneCall*) getTTLinphoneCall:(LinphoneCall*)call {
    TTLinphoneCall* ttlinphoneCall = [[TTLinphoneCall alloc] init];
    [ttlinphoneCall parseLinphoneCall:call];
    return ttlinphoneCall;
}


#pragma mark - Controlling media parameters Functions

-(int) setAudioCodecs:(MSList*) codecs { // TODO
    return linphone_core_set_audio_codecs(LC,codecs);
}

-(int) setVideoCodecs:(MSList*) codecs {
    return linphone_core_set_video_codecs(LC,codecs);
}

-(void) setAudioPortRangeWithMinPort:(int)minPort maxPort:(int)maxPort {
    linphone_core_set_audio_port_range(LC, minPort, maxPort);
}

-(void) setVideoPortRangeWithMinPort:(int)minPort maxPort:(int)maxPort {
    linphone_core_set_video_port_range(LC, minPort, maxPort);
}

-(void) setTextPortRangeWithMinPort:(int)minPort maxPort:(int)maxPort {
    linphone_core_set_text_port_range(LC, minPort, maxPort);
}

-(void) setNortpTimeout:(int)nortpTimeout {
    linphone_core_set_nortp_timeout(LC, nortpTimeout);
}

-(void) setUseInfoForDtmf:(BOOL) useInfo {
    linphone_core_set_use_info_for_dtmf(LC, useInfo);
}

-(void) setUseRfc2833ForDtmf:(BOOL)useRfc2833 {
    linphone_core_set_use_rfc2833_for_dtmf(LC, useRfc2833);
}

-(void) setRingLevel:(int)level {
    linphone_core_set_ring_level(LC, level);
}

-(void) setMicGainDb:(float)gaindb {
    linphone_core_set_mic_gain_db(LC, gaindb);
}

-(void) setPlaybackGainDb:(float)gaindb {
    linphone_core_set_playback_gain_db(LC, gaindb);
}

-(void) setPlayLevel:(int)level {
    linphone_core_set_play_level(LC, level);
}

-(void) setRecLevel:(int)level {
    linphone_core_set_rec_level(LC, level);
}

-(BOOL) soundDeviceCanCapture:(NSString*)devid {
    return linphone_core_sound_device_can_capture(LC, [devid UTF8String]);
}

-(BOOL) soundDeviceCanPlayback:(NSString*)devid {
    return linphone_core_sound_device_can_playback(LC, [devid UTF8String]);
}

-(int) setRingerDevice:(NSString*)devid {
    return linphone_core_set_ringer_device(LC,[devid UTF8String]);
}

-(int) setPlaybackDevice:(NSString*)devid {
    return linphone_core_set_playback_device(LC, [devid UTF8String]);
}

-(int) setCaptureDevice:(NSString*)devid {
    return linphone_core_set_capture_device(LC, [devid UTF8String]);
}

-(void) setRing:(NSString*)path {
    linphone_core_set_ring(LC, [path UTF8String]);
}

-(void) setRingback:(NSString*) path {
    linphone_core_set_ringback(LC, [path UTF8String]);
}

-(void) enableEchoCancellation:(BOOL) enabled {
    linphone_core_enable_echo_cancellation(LC, enabled);
}

-(void) setVideoPolicy:(LinphoneVideoPolicy*)policy { // TODO
    linphone_core_set_video_policy(LC, policy);
}

-(void) enableVideoPreview:(BOOL)enabled {
    linphone_core_enable_video_preview(LC, enabled);
}

-(void) enableSelfView:(BOOL)enabled {
    linphone_core_enable_self_view(LC, enabled);
}

-(int) setVideoDevice:(NSString*)id {
    return linphone_core_set_video_device(LC, [id UTF8String]);
}

-(void) setDeviceRotation:(int)rotation {
    linphone_core_set_device_rotation(LC, rotation);
}

-(void) playDtmf:(char)dtmf duration:(int)durationInMS {
    linphone_core_play_dtmf(LC, dtmf, durationInMS);
}

-(void) stopDtmf {
    linphone_core_stop_dtmf(LC);
}

-(void) setMtu:(int)mtu {
    linphone_core_set_mtu(LC, mtu);
}

-(void) stopRinging {
    linphone_core_stop_ringing(LC);
}

-(void) setAvpfMode:(NSString*)mode { // TODO
    linphone_core_set_avpf_mode(LC, [TTLinphoneAVPFMode getLinphoneAVPFModeWithString:mode]);
}

-(void) setAvpfRRInterval:(int)interval {
    linphone_core_set_avpf_rr_interval(LC, interval);
}

-(void) sendDtmf:(LinphoneCall*)call dtmf:(char)dtmf {
    linphone_call_send_dtmf(call, dtmf);
}

-(void) setDownloadBandwidth:(int)bandwidth {
    linphone_core_set_download_bandwidth(LC, bandwidth);
}

-(void) setUploadBandwidth:(int)bandwidth {
    linphone_core_set_upload_bandwidth(LC, bandwidth);
}


-(void) enableAdaptiveRateControl:(BOOL)enabled {
    linphone_core_enable_adaptive_rate_control(LC, enabled);
}

-(void) setAdaptiveRateAlgorithm:(NSString*)algorithm {
    linphone_core_set_adaptive_rate_algorithm(LC, [algorithm UTF8String]);
}

-(void) setDownloadPtime:(int)ptime {
    linphone_core_set_download_ptime(LC, ptime);
}

-(void) setUploadPtime:(int)ptime {
    linphone_core_set_upload_ptime(LC, ptime);
}

-(void) setSipTransportTimeout:(int)timeoutInMS {
    linphone_core_set_sip_transport_timeout(LC, timeoutInMS);
}

-(void) enableDnsSrv:(BOOL)enabled {
    linphone_core_enable_dns_srv(LC, enabled);
}

-(NSArray*) getAudioCodecs {
    return [LinphoneHelper getCodecs:linphone_core_get_audio_codecs(LC)];
}

-(NSArray*) getVideoCodecs {
    return [LinphoneHelper getCodecs:linphone_core_get_video_codecs(LC)];
}

-(NSArray*) getTextCodecs {
    return [LinphoneHelper getCodecs:linphone_core_get_text_codecs(LC)];
}

-(void) setPayloadTypeBitrate:(NSString*)type rate:(int)rate bitrate:(int)bitrate {
    LinphonePayloadType* payloadType = linphone_core_find_payload_type(LC, [type UTF8String], rate, -1);
    linphone_core_set_payload_type_bitrate(LC, payloadType, bitrate);
}

-(int) enablePayloadType:(NSString*)type rate:(int)rate enable:(BOOL)enable {
    LinphonePayloadType* payloadType = linphone_core_find_payload_type(LC, [type UTF8String], rate, -1);
    return linphone_core_enable_payload_type(LC, payloadType, enable);
}

-(TTPayloadType*) findPayloadType:(NSString*)type rate:(int)rate channels:(int)channels {
    TTPayloadType* ttpayloadType = [[TTPayloadType alloc] init];
    [ttpayloadType parsePayloadType:linphone_core_find_payload_type(LC, [type UTF8String], rate, channels)];
    return ttpayloadType;
}

-(void) setPayloadTypeNumber:(NSString*)type rate:(int)rate number:(int)number {
    LinphonePayloadType* payloadType = linphone_core_find_payload_type(LC, [type UTF8String], rate, -1);
    linphone_core_set_payload_type_number(LC, payloadType, number);
}

-(void) enableAudioAdaptiveJittcomp:(BOOL) enabled {
    linphone_core_enable_audio_adaptive_jittcomp(LC, enabled);
}

-(void) setAudioJittcomp:(int) millisecond {
    linphone_core_set_audio_jittcomp(LC, millisecond);
}

-(void) enableVideoAdaptiveJittcomp:(BOOL) enabled {
    linphone_core_enable_video_adaptive_jittcomp(LC, enabled);
}

-(void) setVideoJittcomp:(int) milliseconds {
    linphone_core_set_video_jittcomp(LC, milliseconds);
}

-(void) reloadSoundDevices {
    linphone_core_reload_sound_devices(LC);
}

-(void) setRemoteRingbackTone:(NSString*) ring {
    linphone_core_set_remote_ringback_tone(LC, [ring UTF8String]);
}

-(void) setRingDuringIncomingEarlyMedia:(BOOL)enabled {
    linphone_core_set_ring_during_incoming_early_media(LC, enabled);
}

-(void) enableEchoLimiter:(BOOL)enabled {
    linphone_core_enable_echo_limiter(LC, enabled);
}

-(void) enableMic:(BOOL)enabled {
    linphone_core_enable_mic(LC, enabled);
}

-(void) enableVideoCapture:(BOOL)enabled {
    linphone_core_enable_video_capture(LC, enabled);
}

-(void) enableVideoDisplay:(BOOL)enabled {
    linphone_core_enable_video_display(LC, enabled);
}

-(void) enableVideoSourceReuse:(BOOL)enabled {
    linphone_core_enable_video_source_reuse(LC, enabled);
}

-(void) setPreferredVideoSize:(int)width height:(int)height {
    MSVideoSize videoSize;
    videoSize.width = width;
    videoSize.height = height;
    linphone_core_set_preferred_video_size(LC, videoSize);
}

-(void) setPreviewVideoSize:(int)width height:(int)height  {
    MSVideoSize videoSize;
    videoSize.width = width;
    videoSize.height = height;
    linphone_core_set_preview_video_size(LC, videoSize);
}

-(void) setPreviewVideoSizeByName:(NSString*)name {
    linphone_core_set_preview_video_size_by_name(LC, [name UTF8String]);
}

-(void) setPreferredVideoSizeByName:(NSString*)name {
    linphone_core_set_preferred_video_size_by_name(LC, [name UTF8String]);
}

-(void) setPreferredFramerate:(float)fps {
    linphone_core_set_preferred_framerate(LC, fps);
}

-(void) reloadVideoDevices {
    linphone_core_reload_video_devices(LC);
}

-(int) setStaticPicture:(NSString*)path {
    return linphone_core_set_static_picture(LC, [path UTF8String]);
}

-(int) setStaticPictureFps:(float)fps {
    return linphone_core_set_static_picture_fps(LC, fps);
}

-(void) usePreviewWindow:(BOOL)use {
    linphone_core_use_preview_window(LC, use);
}

-(void) setUseFiles:(BOOL)use {
    linphone_core_set_use_files(LC, use);
}

-(void) setPlayFile:(NSString*)file {
    linphone_core_set_play_file(LC, [file UTF8String]);
}

-(void) setRecordFile:(NSString*)file {
    linphone_core_set_record_file(LC, [file UTF8String]);
}

-(int) setMediaEncryption:(NSString*)mediaEncryption {
    return linphone_core_set_media_encryption(LC, [TTLinphoneMediaEncryption getLinphoneMediaEncryptionWithString:mediaEncryption]);
}

-(void) setMediaEncryptionMandatory:(BOOL)mandatory {
    linphone_core_set_media_encryption_mandatory(LC, mandatory);
}

-(int) setAudioMulticastAddress:(NSString*)ip {
    return linphone_core_set_audio_multicast_addr(LC, [ip UTF8String]);
}

-(int) setVideoMulticastAddress:(NSString*)ip {
    return linphone_core_set_video_multicast_addr(LC, [ip UTF8String]);
}

-(int) setAudioMulticastTtl:(int)ttl {
    return linphone_core_set_audio_multicast_ttl(LC, ttl);
}

-(int) setVideoMulticastTtl:(int)ttl {
    return linphone_core_set_video_multicast_ttl(LC, ttl);
}

-(void) enableAudioMulticast:(BOOL)enabled {
    linphone_core_enable_audio_multicast(LC, enabled);
}

-(void) enableVideoMulticast:(BOOL)enabled {
    linphone_core_enable_video_multicast(LC, enabled);
}

-(void) setVideoDisplayFilter:(NSString*)filterName {
    linphone_core_set_video_display_filter(LC, [filterName UTF8String]);
}

-(TTMediaParameters*) getMediaParameters {
    TTMediaParameters *ttmediaParameters = [[TTMediaParameters alloc] init];
    [ttmediaParameters parseLinphoneCore:LC];
    return ttmediaParameters;
}

#pragma mark - Controlling network parameters (ports, mtu...) Functions

-(void) setAudioPort:(int)port {
    linphone_core_set_audio_port(LC, port);
}

-(void) setVideoPort:(int)port {
    linphone_core_set_video_port(LC, port);
}

-(void) setTextPort:(int)port {
    linphone_core_set_text_port(LC, port);
}

-(void) setSipPort:(int)port {
    linphone_core_set_sip_port(LC, port);
}

-(void) setSipTransport:(const LCSipTransports*) tr_config { //TODO
    linphone_core_set_sip_transports(LC, tr_config);
}

-(void) enableIpv6:(BOOL)enabled {
    linphone_core_enable_ipv6(LC, enabled);
}

-(void) setSipDscp:(int)dscp {
    linphone_core_set_sip_dscp(LC, dscp);
}

-(void) setAudioDscp:(int)dscp {
    linphone_core_set_audio_dscp(LC, dscp);
}


-(void) setVideoDscp:(int)dscp {
    linphone_core_set_video_dscp(LC, dscp);
}

-(void) setStunServer:(NSString*) server {
    linphone_core_set_stun_server(LC, [server UTF8String]);
}

-(void) setNatAddress:(NSString*) address {
    linphone_core_set_nat_address(LC, [address UTF8String]);
}

-(void) setFirewallPolicy:(NSString*) firewallPolicy {
    LinphoneFirewallPolicy linphoneFirewallPolicy = [TTLinphoneFirewallPolicy getLinphoneFirewallPolicyWithString:firewallPolicy];
    linphone_core_set_firewall_policy(LC, linphoneFirewallPolicy);
}

-(void) setNetworkReachable:(BOOL)reachable {
    linphone_core_set_network_reachable(LC,reachable);
}

-(void) enableKeepAlive:(BOOL)enabled {
    linphone_core_enable_keep_alive(LC, enabled);
}

-(void) enableSdp200Ack:(BOOL) enabled {
    linphone_core_enable_sdp_200_ack(LC, enabled);
}

-(TTNetworkParameters*) getNetworkParameters {
    TTNetworkParameters *ttnetworkParameters = [[TTNetworkParameters alloc] init];
    [ttnetworkParameters parseLinphoneCore:LC];
    return ttnetworkParameters;
}

#pragma mark - Managing call logs Functions

- (NSDictionary*) getCallLogs:(NSString*)callStatus callDirection:(NSString*)callDirection {
    const MSList *logs = linphone_core_get_call_logs([LinphoneManager getLc]);
    NSMutableDictionary *sections = [NSMutableDictionary dictionary];
    NSMutableDictionary *callLogs = [NSMutableDictionary dictionary];
    while (logs != NULL) {
        LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
        LinphoneCallStatus linphoneCallStatus = [TTLinphoneCallStatus getLinphoneCallStatusWithString:callStatus];
        if (callStatus.length == 0 || linphone_call_log_get_status(log) == linphoneCallStatus) {
            LinphoneCallDir linphoneCallDir = [TTLinphoneCallDir getLinphoneCallDirectionWithString:callDirection];
            if (callDirection.length == 0 || linphone_call_log_get_dir(log) == linphoneCallDir) {
                NSDate *startDate = [LinphoneHelper dateAtBeginningOfDayForDate:[NSDate
                                                                  dateWithTimeIntervalSince1970:linphone_call_log_get_start_date(log)]];
                NSMutableArray *eventsOnThisDay = [sections objectForKey:startDate];
                NSMutableArray *eventsOnThisDaySelf = [sections objectForKey:startDate];
                if (eventsOnThisDay == nil) {
                    eventsOnThisDay = [NSMutableArray array];
                    eventsOnThisDaySelf = [NSMutableArray array];
                    [sections setObject:eventsOnThisDay forKey:startDate];
                    [callLogs setObject:eventsOnThisDaySelf forKey:startDate];
                }
                
                linphone_call_log_set_user_data(log, NULL);
                
                // if this contact was already the previous entry, do not add it twice
                LinphoneCallLog *prev = [eventsOnThisDay lastObject] ? [[eventsOnThisDay lastObject] pointerValue] : NULL;
                if (prev && linphone_address_weak_equal(linphone_call_log_get_remote_address(prev),
                                                        linphone_call_log_get_remote_address(log))) {
                    MSList *list = linphone_call_log_get_user_data(prev);
                    list = ms_list_append(list, log);
                    linphone_call_log_set_user_data(prev, list);
                } else {
                    TTCallLog* ttCallLog = [[TTCallLog alloc] init];
                    [ttCallLog parseLinphoneCallLog:log];
                    [eventsOnThisDaySelf addObject:ttCallLog];
                    [eventsOnThisDay addObject:[NSValue valueWithPointer:linphone_call_log_ref(log)]];
                }
            }
        }
        logs = ms_list_next(logs);
    }
    return callLogs;
}
- (void) clearCallLogs {
    linphone_core_clear_call_logs(LC);
}

- (NSArray*) getCallPeerHistoryForCallId:(NSString*)callId {
    
    LinphoneCallLog* callLog = linphone_core_find_call_log_from_call_id(LC, [callId UTF8String]);
    LinphoneAddress *peer = linphone_call_log_get_remote_address(callLog);
    const MSList *logs = linphone_core_get_call_history_for_address(LC, peer);
    NSMutableArray* callLogs = [[NSMutableArray alloc] init];
    while (logs != NULL) {
        LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
        if (linphone_address_weak_equal(linphone_call_log_get_remote_address(log), peer)) {
            TTCallLog* ttcallLog = [[TTCallLog alloc] init];
            [ttcallLog parseLinphoneCallLog:log];
            [callLogs addObject:ttcallLog];
        }
        logs = ms_list_next(logs);
    }
    return callLogs;
}

- (TTCallLog*) findCallLogFromCallId:(NSString*)callId {
    TTCallLog *ttcallLog = [[TTCallLog alloc] init];
    [ttcallLog parseLinphoneCallLog:linphone_core_find_call_log_from_call_id(LC, [callId UTF8String])];
    return ttcallLog;
}
- (void) removeCallLogWithCallId:(NSString*)callId {
    LinphoneCallLog* callLog = linphone_core_find_call_log_from_call_id(LC, [callId UTF8String]);
    linphone_core_remove_call_log(LC, callLog);
    linphone_call_log_unref(callLog);
}
- (TTCallLog*) getLastOutgoingCallLog {
    const MSList *logs = linphone_core_get_call_logs([LinphoneManager getLc]);
    while (logs != NULL) {
        LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
        if (linphone_call_log_get_dir(log) == LinphoneCallOutgoing) {
            TTCallLog *ttcallLog = [[TTCallLog alloc] init];
            [ttcallLog parseLinphoneCallLog:log];
            return ttcallLog;
        }
        logs = ms_list_next(logs);
    }
    
    return nil;
}
- (int) getMissedCallsCount {
    return linphone_core_get_missed_calls_count(LC);
}
- (void) resetMissedCallsCount {
    linphone_core_reset_missed_calls_count(LC);
}


#pragma mark - Making an audio conference Functions

- (TTConference*) getTTConference {
    TTConference* ttconference = [[TTConference alloc] init];
    [ttconference parseLinphoneCore:LC];
    return ttconference;
}
- (NSArray*) getAllCalls {
    NSMutableArray *ttCalls = [[NSMutableArray alloc] init];
    const MSList *calls = linphone_core_get_calls(LC);
    while (calls) {
        LinphoneCall* call = calls->data;
        TTLinphoneCall* ttlinphoneCall = [[TTLinphoneCall alloc] init];
        [ttlinphoneCall parseLinphoneCall:call];
        [ttCalls addObject:ttlinphoneCall];
        calls = calls->next;
    }
    return ttCalls;
}
- (void) addToConference:(LinphoneCall*)call {
    linphone_core_add_to_conference(LC, call);
}
- (void) removeFromConference:(LinphoneCall*)call {
    linphone_core_remove_from_conference(LC, call);
}
- (void) leaveConference {
    linphone_core_leave_conference(LC);
}
- (void) enterConference {
    linphone_core_enter_conference(LC);
}
- (void) addAllToConference {
    linphone_core_add_all_to_conference(LC);
}
- (void) startConferenceRecording:(NSString*)path {
    linphone_core_start_conference_recording(LC, [path UTF8String]);
}
- (void) stopConferenceRecording {
    linphone_core_stop_conference_recording(LC);
}


#pragma mark - Managing Buddies and buddy list and presence Functions

- (LinphonePresenceModel*) getMyOnlineStatus {
    return linphone_core_get_presence_model(LC);
}

- (LinphoneFriend*) findFriendByUsername:(NSString*)username domain:(NSString*)domain {
    LinphoneAddress* address = [TTLinphoneAddress getLinphoneAddressWithUsername:username domain:domain];
    LinphoneFriend* friend = linphone_core_find_friend(LC, address);
    return friend;
}

- (const LinphonePresenceModel*) findPresenceModelByUsername:(NSString*)username domain:(NSString*)domain {
    LinphoneAddress* address = [TTLinphoneAddress getLinphoneAddressWithUsername:username domain:domain];
    LinphoneFriend* friend = linphone_core_find_friend(LC, address);
    
    return linphone_friend_get_presence_model(friend);
}

- (const LinphonePresenceModel*) findPresenceModel:(LinphoneFriend*)friend {
    return linphone_friend_get_presence_model(friend);
}

- (NSArray*) getFriendList {
    const MSList* friends = linphone_core_get_friend_list(LC);
    const MSList *item = friends;
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    while (item) {
        LinphoneFriend *friend = (LinphoneFriend *)item->data;
        TTLinphoneFriend *ttlinphoneFriend = [[TTLinphoneFriend alloc] init];
        [ttlinphoneFriend parseLinphoneFriend:friend];
        [resultArray addObject:ttlinphoneFriend];
        item = item->next;
    }
    return resultArray;
}

- (LinphoneFriend*) createOrEditLinphoneFriendWithAddress:(NSString*)username domain:(NSString*)domain {
    LinphoneFriend* friend = [self findFriendByUsername:username domain:domain];
    if (!friend) {
        NSString* address = [NSString stringWithFormat:@"sip:%@@%@", username, domain];
        friend = linphone_core_create_friend_with_address(LC, [address UTF8String]);
    }
    linphone_friend_edit(friend);
    
    linphone_friend_done(friend);
    
    return friend;
}

- (void) notifyAllFriendList:(LinphonePresenceModel *)presence{
    linphone_core_notify_all_friends(LC, presence);
}

- (void) addFriend:(LinphoneFriend*)linphoneFriend {
    linphone_core_add_friend(LC, linphoneFriend);
}

- (void) removeFriend:(LinphoneFriend*)linphoneFriend {
    linphone_core_remove_friend(LC, linphoneFriend);
}

- (void) acceptSubscriber:(LinphoneFriend*)linphoneFriend {
    linphone_friend_set_inc_subscribe_policy(linphoneFriend, LinphoneSPAccept);
}

- (void) rejectSubscriber:(LinphoneFriend*)linphoneFriend {
    linphone_core_reject_subscriber(LC, linphoneFriend);
}

- (LinphonePresenceModel*) createNewLinphonePresenceModelWithActivity:(LinphonePresenceActivityType)activity description:(NSString*)description {
    return linphone_presence_model_new_with_activity(activity, [description UTF8String]);
}

- (void) setBasicStatus:(LinphonePresenceModel*)model basicStatus:(LinphonePresenceBasicStatus)basicStatus {
    linphone_presence_model_set_basic_status(model, basicStatus);
}

- (void) setContact:(LinphonePresenceModel*) model contact:(NSString*)contact {
    linphone_presence_model_set_contact(model, [contact UTF8String]);
}

- (void) setActivity:(LinphonePresenceModel*)model activity:(LinphonePresenceActivityType)activity description:(NSString*)description {
    linphone_presence_model_set_activity(model, activity, [description UTF8String]);
}

- (LinphonePresenceActivity*) getNthActivity:(LinphonePresenceModel*)model index:(unsigned int)index {
    return linphone_presence_model_get_nth_activity(model, index);
}

- (LinphonePresenceActivity*) createNewWithActivity:(LinphonePresenceActivityType)type description:(NSString*)description {
    return linphone_presence_activity_new(type, [description UTF8String]);
}

- (void) addActivity:(LinphonePresenceModel*)model activity:(LinphonePresenceActivity*) activity {
    linphone_presence_model_add_activity(model, activity);
}

- (void) clearActivities:(LinphonePresenceModel*)model {
    linphone_presence_model_clear_activities(model);
}

- (LinphonePresenceNote*) getNote:(LinphonePresenceModel*)model lang:(NSString*)lang {
    return linphone_presence_model_get_note(model, [lang UTF8String]);
}

- (void) addNote:(LinphonePresenceModel*)model noteContent:(NSString*)noteContent lang:(NSString*)lang {
    linphone_presence_model_add_note(model, [noteContent UTF8String], [lang UTF8String]);
}

- (void) clearNotes:(LinphonePresenceModel*)model {
    linphone_presence_model_clear_notes(model);
}

- (LinphonePresenceService*) getNthService:(LinphonePresenceModel*)model index:(unsigned int)index {
    return linphone_presence_model_get_nth_service(model, index);
}

- (LinphonePresenceService*) createNewService:(LinphonePresenceBasicStatus)basicStatus contact:(NSString*)contact {
    return linphone_presence_service_new(NULL, basicStatus, [contact UTF8String]);
}

- (void) addService:(LinphonePresenceModel*)model service:(LinphonePresenceService *)service{
    linphone_presence_model_add_service(model, service);
}

- (void) clearServices:(LinphonePresenceModel*)model {
    linphone_presence_model_clear_services(model);
}

- (LinphonePresencePerson*) getNthPerson:(LinphonePresenceModel*)model index:(unsigned int)index {
    return linphone_presence_model_get_nth_person(model, index);
}

- (LinphonePresencePerson*) createNewPerson {
    return linphone_presence_person_new(NULL);
}

- (void) addPerson:(LinphonePresenceModel*)model person:(LinphonePresencePerson*)person {
    linphone_presence_model_add_person(model, person);
}

- (void) clearPerson:(LinphonePresenceModel*)model {
    linphone_presence_model_clear_persons(model);
}

- (void) setIdForLinphonePresenceService:(LinphonePresenceService*)service id:(NSString*)id {
    linphone_presence_service_set_id(service, [id UTF8String]);
}

- (void) setBasicStatusForLinphonePresenceService:(LinphonePresenceService*)service basicStatus:(LinphonePresenceBasicStatus) basicStatus {
    linphone_presence_service_set_basic_status(service, basicStatus);
}

- (void) setContactForLinphonePresenceService:(LinphonePresenceService*)service contact:(NSString*) contact {
    linphone_presence_service_set_contact(service, [contact UTF8String]);
}

- (LinphonePresenceNote*) getNthNoteFromService:(LinphonePresenceService*)service index:(unsigned int) index {
    return linphone_presence_service_get_nth_note(service, index);
}

- (LinphonePresenceNote*) createNewNote:(NSString*)content lang:(NSString*)lang {
    return linphone_presence_note_new([content UTF8String], [lang UTF8String]);
}


- (void) addNoteForLinphonePresenceService:(LinphonePresenceService*)service note:(LinphonePresenceNote *)note {
    linphone_presence_service_add_note(service, note);
}

- (void) clearNotesForLinphonePresenceService:(LinphonePresenceService*)service {
    linphone_presence_service_clear_notes(service);
}

- (void) setIdForLinphonePresencePerson:(LinphonePresencePerson*)person id:(NSString*)id {
    linphone_presence_person_set_id(person, [id UTF8String]);
}

- (LinphonePresenceActivity*) getNthActivityForLinphonePresencePerson:(LinphonePresencePerson*)person index:(unsigned int)index {
    return linphone_presence_person_get_nth_activity(person, index);
}

- (void) addActivityForLinphonePresencePerson:(LinphonePresencePerson*)person activity:(LinphonePresenceActivity *)activity {
    linphone_presence_person_add_activity(person, activity);
}

- (void) clearActivitiesForLinphonePresencePerson:(LinphonePresencePerson*)person {
    linphone_presence_person_clear_activities(person);
}

- (LinphonePresenceNote*) getNthNoteFromPerson:(LinphonePresencePerson*)person index:(unsigned int)index{
    return linphone_presence_person_get_nth_note(person, index);
}

- (void) addNoteForLinphonePresencePerson:(LinphonePresencePerson*)person note:(LinphonePresenceNote*)note{
    linphone_presence_person_add_note(person, note);
}

- (void) clearNotesForLinphonePresencePerson:(LinphonePresencePerson*)person {
    linphone_presence_person_clear_notes(person);
}

- (LinphonePresenceNote*) getNthActivitiesNote:(LinphonePresencePerson*)person index:(unsigned int)index {
    return linphone_presence_person_get_nth_activities_note(person, index);
}

- (void) addActivitiesNote:(LinphonePresencePerson*)person note:(LinphonePresenceNote*)note{
    linphone_presence_person_add_activities_note(person, note);
}

- (void) clearActivitiesNotes:(LinphonePresencePerson*)person {
    linphone_presence_person_clear_activities_notes(person);
}

- (void) createNewLinphonePresenceActivity:(NSString*)presenceActivityType description:(NSString*)description {
    LinphonePresenceActivityType type = [TTLinphonePresenceActivityType getLinphonePresenceActivityTypeWithString:presenceActivityType];
    TTLinphonePresenceActivity *ttlinphonePresenceActivity = [[TTLinphonePresenceActivity alloc] init];
    [ttlinphonePresenceActivity parseLinphonePresenceActivity:linphone_presence_activity_new(type, [description UTF8String])];
}

- (void) setTypeForLinphonePresenceActivity:(LinphonePresenceActivity*)activity type:(NSString*)type {
    LinphonePresenceActivityType presenceActivityType = [TTLinphonePresenceActivityType getLinphonePresenceActivityTypeWithString:type];
    linphone_presence_activity_set_type(activity, presenceActivityType);
}

- (void) setDescriptionForLinphonePresenceActivity:(LinphonePresenceActivity*)activity description:(NSString*)description {
    linphone_presence_activity_set_description(activity, [description UTF8String]);
}

- (void) setContentForLinphonePresenceNote:(LinphonePresenceNote*)note content:(NSString*)content {
    linphone_presence_note_set_content(note, [content UTF8String]);
}
- (void) setLangForLinphonePresenceNote:(LinphonePresenceNote*)note lang:(NSString*)lang {
    linphone_presence_note_set_lang(note, [lang UTF8String]);
}



#pragma mark - Chat room and Messaging Functions

-(NSArray*) getAllChatRooms {
    const MSList* chatRooms = linphone_core_get_chat_rooms(LC);
    const MSList *item = chatRooms;
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    while (item) {
        LinphoneChatRoom *room = (LinphoneChatRoom *)item->data;
        TTLinphoneChatRoom *ttlinphoneChatRoom = [[TTLinphoneChatRoom alloc] init];
        [ttlinphoneChatRoom parseLinphoneChatRoom:room];
        [resultArray addObject:ttlinphoneChatRoom];
        item = item->next;
    }
    return resultArray;
}

-(void) setChatDatabasePath:(NSString*)path {
    linphone_core_set_chat_database_path(LC, [path UTF8String]);
}

-(LinphoneChatRoom *) getChatRoomWithUsername:(NSString*)username domain:(NSString*)domain {
    LinphoneAddress* address = [TTLinphoneAddress getLinphoneAddressWithUsername:username domain:domain];
    return linphone_core_get_chat_room(LC, address);
}

-(LinphoneChatRoom *) getChatRoomFromUri:(NSString*) toUri {
    return linphone_core_get_chat_room_from_uri(LC, [toUri UTF8String]);
}

-(void) deleteChatRoom:(LinphoneChatRoom*) chatRoom {
    linphone_core_delete_chat_room(LC, chatRoom);
}

-(void) disableChat:(LinphoneReason) denyReason {
    linphone_core_disable_chat(LC, denyReason);
}

-(void) enableChat {
    linphone_core_enable_chat(LC);
}

- (void)upload:(UIImage *)image withURL:(NSURL *)url forChatRoom:(LinphoneChatRoom *)chatRoom {
    _ftd = [[FileTransferDelegate alloc] init];
    [_ftd upload:image withURL:url forChatRoom:chatRoom];
}

-(void) startFileDownload:(LinphoneChatMessage *)message {
    [_ftd stopAndDestroy];
    _ftd = [[FileTransferDelegate alloc] init];
    [self connectToFileDelegate:_ftd];
    [_ftd download:message];
}

-(void) cancelFileDownload:(LinphoneChatMessage *)message {
    FileTransferDelegate *tmp = _ftd;
    [self disconnectFromFileDelegate];
    [tmp cancel:message];
}

-(void) cancelFileUpload {
    FileTransferDelegate *tmp = _ftd;
    [self disconnectFromFileDelegate];
    [tmp stopAndDestroy];
}

- (BOOL)sendMessageWithChatRoom:(LinphoneChatRoom *)chatRoom message:(NSString*)message withExterlBodyUrl:(NSURL *)externalUrl withInternalURL:(NSURL *)internalUrl {
    if (chatRoom == NULL) {
        LOGW(@"Cannot send message: No chatroom");
        return FALSE;
    }
    
    LinphoneChatMessage *msg = linphone_chat_room_create_message(chatRoom, [message UTF8String]);
    if (externalUrl) {
        linphone_chat_message_set_external_body_url(msg, [[externalUrl absoluteString] UTF8String]);
    }
    
    if (internalUrl) {
        // internal url is saved in the appdata for display and later save
        [LinphoneManager setValueInMessageAppData:[internalUrl absoluteString] forKey:@"localimage" inMessage:msg];
    }
    
    // we must ref & unref message because in case of error, it will be destroy otherwise
    linphone_chat_room_send_chat_message(chatRoom, linphone_chat_message_ref(msg));
    linphone_chat_message_unref(msg);
    
    return TRUE;
}

-(void) markAsRead:(LinphoneChatRoom*) chatRoom {
    linphone_chat_room_mark_as_read(chatRoom);
}

-(void) deleteMessage:(LinphoneChatRoom*) chatRoom chatMessage:(LinphoneChatMessage*) message {
    linphone_chat_room_delete_message(chatRoom, message);
}

-(void) deleteHistory:(LinphoneChatRoom*) chatRoom {
    linphone_chat_room_delete_history(chatRoom);
}

-(NSArray*) getHistory:(LinphoneChatRoom *) chatRoom numberOfMessages:(int)numberOfMessages {
    NSMutableArray* chatMessageList = [[NSMutableArray alloc] init];
    const MSList* history = linphone_chat_room_get_history(chatRoom, numberOfMessages);
    while (history) {
        // store last message in user data
        LinphoneChatMessage *chatMessage = history->data;
        TTLinphoneChatMessage *ttlinphoneChatMessage = [[TTLinphoneChatMessage alloc] init];
        [ttlinphoneChatMessage parseLinphoneChatMessage:chatMessage];
        [chatMessageList addObject:ttlinphoneChatMessage];
        history = history->next;
    }
    return chatMessageList;
}

-(NSArray*) getHistoryRange:(LinphoneChatRoom *) chatRoom begin:(int)begin end:(int)end {
    NSMutableArray* chatMessageList = [[NSMutableArray alloc] init];
    const MSList* history = linphone_chat_room_get_history_range(chatRoom, begin, end);
    while (history) {
        // store last message in user data
        LinphoneChatMessage *chatMessage = history->data;
        TTLinphoneChatMessage *ttlinphoneChatMessage = [[TTLinphoneChatMessage alloc] init];
        [ttlinphoneChatMessage parseLinphoneChatMessage:chatMessage];
        [chatMessageList addObject:ttlinphoneChatMessage];
        history = history->next;
    }
    return chatMessageList;
}

-(void) compose:(LinphoneChatRoom *) chatRoom {
    linphone_chat_room_compose(chatRoom);
}

- (int)unreadTotalMessageCount {
    int count = 0;
    const MSList *rooms = linphone_core_get_chat_rooms(LC);
    const MSList *item = rooms;
    while (item) {
        LinphoneChatRoom *room = (LinphoneChatRoom *)item->data;
        if (room) {
            count += linphone_chat_room_get_unread_messages_count(room);
        }
        item = item->next;
    }
    
    return count;
}

- (LinphoneChatRoom *)findChatRoomForContact:(NSString *)contact {
    const MSList *rooms = linphone_core_get_chat_rooms(LC);
    const char *from = [contact UTF8String];
    while (rooms) {
        const LinphoneAddress *room_from_address = linphone_chat_room_get_peer_address((LinphoneChatRoom *)rooms->data);
        char *room_from = linphone_address_as_string_uri_only(room_from_address);
        if (room_from && strcmp(from, room_from) == 0) {
            return rooms->data;
        }
        rooms = rooms->next;
    }
    return NULL;
}

- (LinphoneChatMessage *)findChatMessageWithChatRoom:(LinphoneChatRoom *)chatRoom messageStoreId:(unsigned int)messageStoreId {
    int historySize = linphone_chat_room_get_history_size(chatRoom);
    MSList* messages = linphone_chat_room_get_history(chatRoom, historySize);
    while (messages) {
        LinphoneChatMessage *msg = messages->data;
        if (messageStoreId == linphone_chat_message_get_storage_id(msg)) {
            return msg;
        }
        messages = messages->next;
    }
    return NULL;
}

- (LinphoneChatMessageCbs *)getLinphoneChatMessageCbs:(LinphoneChatMessage *)message {
    return linphone_chat_message_get_callbacks(message);
}

-(void) addCustomHeader:(LinphoneChatMessage *)message headerName:(NSString*)headerName headerValue:(NSString*)headerValue {
    linphone_chat_message_add_custom_header(message, [headerName UTF8String], [headerValue UTF8String]);
}

-(const char*) getCustomHeader:(LinphoneChatMessage *)message headerName:(NSString*)headerName {
    return linphone_chat_message_get_custom_header(message, [headerName UTF8String]);
}

-(void) setMsgStateChangedCb:(LinphoneChatMessageCbs *)cbs msgStateChangedCb:(LinphoneChatMessageCbsMsgStateChangedCb)cb {
    linphone_chat_message_cbs_set_msg_state_changed(cbs, cb);
}

-(void) setFileTransferRecv:(LinphoneChatMessageCbs *)cbs fileTransferRecvCb:(LinphoneChatMessageCbsFileTransferRecvCb)cb {
    linphone_chat_message_cbs_set_file_transfer_recv(cbs, cb);
}

-(void) setFileTransferSend:(LinphoneChatMessageCbs *)cbs fileTransferSendCb:(LinphoneChatMessageCbsFileTransferSendCb)cb {
    linphone_chat_message_cbs_set_file_transfer_send(cbs, cb);
}

-(void) setFileTransferProgressIndication:(LinphoneChatMessageCbs *)cbs fileTransferProgressIndicationCb:(LinphoneChatMessageCbsFileTransferProgressIndicationCb)cb {
    linphone_chat_message_cbs_set_file_transfer_progress_indication(cbs, cb);
}

#pragma mark - LinphoneFileTransfer Notifications Handling

- (void)connectToFileDelegate:(FileTransferDelegate *)aftd {
    if (aftd.message && linphone_chat_message_get_state(aftd.message) == LinphoneChatMessageStateFileTransferError) {
        LOGW(@"This file transfer failed unexpectedly, cleaning it");
        [aftd stopAndDestroy];
        return;
    }
    
    _ftd = aftd;
}

- (void)disconnectFromFileDelegate {
    _ftd = nil;
}




#pragma mark - Generic Functions

+ (NSMutableArray*) findAuthIndexOf:(NSString*)username domain:(NSString*)domain {
    LinphoneCore *lc = [LinphoneManager getLc];
    const MSList *accountList = linphone_core_get_auth_info_list(lc);
    int nbAccounts = ms_list_size(accountList);
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    for (int index = 0; index < nbAccounts; index++)
    {
        LinphoneAuthInfo* authInfo = ms_list_nth_data(accountList, index);
        
        const char *accountUsername = linphone_auth_info_get_username(authInfo);
        const char *accountDomain = linphone_auth_info_get_domain(authInfo);
        NSString *identity = [NSString stringWithFormat:@"%s@%s", accountUsername, accountDomain];
        NSString *sipAddress = [NSString stringWithFormat:@"%@@%@", username, domain];
        if ([identity isEqualToString:sipAddress]) {
            [indexes addObject:[NSNumber numberWithInteger:index]];
        }
    }
    return indexes;
}
+ (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    NSDateComponents *dateComps =
    [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:inputDate];
    
    dateComps.hour = dateComps.minute = dateComps.second = 0;
    return [calendar dateFromComponents:dateComps];
}
+(NSArray*) getCodecs:(const MSList*)codecs {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    PayloadType *pt;
    const MSList *codec = codecs;
    while (codec) {
        pt = codec->data;
        TTPayloadType *ttpayloadType = [[TTPayloadType alloc] init];
        [ttpayloadType parsePayloadType:pt];
        [array addObject:ttpayloadType];
        codec = codec->next;
    }
    return array;
}

- (LinphoneCall*) getLinphoneCallFromCallId:(NSString*)callid {
    MSList *calls = (MSList *)linphone_core_get_calls(LC);
    MSList *call = ms_list_find_custom(calls, (MSCompareFunc)comp_call_id, [callid UTF8String]);
    if (call != NULL) {
        return call->data;
    };
    return nil;
}

static int comp_call_id(const LinphoneCall *call, const char *callid) {
    if (linphone_call_log_get_call_id(linphone_call_get_call_log(call)) == nil) {
        ms_error("no callid for call [%p]", call);
        return 1;
    }
    return strcmp(linphone_call_log_get_call_id(linphone_call_get_call_log(call)), callid);
}

@end
