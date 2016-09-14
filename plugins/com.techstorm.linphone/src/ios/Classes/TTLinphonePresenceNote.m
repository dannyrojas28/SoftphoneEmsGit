//
//  TTLinphonePresenceNote.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphonePresenceNote.h"

@implementation TTLinphonePresenceNote

-(void) parseLinphonePresenceNote:(LinphonePresenceNote*)linphonePresenceNote {
    self.lang = [NSString stringWithUTF8String:linphone_presence_note_get_lang(linphonePresenceNote)];
    self.content = [NSString stringWithUTF8String:linphone_presence_note_get_content(linphonePresenceNote)];
}

@end
