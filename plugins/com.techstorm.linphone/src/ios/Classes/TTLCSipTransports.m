//
//  TTLCSipTransports.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTLCSipTransports.h"

@implementation TTLCSipTransports

-(void)parseLCSipTransports:(LCSipTransports)lcsipTransports {
//    if (lcsipTransports == udp_port) {
//        self.upnpState = @"UpnpStateIdle";
//    } else if (lcsipTransports == tcp_port) {
//        self.upnpState = @"UpnpStatePending";
//    } else if (lcsipTransports == LinphoneUpnpStateAdding) {
//        self.upnpState = @"UpnpStateAdding";
//    } else if (lcsipTransports == LinphoneUpnpStateRemoving) {
//        self.upnpState = @"UpnpStateRemoving";
//    } else if (lcsipTransports == LinphoneUpnpStateNotAvailable) {
//        self.upnpState = @"UpnpStateNotAvailable";
//    }
}
+(LCSipTransports)getLCSipTransportsWithString:(NSString*)lcsipTransportsString {
    
}

@end
