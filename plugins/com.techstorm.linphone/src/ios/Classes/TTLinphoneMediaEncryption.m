//
//  LinphoneMediaEncryption.m
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import "TTLinphoneMediaEncryption.h"

@implementation TTLinphoneMediaEncryption

-(void)parseLinphoneMediaEncryption:(LinphoneMediaEncryption)linphoneMediaEncryption {
    if (linphoneMediaEncryption == LinphoneMediaEncryptionNone) {
        self.mediaEncryption = @"MediaEncryptionNone";
    } else if (linphoneMediaEncryption == LinphoneMediaEncryptionSRTP) {
        self.mediaEncryption = @"MediaEncryptionSRTP";
    } else if (linphoneMediaEncryption == LinphoneMediaEncryptionZRTP) {
        self.mediaEncryption = @"MediaEncryptionZRTP";
    } else if (linphoneMediaEncryption == LinphoneMediaEncryptionDTLS) {
        self.mediaEncryption = @"MediaEncryptionDTLS";
    }
    self.mediaEncryptionString = [NSString stringWithUTF8String:linphone_media_encryption_to_string(linphoneMediaEncryption)];
}

+(LinphoneMediaEncryption)getLinphoneMediaEncryptionWithString:(NSString*)linphoneMediaEncryptionString {
    if ([linphoneMediaEncryptionString isEqualToString:@"MediaEncryptionSRTP"]) {
        return LinphoneMediaEncryptionSRTP;
    } else if ([linphoneMediaEncryptionString isEqualToString:@"MediaEncryptionZRTP"]) {
        return LinphoneMediaEncryptionZRTP;
    } else if ([linphoneMediaEncryptionString isEqualToString:@"MediaEncryptionDTLS"]) {
        return LinphoneMediaEncryptionDTLS;
    }
    
    return LinphoneMediaEncryptionNone;
}


@end
