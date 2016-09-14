//
//  TTLinphoneCallParams.h
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneCallParams : NSObject

@property (nonatomic, strong) NSString* upnpState;

@property (nonatomic, strong) NSNumber* audioMulticastEnabled; // BOOL
@property (nonatomic, strong) NSNumber* videoMulticastEnabled; // BOOL
@property (nonatomic, strong) NSNumber* realtimeTextEnabled; // BOOL


-(void)parseLinphoneCallParams:(const LinphoneCallParams*)linphoneCallParams;

@end
