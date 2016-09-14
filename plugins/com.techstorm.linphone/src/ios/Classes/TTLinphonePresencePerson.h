//
//  TTLinphonePresencePerson.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"


@interface TTLinphonePresencePerson : NSObject

@property (nonatomic, strong) NSString* personId;
@property (nonatomic, strong) NSNumber* numberOfActivities; // unsigned int
@property (nonatomic, strong) NSNumber* numberOfNotes; // unsigned int
@property (nonatomic, strong) NSNumber* numberOfActivitiesNotes; // unsigned int

-(void) parseLinphonePresencePerson:(LinphonePresencePerson*)linphonePresencePerson;

@end
