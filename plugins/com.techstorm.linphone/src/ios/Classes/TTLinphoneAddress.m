
//  TTLinphoneAddress.m
//  HelloCordova
//
//  Created by Thien on 5/14/16.
//
//

#import "TTLinphoneAddress.h"

#import "Utils.h"

@implementation TTLinphoneAddress

-(void)parseLinphoneAddress:(const LinphoneAddress*)linphoneAddress {
    self.scheme = [NSString stringWithUTF8String:linphone_address_get_scheme(linphoneAddress)];
    const char * string = linphone_address_get_display_name(linphoneAddress);
    if (string) {
        self.displayName = [NSString stringWithUTF8String:string];
    }
    string = linphone_address_get_username(linphoneAddress);
    if (string) {
        self.username = [NSString stringWithUTF8String:string];
    }
    string = linphone_address_get_domain(linphoneAddress);
    if (string) {
        self.domain = [NSString stringWithUTF8String:string];
    }
    string = linphone_address_get_password(linphoneAddress);
    if (string) {
        self.password = [NSString stringWithUTF8String:string];
    }
    
    TTLinphoneTransportType *ttlinphoneTransportType = [[TTLinphoneTransportType alloc] init];
    [ttlinphoneTransportType parseLinphoneTransportType:linphone_address_get_transport(linphoneAddress)];
    self.transportType = ttlinphoneTransportType;
    
    string = linphone_address_as_string(linphoneAddress);
    if (string) {
        self.asString = [NSString stringWithUTF8String:string];
    }
    string = linphone_address_as_string_uri_only(linphoneAddress);
    if (string) {
        self.stringUriOnly = [NSString stringWithUTF8String:string];
    }
    self.isSecure = [NSNumber numberWithBool:linphone_address_is_secure(linphoneAddress)];
    self.secure = [NSNumber numberWithBool:linphone_address_get_secure(linphoneAddress)];
    self.isSip = [NSNumber numberWithBool:linphone_address_is_sip(linphoneAddress)];
    self.port = [NSNumber numberWithInt:linphone_address_get_port(linphoneAddress)];
    
}

+(LinphoneAddress*)getLinphoneAddressWithUsername:(NSString*)username domain:(NSString*)domain {
    NSString *address = [NSString stringWithFormat:@"sip:%@@%@", username, domain];
    LinphoneAddress *addr = linphone_address_new(address.UTF8String);
    return addr;
}

@end
