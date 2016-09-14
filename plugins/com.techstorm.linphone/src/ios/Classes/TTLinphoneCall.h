//
//  TTLinphoneCall.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphoneCallParams.h"
#import "TTCallLog.h"

@interface TTLinphoneCall : NSObject

@property (nonatomic, strong) NSNumber* playVolume; // float
@property (nonatomic, strong) NSNumber* recordVolume; // float
@property (nonatomic, strong) NSNumber* speakerVolumeGain; // float
@property (nonatomic, strong) NSNumber* microphoneVolumeGain; // float
@property (nonatomic, strong) NSNumber* currentQuality; // float
@property (nonatomic, strong) NSNumber* averageQuality; // float
@property (nonatomic, strong) NSNumber* mediaInProgress; // BOOL
@property (nonatomic, strong) NSNumber* echoCancellationEnabled; // BOOL
@property (nonatomic, strong) NSNumber* echoLimiterEnabled; // BOOL
@property (nonatomic, strong) TTLinphoneCallParams* callParams;
@property (nonatomic, strong) TTCallLog* callLog;

-(void)parseLinphoneCall:(LinphoneCall*)call;

@end
