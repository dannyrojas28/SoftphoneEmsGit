//
//  TTLinphoneCallDir.h
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import <Foundation/Foundation.h>
#include "linphone/linphonecore.h"

@interface TTLinphoneCallDir : NSObject

@property (nonatomic, strong) NSString* callDir;

-(void)parseLinphoneCallDirection:(LinphoneCallDir)linphoneCallDir;
+(LinphoneCallDir)getLinphoneCallDirectionWithString:(NSString*)linphoneCallDirString;

@end
