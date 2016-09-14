//
//  TTLinphonePresencePerson.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphonePresencePerson.h"

@implementation TTLinphonePresencePerson

-(void) parseLinphonePresencePerson:(LinphonePresencePerson*)linphonePresencePerson {
    const char* string = linphone_presence_person_get_id(linphonePresencePerson);
    if (string) {
        self.personId = [NSString stringWithUTF8String:string];
    }
    self.numberOfActivities = [NSNumber numberWithUnsignedInteger:linphone_presence_person_get_nb_activities(linphonePresencePerson)];
    self.numberOfNotes = [NSNumber numberWithUnsignedInteger:linphone_presence_person_get_nb_notes(linphonePresencePerson)];
    self.numberOfActivitiesNotes = [NSNumber numberWithUnsignedInteger:linphone_presence_person_get_nb_activities_notes(linphonePresencePerson)];
    
}

@end
