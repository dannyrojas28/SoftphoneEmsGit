//
//  TTConference.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTConference : NSObject

@property (nonatomic, strong) NSNumber* localInputVolume; // float
@property (nonatomic, strong) NSNumber* size; // int
@property (nonatomic, strong) NSNumber* isConference; // BOOL

-(void)parseLinphoneCore:(LinphoneCore*)LC;

@end
