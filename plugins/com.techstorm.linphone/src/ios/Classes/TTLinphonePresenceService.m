//
//  TTLinphonePresenceService.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphonePresenceService.h"

@implementation TTLinphonePresenceService

-(void) parseLinphonePresenceService:(LinphonePresenceService*)linphonePresenceService {
    TTLinphonePresenceBasicStatus *ttlinphonePresenceBasicStatus = [[TTLinphonePresenceBasicStatus alloc] init];
    [ttlinphonePresenceBasicStatus parseLinphonePresenceBasicStatus:linphone_presence_service_get_basic_status(linphonePresenceService)];
    self.basicStatus = ttlinphonePresenceBasicStatus;
    
    const char* string = linphone_presence_service_get_contact(linphonePresenceService);
    if (string) {
        self.contact = [NSString stringWithUTF8String:string];
    }
    self.numberOfNotes = [NSNumber numberWithUnsignedInteger:linphone_presence_service_get_nb_notes(linphonePresenceService)];
    string = linphone_presence_service_get_id(linphonePresenceService);
    if (string) {
        self.serviceId = [NSString stringWithUTF8String:string];
    }
}

@end
