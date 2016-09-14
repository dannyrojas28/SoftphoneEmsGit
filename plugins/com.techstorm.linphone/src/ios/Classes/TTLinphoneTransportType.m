//
//  TTLinphoneTransportType.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLinphoneTransportType.h"

@implementation TTLinphoneTransportType

-(void)parseLinphoneTransportType:(LinphoneTransportType)linphoneTransportType {
    if (linphoneTransportType == LinphoneTransportUdp) {
        self.transportType = @"TransportUdp";
    } else if (linphoneTransportType == LinphoneTransportTcp) {
        self.transportType = @"TransportTcp";
    } else if (linphoneTransportType == LinphoneTransportTls) {
        self.transportType = @"TransportTls";
    } else if (linphoneTransportType == LinphoneTransportDtls) {
        self.transportType = @"TransportDtls";
    }
}

+(LinphoneTransportType)getLinphoneTransportTypeWithString:(NSString*)linphoneTransportTypeString {
    if ([linphoneTransportTypeString isEqualToString:@"TransportUdp"]) {
        return LinphoneTransportUdp;
    } else if ([linphoneTransportTypeString isEqualToString:@"TransportTcp"]) {
        return LinphoneTransportTcp;
    } else if ([linphoneTransportTypeString isEqualToString:@"TransportTls"]) {
        return LinphoneTransportTls;
    } else if ([linphoneTransportTypeString isEqualToString:@"TransportDtls"]) {
        return LinphoneTransportDtls;
    }
    return NULL;
}

@end
