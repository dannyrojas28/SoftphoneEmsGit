//
//  TTLinphoneCallStatus.h
//  HelloCordova
//
//  Created by Thien on 5/14/16.
//
//

#import <Foundation/Foundation.h>
#include "linphone/linphonecore.h"

@interface TTLinphoneCallStatus : NSObject

@property (nonatomic, strong) NSString* callStatus;

-(void)parseLinphoneCallStatus:(LinphoneCallStatus)linphoneCallStatus;
+(LinphoneCallStatus)getLinphoneCallStatusWithString:(NSString*)linphoneCallStatusString;

@end
