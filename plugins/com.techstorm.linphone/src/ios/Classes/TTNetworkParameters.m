//
//  TTNetworkParameters.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTNetworkParameters.h"

@implementation TTNetworkParameters

-(void)parseLinphoneCore:(LinphoneCore*)LC {
    self.audioPort = [NSNumber numberWithInt:linphone_core_get_audio_port(LC)];
    self.videoPort = [NSNumber numberWithInt:linphone_core_get_video_port(LC)];
    self.textPort = [NSNumber numberWithInt:linphone_core_get_text_port(LC)];
    self.audioPortRange = [self getAudioPortRange:LC];
    self.videoPortRange = [self getVideoPortRange:LC];
    self.textPortRange = [self getTextPortRange:LC];
    self.sipPort = [NSNumber numberWithInt:linphone_core_get_sip_port(LC)];
    self.isIpv6Enabled = [NSNumber numberWithBool:linphone_core_ipv6_enabled(LC)];
    self.sipDscp = [NSNumber numberWithInt:linphone_core_get_sip_dscp(LC)];
    self.audioDscp = [NSNumber numberWithInt:linphone_core_get_audio_dscp(LC)];
    self.videoDscp = [NSNumber numberWithInt:linphone_core_get_video_dscp(LC)];
    self.stunServer = [NSString stringWithUTF8String:linphone_core_get_stun_server(LC)];
    self.isUpnpAvailable = [NSNumber numberWithBool:linphone_core_upnp_available()];
    self.upnpState = [self getUpnpState:LC];
    const char* string = linphone_core_get_upnp_external_ipaddress(LC);
    if (string) {
        self.upnpExternalIpAddress = [NSString stringWithUTF8String:string];
    }
    string = linphone_core_get_nat_address(LC);
    if (string) {
        self.natAddress = [NSString stringWithUTF8String:string];
    }
    self.firewallPolicy = [self getFirewallPolicy:LC];
    self.isNetworkReachable = [NSNumber numberWithBool:linphone_core_is_network_reachable(LC)];
    self.keepAliveEnabled = [NSNumber numberWithBool:linphone_core_keep_alive_enabled(LC)];
    self.isSdp200AckEnabled = [NSNumber numberWithBool:linphone_core_sdp_200_ack_enabled(LC)];
    
    LCSipTransports data;
    linphone_core_get_sip_transports(LC, &data);
    self.udpPort = [NSNumber numberWithInt:data.udp_port];
    self.tcpPort = [NSNumber numberWithInt:data.tcp_port];
    self.dtlsPort = [NSNumber numberWithInt:data.dtls_port];
    self.tlsPort = [NSNumber numberWithInt:data.tls_port];
}

- (TTRange*) getAudioPortRange:(LinphoneCore*)LC  {
    int minPort, maxPort;
    linphone_core_get_audio_port_range(LC, &minPort, &maxPort);
    TTRange *ttrange = [[TTRange alloc] init];
    ttrange.min = [NSNumber numberWithInteger:minPort];
    ttrange.max = [NSNumber numberWithInteger:maxPort];
    return ttrange;
}


- (TTRange*) getVideoPortRange:(LinphoneCore*)LC  {
    int minPort, maxPort;
    linphone_core_get_video_port_range(LC, &minPort, &maxPort);
    TTRange *ttrange = [[TTRange alloc] init];
    ttrange.min = [NSNumber numberWithInteger:minPort];
    ttrange.max = [NSNumber numberWithInteger:maxPort];
    return ttrange;
}


- (TTRange*) getTextPortRange:(LinphoneCore*)LC  {
    int minPort, maxPort;
    linphone_core_get_text_port_range(LC, &minPort, &maxPort);
    TTRange *ttrange = [[TTRange alloc] init];
    ttrange.min = [NSNumber numberWithInteger:minPort];
    ttrange.max = [NSNumber numberWithInteger:maxPort];
    return ttrange;
}

-(TTLinphoneUpnpState*) getUpnpState:(LinphoneCore*)LC {
    TTLinphoneUpnpState *ttlinphoneUpnpState = [[TTLinphoneUpnpState alloc] init];
    [ttlinphoneUpnpState parseLinphoneUpnpState:linphone_core_get_upnp_state(LC)];
    return ttlinphoneUpnpState;
}

-(TTLinphoneFirewallPolicy*) getFirewallPolicy:(LinphoneCore*)LC {
    TTLinphoneFirewallPolicy *ttlinphoneFirewallPolicy = [[TTLinphoneFirewallPolicy alloc] init];
    [ttlinphoneFirewallPolicy parseLinphoneFirewallPolicy:linphone_core_get_firewall_policy(LC)];
    return ttlinphoneFirewallPolicy;
}

@end
