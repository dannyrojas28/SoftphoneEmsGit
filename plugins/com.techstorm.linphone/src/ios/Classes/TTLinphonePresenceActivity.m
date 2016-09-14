//
//  TTLinphonePresenceActivity.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphonePresenceActivity.h"

@implementation TTLinphonePresenceActivity

-(void) parseLinphonePresenceActivity:(LinphonePresenceActivity*)linphonePresenceActivity {
    const char* string = linphone_presence_activity_to_string(linphonePresenceActivity);
    if (string) {
        self.presenceActivityString = [NSString stringWithUTF8String:string];
    }
    
    TTLinphonePresenceActivityType* ttlinphonePresenceActivityType = [[TTLinphonePresenceActivityType alloc] init];
    [ttlinphonePresenceActivityType parseLinphonePresenceActivityType:linphone_presence_activity_get_type(linphonePresenceActivity)];
    self.presenceActivityType = ttlinphonePresenceActivityType;
    
    string = linphone_presence_activity_get_description(linphonePresenceActivity);
    if (string) {
        self.activityDescription = [NSString stringWithUTF8String:string];
    }
}

@end
