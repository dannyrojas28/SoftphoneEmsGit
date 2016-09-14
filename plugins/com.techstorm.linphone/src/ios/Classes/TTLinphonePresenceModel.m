//
//  TTLinphonePresenceModel.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphonePresenceModel.h"



@implementation TTLinphonePresenceModel

-(void)parseLinphonePresenceModel:(LinphonePresenceModel*)linphonePresenceModel {
    self.timestamp = [NSNumber numberWithLong:linphone_presence_model_get_timestamp(linphonePresenceModel)];
    const char* string = linphone_presence_model_get_contact(linphonePresenceModel);
    if (string) {
        self.contact = [NSString stringWithUTF8String:string];
    }
    
    LinphonePresenceActivity* linphonePresenceActivity = linphone_presence_model_get_activity(linphonePresenceModel);
    if (linphonePresenceActivity) {
        TTLinphonePresenceActivity*  ttlinphonePresenceActivity = [[TTLinphonePresenceActivity alloc] init];
        [ttlinphonePresenceActivity parseLinphonePresenceActivity:linphonePresenceActivity];
        self.activity = ttlinphonePresenceActivity;
    }
    
    
    TTLinphonePresenceBasicStatus* ttlinphonePresenceBasicStatus = [[TTLinphonePresenceBasicStatus alloc] init];
    [ttlinphonePresenceBasicStatus parseLinphonePresenceBasicStatus:linphone_presence_model_get_basic_status(linphonePresenceModel)];
    self.basicStatus = ttlinphonePresenceBasicStatus;
    
    self.numberOfServices = [NSNumber numberWithUnsignedInteger:linphone_presence_model_get_nb_services(linphonePresenceModel)];
    self.numberOfPersons = [NSNumber numberWithUnsignedInteger:linphone_presence_model_get_nb_persons(linphonePresenceModel)];
}

@end
