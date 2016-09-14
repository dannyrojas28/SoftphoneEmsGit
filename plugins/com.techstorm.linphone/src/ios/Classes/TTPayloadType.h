//
//  TTPayloadType.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

@interface TTPayloadType : NSObject

@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, strong) NSNumber *clockRate; // int
@property (nonatomic, strong) NSNumber *channels; // int
@property (nonatomic, strong) NSNumber *payloadTypeEnabled; // BOOL
@property (nonatomic, strong) NSNumber *isVbr; // BOOL
@property (nonatomic, strong) NSNumber *bitrate; // int
@property (nonatomic, strong) NSNumber *number; // int



-(void)parsePayloadType:(const PayloadType*)payloadType;

@end
