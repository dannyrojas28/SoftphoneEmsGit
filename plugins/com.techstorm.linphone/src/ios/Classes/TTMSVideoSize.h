//
//  TTMSVideoSize.h
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTMSVideoSize : NSObject

@property (nonatomic, strong) NSNumber* width; // int
@property (nonatomic, strong) NSNumber* height; // int


-(void)parseMSVideoSize:(MSVideoSize)msvideoSize;

@end
