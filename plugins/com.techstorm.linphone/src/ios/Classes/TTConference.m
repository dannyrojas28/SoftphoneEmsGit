//
//  TTConference.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTConference.h"

@implementation TTConference

-(void)parseLinphoneCore:(LinphoneCore*)LC {
    self.localInputVolume = [NSNumber numberWithFloat:linphone_core_get_conference_local_input_volume(LC)];
    self.size = [NSNumber numberWithInt:linphone_core_get_conference_size(LC)];
    self.isConference = [NSNumber numberWithBool:linphone_core_is_in_conference(LC)];
}


@end
