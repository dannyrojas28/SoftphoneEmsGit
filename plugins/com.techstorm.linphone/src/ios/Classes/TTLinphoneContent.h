//
//  TTLinphoneContent.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>
#include "linphone/linphonecore.h"

@interface TTLinphoneContent : NSObject

-(void)parseLinphoneContent:(const LinphoneContent*)linphoneContent;

@end
