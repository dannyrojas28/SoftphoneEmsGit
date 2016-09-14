//
//  TTPayloadType.m
//  HelloCordova
//
//  Created by Thien on 5/18/16.
//
//

#import "TTPayloadType.h"

#import "Utils.h"

@implementation TTPayloadType

-(void)parsePayloadType:(const PayloadType*)payloadType {
    self.mimeType = [NSString stringWithUTF8String:payloadType->mime_type];
    self.clockRate = [NSNumber numberWithInt:payloadType->clock_rate];
    self.channels = [NSNumber numberWithInt:payloadType->channels];
    self.payloadTypeEnabled = [NSNumber numberWithBool:linphone_core_payload_type_enabled(LC, payloadType)];
    self.isVbr = [NSNumber numberWithBool:linphone_core_payload_type_is_vbr(LC, payloadType)];
    self.bitrate = [NSNumber numberWithInt:linphone_core_get_payload_type_bitrate(LC, payloadType)];
    self.number = [NSNumber numberWithInt:linphone_core_get_payload_type_number(LC, payloadType)];
}

@end
