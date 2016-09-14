//
//  TTLinphoneUpnpState.h
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneUpnpState : NSObject

@property (nonatomic, strong) NSString* upnpState;

-(void)parseLinphoneUpnpState:(LinphoneUpnpState)linphoneUpnpState;
+(LinphoneUpnpState)getLinphoneUpnpStateWithString:(NSString*)LinphoneUpnpStateString;

@end
