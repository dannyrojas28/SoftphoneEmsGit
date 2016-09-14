//
//  TTLinphoneCallParams.m
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import "TTLinphoneCallParams.h"

@implementation TTLinphoneCallParams



-(void)parseLinphoneCallParams:(const LinphoneCallParams*)linphoneCallParams {
    self.audioMulticastEnabled = [NSNumber numberWithBool:linphone_call_params_audio_multicast_enabled(linphoneCallParams)];
    self.videoMulticastEnabled = [NSNumber numberWithBool:linphone_call_params_video_multicast_enabled(linphoneCallParams)];
    self.realtimeTextEnabled = [NSNumber numberWithBool:linphone_call_params_realtime_text_enabled(linphoneCallParams)];
}
//LINPHONE_PUBLIC void 	linphone_call_params_enable_audio_multicast (LinphoneCallParams *param, bool_t yesno)
//
//LINPHONE_PUBLIC void 	linphone_call_params_enable_video_multicast (LinphoneCallParams *params, bool_t yesno)
//
//LINPHONE_PUBLIC int 	linphone_call_params_enable_realtime_text (LinphoneCallParams *params, bool_t yesno)
//
//LINPHONE_PUBLIC void 	linphone_call_params_add_custom_sdp_attribute (LinphoneCallParams *params, const char *attribute_name, const char *attribute_value)
//
//LINPHONE_PUBLIC void 	linphone_call_params_add_custom_sdp_media_attribute (LinphoneCallParams *params, LinphoneStreamType type, const char *attribute_name, const char *attribute_value)
//
//LINPHONE_PUBLIC const char * 	linphone_call_params_get_custom_sdp_attribute (const LinphoneCallParams *params, const char *attribute_name)
//
//LINPHONE_PUBLIC const char * 	linphone_call_params_get_custom_sdp_media_attribute (const LinphoneCallParams *params, LinphoneStreamType type, const char *attribute_name)
//
//LINPHONE_PUBLIC void 	linphone_call_params_clear_custom_sdp_attributes (LinphoneCallParams *params)
//
//LINPHONE_PUBLIC void 	linphone_call_params_clear_custom_sdp_media_attributes (LinphoneCallParams *params, LinphoneStreamType type)
@end
