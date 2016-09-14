//
//  TTLinphoneErrorInfo.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTLinphoneErrorInfo : NSObject

-(void)parseLinphoneErrorInfo:(const LinphoneErrorInfo*)linphoneErrorInfo;

@end
