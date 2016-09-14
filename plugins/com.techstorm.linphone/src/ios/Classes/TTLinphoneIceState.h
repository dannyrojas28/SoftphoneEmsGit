//
//  TTLinphoneIceState.h
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneIceState : NSObject

@property (nonatomic, strong) NSString* iceState;
@property (nonatomic, strong) NSString* iceStateString;

-(void)parseLinphoneIceState:(LinphoneIceState)linphoneIceState;
+(LinphoneIceState)getLinphoneIceStateWithString:(NSString*)linphoneIceStateString;

@end
