//
//  TTMediaParameters.h
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import <Foundation/Foundation.h>

#include "linphone/linphonecore.h"

#import "TTLinphoneAVPFMode.h"
#import "TTLinphoneMediaEncryption.h"
#import "TTMSVideoSize.h"

@interface TTMediaParameters : NSObject

@property (nonatomic, strong) NSNumber* audioJittcomp; // int
@property (nonatomic, strong) NSNumber* videoJittcomp; // int
@property (nonatomic, strong) NSNumber* nortpTimeout; // int
@property (nonatomic, strong) NSNumber* useInfoForDtmf; // BOOL
@property (nonatomic, strong) NSNumber* useRfc2833ForDtmf; // BOOL
@property (nonatomic, strong) NSNumber* playLevel; // int
@property (nonatomic, strong) NSNumber* ringLevel; // int
@property (nonatomic, strong) NSNumber* recLevel; // int

@property (nonatomic, strong) NSNumber* micGainDb; // float
@property (nonatomic, strong) NSNumber* playbackGainDb; // float

@property (nonatomic, strong) NSString* ringerDevice;
@property (nonatomic, strong) NSString* playbackDevice;
@property (nonatomic, strong) NSString* captureDevice;
@property (nonatomic, strong) NSString* soundDevices;
@property (nonatomic, strong) NSString* videoDevices;
@property (nonatomic, strong) NSString* videoDevice;
@property (nonatomic, strong) NSString* ring;
@property (nonatomic, strong) NSString* ringback;

@property (nonatomic, strong) NSNumber* echoCancellationEnabled; // BOOL
@property (nonatomic, strong) NSNumber* videoPreviewEnabled; // BOOL

@property (nonatomic, strong) NSNumber* deviceRotation; // int

@property (nonatomic, strong) TTLinphoneAVPFMode* avpfMode;
@property (nonatomic, strong) NSNumber* avpfRRInterval; // int
@property (nonatomic, strong) NSNumber* downloadBandwidth; // int
@property (nonatomic, strong) NSNumber* uploadBandwidth; // int

@property (nonatomic, strong) NSNumber* adaptiveRateControlEnabled; // BOOL
@property (nonatomic, strong) NSString* adaptiveRateAlgorithm;
@property (nonatomic, strong) NSNumber* downloadTime; // int
@property (nonatomic, strong) NSNumber* uploadPtime; // int
@property (nonatomic, strong) NSNumber* sipTransportTimeout; // int
@property (nonatomic, strong) NSNumber* dnsSrvEnabled; // BOOL


@property (nonatomic, strong) NSNumber* audioAdaptiveJittcompEnabled; // BOOL
@property (nonatomic, strong) NSNumber* videoAdaptiveJittcompEnabled; // BOOL

@property (nonatomic, strong) NSString* remoteRingbackTone;
@property (nonatomic, strong) NSNumber* echoLimiterEnabled; // BOOL
@property (nonatomic, strong) NSNumber* videoEnabled; // BOOL

@property (nonatomic, strong) NSNumber* videoCaptureEnabled; // BOOL
@property (nonatomic, strong) NSNumber* videoDisplayEnabled; // BOOL

@property (nonatomic, strong) NSNumber* preferredFramerate; // float
@property (nonatomic, strong) NSString* staticPicture;
@property (nonatomic, strong) NSNumber* staticPictureFps; // float
@property (nonatomic, strong) NSString* playFile;
@property (nonatomic, strong) NSString* recordFile;

@property (nonatomic, strong) TTLinphoneMediaEncryption* mediaEncryption;

@property (nonatomic, strong) NSNumber* isMediaEncryptionMandatory; // BOOL
@property (nonatomic, strong) NSString* supportedFileFormats;
@property (nonatomic, strong) NSString* audioMulticastAddress;
@property (nonatomic, strong) NSString* videoMulticastAddress;

@property (nonatomic, strong) NSNumber* audioMulticastTtl; // int
@property (nonatomic, strong) NSNumber* videoMulticastTtl; // int

@property (nonatomic, strong) NSNumber* audioMulticastEnabled; // BOOL
@property (nonatomic, strong) NSNumber* videoMulticastEnabled; // BOOL

@property (nonatomic, strong) NSString* videoDisplayFilter;

@property (nonatomic, strong) NSNumber* selfViewEnabled; // BOOL

@property (nonatomic, strong) NSNumber* micEnabled; // BOOL

@property (nonatomic, strong) TTMSVideoSize* preferredVideoSize;
@property (nonatomic, strong) TTMSVideoSize* currentPreviewVideoSize;
@property (nonatomic, strong) TTMSVideoSize* previewVideoSize;

@property (nonatomic, strong) NSNumber* automaticallyInitiate; // BOOL
@property (nonatomic, strong) NSNumber* automaticallyAccept; // BOOL

@property (nonatomic, strong) NSNumber* mtu; // int
@property (nonatomic, strong) NSNumber* ringDuringIncomingEarlyMedia; // BOOL

@property (nonatomic, strong) NSNumber* useFiles; // BOOL

-(void)parseLinphoneCore:(LinphoneCore*)LC;

@end
