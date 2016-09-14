//
//  TTLinphoneAVPFMode.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneAVPFMode : NSObject

@property (nonatomic, strong) NSString* avpfMode;

-(void)parseLinphoneAVPFMode:(LinphoneAVPFMode)linphoneAVPFMode;
+(LinphoneAVPFMode)getLinphoneAVPFModeWithString:(NSString*)linphoneAVPFModeString;

@end
