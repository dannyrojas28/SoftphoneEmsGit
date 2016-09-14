//
//  LinphoneMediaEncryption.h
//  HelloCordova
//
//  Created by Thien on 5/17/16.
//
//

#import <Foundation/Foundation.h>
#include "linphone/linphonecore.h"

@interface TTLinphoneMediaEncryption : NSObject

@property (nonatomic, strong) NSString* mediaEncryption;
@property (nonatomic, strong) NSString* mediaEncryptionString;

-(void)parseLinphoneMediaEncryption:(LinphoneMediaEncryption)linphoneMediaEncryption;
+(LinphoneMediaEncryption)getLinphoneMediaEncryptionWithString:(NSString*)linphoneMediaEncryptionString;

@end
