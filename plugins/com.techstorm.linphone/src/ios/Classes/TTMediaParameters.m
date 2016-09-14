//
//  TTMediaParameters.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTMediaParameters.h"

@implementation TTMediaParameters

-(void)parseLinphoneCore:(LinphoneCore*)LC {
    self.audioJittcomp = [NSNumber numberWithInt:linphone_core_get_audio_jittcomp(LC)];
    self.videoJittcomp = [NSNumber numberWithInt:linphone_core_get_video_jittcomp(LC)];
    self.nortpTimeout = [NSNumber numberWithInt:linphone_core_get_nortp_timeout(LC)];
    self.useInfoForDtmf = [NSNumber numberWithBool:linphone_core_get_use_info_for_dtmf(LC)];
    self.useRfc2833ForDtmf = [NSNumber numberWithBool:linphone_core_get_use_rfc2833_for_dtmf(LC)];
    self.playLevel = [NSNumber numberWithInt:linphone_core_get_play_level(LC)];
    self.ringLevel = [NSNumber numberWithInt:linphone_core_get_ring_level(LC)];
    self.recLevel = [NSNumber numberWithInt:linphone_core_get_rec_level(LC)];
    
    self.micGainDb = [NSNumber numberWithFloat:linphone_core_get_mic_gain_db(LC)];
    self.playbackGainDb = [NSNumber numberWithFloat:linphone_core_get_playback_gain_db(LC)];
    
    self.ringerDevice = [NSString stringWithUTF8String:linphone_core_get_ringer_device(LC)];
    self.playbackDevice = [NSString stringWithUTF8String:linphone_core_get_playback_device(LC)];
    self.captureDevice = [NSString stringWithUTF8String:linphone_core_get_capture_device(LC)];
    self.soundDevices = [NSString stringWithUTF8String:*linphone_core_get_sound_devices(LC)];
    self.videoDevices = [NSString stringWithUTF8String:*linphone_core_get_video_devices(LC)];
    self.videoDevice = [NSString stringWithUTF8String:linphone_core_get_video_device(LC)];
    self.ring = [NSString stringWithUTF8String:linphone_core_get_ring(LC)];
    self.ringback = [NSString stringWithUTF8String:linphone_core_get_ringback(LC)];
    
    self.echoCancellationEnabled = [NSNumber numberWithBool:linphone_core_echo_cancellation_enabled(LC)];
    self.videoPreviewEnabled = [NSNumber numberWithBool:linphone_core_video_preview_enabled(LC)];
    self.deviceRotation = [NSNumber numberWithInt:linphone_core_get_device_rotation(LC)];
    
    TTLinphoneAVPFMode *ttlinphoneAVPFMode = [[TTLinphoneAVPFMode alloc] init];
    [ttlinphoneAVPFMode parseLinphoneAVPFMode:linphone_core_get_avpf_mode(LC)];
    self.avpfMode = ttlinphoneAVPFMode;
    
    self.avpfRRInterval = [NSNumber numberWithInt:linphone_core_get_avpf_rr_interval(LC)];
    
    self.downloadBandwidth = [NSNumber numberWithInt:linphone_core_get_download_bandwidth(LC)];
    self.uploadBandwidth = [NSNumber numberWithInt:linphone_core_get_upload_bandwidth(LC)];
    
    self.adaptiveRateControlEnabled = [NSNumber numberWithBool:linphone_core_adaptive_rate_control_enabled(LC)];
    self.adaptiveRateAlgorithm = [NSString stringWithUTF8String:linphone_core_get_adaptive_rate_algorithm(LC)];
    self.downloadTime = [NSNumber numberWithInt:linphone_core_get_download_ptime(LC)];
    self.uploadPtime = [NSNumber numberWithInt:linphone_core_get_upload_ptime(LC)];
    self.sipTransportTimeout = [NSNumber numberWithInt:linphone_core_get_sip_transport_timeout(LC)];
    self.dnsSrvEnabled = [NSNumber numberWithBool:linphone_core_dns_srv_enabled(LC)];
    
    
    self.audioAdaptiveJittcompEnabled = [NSNumber numberWithBool:linphone_core_audio_adaptive_jittcomp_enabled(LC)];
    self.videoAdaptiveJittcompEnabled = [NSNumber numberWithBool:linphone_core_video_adaptive_jittcomp_enabled(LC)];
    const char *string =  linphone_core_get_remote_ringback_tone(LC);
    if (string) {
        self.remoteRingbackTone = [NSString stringWithUTF8String:string];
    }
    
    self.echoLimiterEnabled = [NSNumber numberWithBool:linphone_core_echo_limiter_enabled(LC)];
    self.videoEnabled = [NSNumber numberWithBool:linphone_core_video_enabled(LC)];
    self.videoCaptureEnabled = [NSNumber numberWithBool:linphone_core_video_capture_enabled(LC)];
    self.videoDisplayEnabled = [NSNumber numberWithBool:linphone_core_video_display_enabled(LC)];
    
    self.preferredFramerate = [NSNumber numberWithFloat:linphone_core_get_preferred_framerate(LC)];
    self.staticPicture = [NSString stringWithUTF8String:linphone_core_get_static_picture(LC)];
    self.staticPictureFps = [NSNumber numberWithFloat:linphone_core_get_static_picture_fps(LC)];
    self.playFile = [NSString stringWithUTF8String:linphone_core_get_play_file(LC)];
    string = linphone_core_get_record_file(LC);
    if (string) {
        self.recordFile = [NSString stringWithUTF8String:string];
    }
    
    TTLinphoneMediaEncryption *ttlinphoneMediaEncryption = [[TTLinphoneMediaEncryption alloc] init];
    [ttlinphoneMediaEncryption parseLinphoneMediaEncryption:linphone_core_get_media_encryption(LC)];
    self.mediaEncryption = ttlinphoneMediaEncryption;
    
    self.isMediaEncryptionMandatory = [NSNumber numberWithBool:linphone_core_is_media_encryption_mandatory(LC)];
    
    self.supportedFileFormats = [NSString stringWithUTF8String:*linphone_core_get_supported_file_formats(LC)];
    self.audioMulticastAddress = [NSString stringWithUTF8String:linphone_core_get_audio_multicast_addr(LC)];;
    self.videoMulticastAddress = [NSString stringWithUTF8String:linphone_core_get_video_multicast_addr(LC)];
    
    self.audioMulticastTtl = [NSNumber numberWithInt:linphone_core_get_audio_multicast_ttl(LC)];
    self.videoMulticastTtl = [NSNumber numberWithInt:linphone_core_get_video_multicast_ttl(LC)];
    
    self.audioMulticastEnabled = [NSNumber numberWithBool:linphone_core_audio_multicast_enabled(LC)];
    self.videoMulticastEnabled = [NSNumber numberWithBool:linphone_core_video_multicast_enabled(LC)];
    
    string = linphone_core_get_video_display_filter(LC);
    if (string) {
        self.videoDisplayFilter = [NSString stringWithUTF8String:string];
    }
    self.selfViewEnabled = [NSNumber numberWithBool:linphone_core_self_view_enabled(LC)];
    
    self.micEnabled = [NSNumber numberWithBool:linphone_core_mic_enabled(LC)];
    self.preferredVideoSize = [TTMediaParameters getTTMSVideoSize:linphone_core_get_preferred_video_size(LC)];
    self.currentPreviewVideoSize = [TTMediaParameters getTTMSVideoSize:linphone_core_get_current_preview_video_size(LC)];
    self.previewVideoSize = [TTMediaParameters getTTMSVideoSize:linphone_core_get_preview_video_size(LC)];
    
    const LinphoneVideoPolicy *videoPolicy = linphone_core_get_video_policy(LC);
    self.automaticallyInitiate = [NSNumber numberWithBool:videoPolicy->automatically_initiate];
    self.automaticallyAccept = [NSNumber numberWithBool:videoPolicy->automatically_accept];
    
    self.mtu = [NSNumber numberWithInt:linphone_core_get_mtu(LC)];
    
    self.ringDuringIncomingEarlyMedia = [NSNumber numberWithBool:linphone_core_get_ring_during_incoming_early_media(LC)];
    
    self.useFiles = [NSNumber numberWithBool:linphone_core_get_use_files(LC)];
}

+(TTMSVideoSize*) getTTMSVideoSize:(MSVideoSize)videoSize {
    TTMSVideoSize* ttmsvideoSize = [[TTMSVideoSize alloc] init];
    [ttmsvideoSize parseMSVideoSize:videoSize];
    return ttmsvideoSize;
}

@end
