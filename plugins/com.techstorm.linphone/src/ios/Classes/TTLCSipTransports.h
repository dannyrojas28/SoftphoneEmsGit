//
//  TTLCSipTransports.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLCSipTransports : NSObject

@property (nonatomic, strong) NSString* upnpState;

-(void)parseLCSipTransports:(LCSipTransports)lcsipTransports;
+(LCSipTransports)getLCSipTransportsWithString:(NSString*)lcsipTransportsString;

@end
