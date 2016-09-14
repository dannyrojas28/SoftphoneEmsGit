#import "LinphonePlugin.h"
#import "LinphoneHelper.h"
#import "LinphoneManager.h"
#import "TTLinphoneReason.h"


@implementation LinphonePlugin


- (void)initLinphoneCore:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) destroyLinphoneCore:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] destroyLinphoneCore];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) registerSIP:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* displayName = [[command arguments] objectAtIndex:1];
    NSString* domain = [[command arguments] objectAtIndex:2];
    NSString* password = [[command arguments] objectAtIndex:3];
    NSString* transport = [[command arguments] objectAtIndex:4];
    
    [[LinphoneHelper instance] registerSIPWithUsername:username displayName:displayName domain:domain password:password transport:transport];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) deregisterSIP:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    [[LinphoneHelper instance] deregisterSIPWithUsername:username domain:domain];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getRegisterStatusSIP:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult = nil;
    if ([[LinphoneHelper instance] getRegisterStatusSIPWithUsername:username domain:domain]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"RegistrationOk"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"RegistrationFailed"];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) makeCall:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* displayName = [[command arguments] objectAtIndex:2];
    
    [[LinphoneHelper instance] makeCallWithUsername:username domain:domain displayName:displayName];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) acceptCall:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] acceptCall];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) declineCall:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] declineCall];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) startListener:(CDVInvokedUrlCommand*)command {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLinphoneRegistrationUpdate object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notif) {
        
        NSString* message = [notif.userInfo objectForKey:@"message"];
        NSString* state = @"";
        NSNumber *number = [notif.userInfo objectForKey:@"state"];
        LinphoneRegistrationState registrationState = [number integerValue];
        if (registrationState == LinphoneRegistrationOk) {
            state = @"RegistrationOk";
        } else if (registrationState == LinphoneRegistrationNone) {
            state = @"RegistrationNone";
        } else if (registrationState == LinphoneRegistrationProgress) {
            state = @"RegistrationProgress";
        } else if (registrationState == LinphoneRegistrationCleared) {
            state = @"RegistrationCleared";
        } else if (registrationState == LinphoneRegistrationFailed) {
            state = @"RegistrationFailed";
        }
        
        
        NSString* username = @"";
        NSString* domain = @"";
        
        NSValue* cfg = [notif.userInfo objectForKey:@"cfg"];
        LinphoneProxyConfig* proxy = [cfg pointerValue];
        if (proxy != NULL) {
            const LinphoneAuthInfo *auth = linphone_proxy_config_find_auth_info(proxy);
            if (auth) {
                username = [NSString stringWithUTF8String:linphone_auth_info_get_username(auth)];
                domain = [NSString stringWithUTF8String:linphone_auth_info_get_domain(auth)];
            }
        }
        
        
        NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                           initWithObjectsAndKeys :
                                           @"REGISTRATION_CHANGE", @"event",
                                           message, @"message",
                                           username, @"username",
                                           domain, @"domain",
                                           state, @"state",
                                           nil
                                           ];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLinphoneCallUpdate object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notif) {
        
        
        NSString* message = [notif.userInfo objectForKey:@"message"];
        NSString* state = @"";
        NSNumber *number = [notif.userInfo objectForKey:@"state"];
        LinphoneCallState callState = [number integerValue];
        if (callState == LinphoneCallIdle) {
            state = @"Idle";
        } else if (callState == LinphoneCallIncomingReceived) {
            state = @"IncomingReceived";
        } else if (callState == LinphoneCallOutgoingInit) {
            state = @"OutgoingInit";
        } else if (callState == LinphoneCallOutgoingProgress) {
            state = @"OutgoingProgress";
        } else if (callState == LinphoneCallOutgoingRinging) {
            state = @"OutgoingRinging";
        } else if (callState == LinphoneCallOutgoingEarlyMedia) {
            state = @"OutgoingEarlyMedia";
        } else if (callState == LinphoneCallConnected) {
            state = @"Connected";
        } else if (callState == LinphoneCallStreamsRunning) {
            state = @"StreamsRunning";
        } else if (callState == LinphoneCallPausing) {
            state = @"Pausing";
        } else if (callState == LinphoneCallPaused) {
            state = @"Paused";
        } else if (callState == LinphoneCallResuming) {
            state = @"Resuming";
        } else if (callState == LinphoneCallRefered) {
            state = @"Refered";
        } else if (callState == LinphoneCallError) {
            state = @"OutgoingRinging";
        } else if (callState == LinphoneCallEnd) {
            state = @"CallEnd";
        } else if (callState == LinphoneCallPausedByRemote) {
            state = @"PausedByRemote";
        } else if (callState == LinphoneCallUpdatedByRemote) {
            state = @"UpdatedByRemote";
        } else if (callState == LinphoneCallIncomingEarlyMedia) {
            state = @"IncomingEarlyMedia";
        } else if (callState == LinphoneCallUpdating) {
            state = @"Updating";
        } else if (callState == LinphoneCallReleased) {
            state = @"Released";
        } else if (callState == LinphoneCallEarlyUpdatedByRemote) {
            state = @"EarlyUpdatedByRemote";
        } else if (callState == LinphoneCallEarlyUpdating) {
            state = @"EarlyUpdating";
        }
        
        NSString* caller = @"";
        NSString* callee = @"";
        
        NSValue* callValue = [notif.userInfo objectForKey:@"call"];
        LinphoneCall* call = [callValue pointerValue];
        if (call) {
            LinphoneCallLog *callLog = linphone_call_get_call_log(call);
            if (callLog) {
                LinphoneAddress* callerAddress = linphone_call_log_get_from_address(callLog);
                if (callerAddress) {
                    const char *username = linphone_address_get_username(callerAddress);
                    caller = [NSString stringWithUTF8String:username];
                }
                LinphoneAddress* calleeAddress = linphone_call_log_get_to_address(callLog);
                if (calleeAddress) {
                    const char *username = linphone_address_get_username(calleeAddress);
                    callee = [NSString stringWithUTF8String:username];
                }
            }
        }
        NSString* event = @"CALL_EVENT";
        if (callState == LinphoneCallIncomingReceived) {
            event = @"";
        }
        
        NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                           initWithObjectsAndKeys :
                                           event, @"event",
                                           message, @"message",
                                           caller, @"caller",
                                           callee, @"callee",
                                           state, @"state",
                                           nil
                                           ];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLinphoneMessageReceived object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notif) {
        
        LinphoneAddress *from = [[[notif userInfo] objectForKey:@"from_address"] pointerValue];
//        LinphoneChatRoom *room = [[notif.userInfo objectForKey:@"room"] pointerValue];
        LinphoneChatMessage *chat = [[notif.userInfo objectForKey:@"message"] pointerValue];
        NSString *callId = [notif.userInfo objectForKey:@"call-id"];
        
        TTLinphoneAddress* ttlinphoneAddress = [[TTLinphoneAddress alloc] init];
        [ttlinphoneAddress parseLinphoneAddress:from];
        
        TTLinphoneChatMessage* ttlinphoneChatMessage = [[TTLinphoneChatMessage alloc] init];
        [ttlinphoneChatMessage parseLinphoneChatMessage:chat];
        
        
        NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                           initWithObjectsAndKeys :
                                           @"MESSAGE_RECEIVED", @"event",
                                           [LinphonePlugin applyString:ttlinphoneChatMessage.text], @"message",
                                           [LinphonePlugin applyString:ttlinphoneAddress.username], @"fromUsername",
                                           [LinphonePlugin applyString:ttlinphoneAddress.domain], @"fromDomain",
                                           ttlinphoneChatMessage.storageId, @"storageId",
                                           [LinphonePlugin applyString:ttlinphoneChatMessage.externalBodyUrl], @"imageFileUrl",
                                           nil
                                           ];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLinphoneTextComposeEvent object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notif) {
        
        LinphoneChatRoom *room = [[[notif userInfo] objectForKey:@"room"] pointerValue];
        
        TTLinphoneChatRoom* ttlinphoneChatRoom = [[TTLinphoneChatRoom alloc] init];
        [ttlinphoneChatRoom parseLinphoneChatRoom:room];
        
        
        NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                           initWithObjectsAndKeys :
                                           @"TEXT_COMPOSE", @"event",
                                           ttlinphoneChatRoom.peerAddress.username, @"peerAddress$username",
                                           ttlinphoneChatRoom.peerAddress.domain, @"peerAddress$domain",
                                           ttlinphoneChatRoom.isRemoteComposing, @"isRemoteComposing",
                                           nil
                                           ];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLinphoneDtmfReceived object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notif) {
        
        LinphoneCall *call = [[[notif userInfo] objectForKey:@"call"] pointerValue];
        NSNumber *dtmf = [[notif userInfo] objectForKey:@"dtmf"];
        
        TTLinphoneCall* ttlinphoneCall = [[TTLinphoneCall alloc] init];
        [ttlinphoneCall parseLinphoneCall:call];
        
        
        NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                           initWithObjectsAndKeys :
                                           @"DTMF_RECEIVED", @"event",
                                           ttlinphoneCall.callLog.remoteAddress.username, @"peerUsername",
                                           ttlinphoneCall.callLog.remoteAddress.domain, @"peerDomain",
                                           ttlinphoneCall.callLog.callId, @"callId",
                                           [NSString stringWithFormat:@"%c", [dtmf intValue]], @"dtmf",
                                           nil
                                           ];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLinphoneFileTransferSendUpdate object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notif) {
        
        LinphoneChatMessageState state = [[[notif userInfo] objectForKey:@"state"] intValue];
        TTLinphoneChatMessageState *ttlinphoneChatMessageState = [[TTLinphoneChatMessageState alloc] init];
        [ttlinphoneChatMessageState parseLinphoneChatMessageState:state];
        
        float progress = [[[notif userInfo] objectForKey:@"progress"] floatValue];
        
        NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                           initWithObjectsAndKeys :
                                           @"FILE_TRANSFER_SEND_UPDATE", @"event",
                                           [LinphonePlugin applyString:ttlinphoneChatMessageState.chatMessageState], @"chatMessageState",
                                           [NSNumber numberWithFloat:progress], @"progress",
                                           nil
                                           ];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kLinphoneFileTransferRecvUpdate object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notif) {
        
        LinphoneChatMessageState state = [[[notif userInfo] objectForKey:@"state"] intValue];
        TTLinphoneChatMessageState *ttlinphoneChatMessageState = [[TTLinphoneChatMessageState alloc] init];
        [ttlinphoneChatMessageState parseLinphoneChatMessageState:state];
        
        float progress = [[[notif userInfo] objectForKey:@"progress"] floatValue];
        
        NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                           initWithObjectsAndKeys :
                                           @"FILE_TRANSFER_RECV_UPDATE", @"event",
                                           [LinphonePlugin applyString:ttlinphoneChatMessageState.chatMessageState], @"chatMessageState",
                                           [NSNumber numberWithFloat:progress], @"progress",
                                           nil
                                           ];
        
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}


#pragma mark - Obtaining information about a running call: sound volumes, quality indicators Functions

- (void) getCallInformation:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        TTLinphoneCall* callInformation = [[LinphoneHelper instance] getTTLinphoneCall:call];
        
        NSDictionary *resultDict = [LinphonePlugin getCallDictionary:callInformation];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getCallInformationWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        TTLinphoneCall* callInformation = [[LinphoneHelper instance] getTTLinphoneCall:call];
        
        NSDictionary *resultDict = [LinphonePlugin getCallDictionary:callInformation];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) terminateCall:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        [[LinphoneHelper instance] terminateCall:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) terminateCallWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        [[LinphoneHelper instance] terminateCall:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) sendDtmf:(CDVInvokedUrlCommand*)command {
    NSString* keyCode = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        if (keyCode && keyCode.length > 0) {
            const char key = *[[keyCode substringToIndex:1] UTF8String];
            [[LinphoneHelper instance] sendDtmf:call dtmf:key];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"keyCode must be not empty."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) sendDtmfWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    NSString* keyCode = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        if (keyCode && keyCode.length > 0) {
            const char key = *[[keyCode substringToIndex:1] UTF8String];
            [[LinphoneHelper instance] sendDtmf:call dtmf:key];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"keyCode must be not empty."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) muteCall:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] enableMic:FALSE];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) unmuteCall:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] enableMic:TRUE];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableSpeaker:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] enableSpeaker];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) disableSpeaker:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] disableSpeaker];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) holdCall:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        [[LinphoneHelper instance] holdCall:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) holdCallWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        [[LinphoneHelper instance] holdCall:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) unholdCall:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        [[LinphoneHelper instance] unholdCall:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) unholdCallWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        [[LinphoneHelper instance] unholdCall:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setSpeakerVolumeGain:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        NSNumber* volume = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] setSpeakerVolumeGain:call volume:[volume intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setSpeakerVolumeGainWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        NSNumber* volume = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] setSpeakerVolumeGain:call volume:[volume intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setMicrophoneVolumeGain:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        NSNumber* volume = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] setMicrophoneVolumeGain:call volume:[volume intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setMicrophoneVolumeGainWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        NSNumber* volume = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] setMicrophoneVolumeGain:call volume:[volume intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getAudioStats:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        TTLinphoneCallStats* callStats = [[LinphoneHelper instance] getAudioStats:call];
        NSDictionary *resultDict = [LinphonePlugin getTTLinphoneCallStatsDictionary:callStats];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getAudioStatsWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        TTLinphoneCallStats* callStats = [[LinphoneHelper instance] getAudioStats:call];
        NSDictionary *resultDict = [LinphonePlugin getTTLinphoneCallStatsDictionary:callStats];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getVideoStats:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        TTLinphoneCallStats* callStats = [[LinphoneHelper instance] getVideoStats:call];
        NSDictionary *resultDict = [LinphonePlugin getTTLinphoneCallStatsDictionary:callStats];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getVideoStatsWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        TTLinphoneCallStats* callStats = [[LinphoneHelper instance] getVideoStats:call];
        NSDictionary *resultDict = [LinphonePlugin getTTLinphoneCallStatsDictionary:callStats];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getTextStats:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        TTLinphoneCallStats* callStats = [[LinphoneHelper instance] getTextStats:call];
        NSDictionary *resultDict = [LinphonePlugin getTTLinphoneCallStatsDictionary:callStats];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getTextStatsWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        TTLinphoneCallStats* callStats = [[LinphoneHelper instance] getTextStats:call];
        NSDictionary *resultDict = [LinphonePlugin getTTLinphoneCallStatsDictionary:callStats];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) startRecording:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        [[LinphoneHelper instance] startRecording:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) startRecordingWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        [[LinphoneHelper instance] startRecording:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) stopRecording:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        [[LinphoneHelper instance] stopRecording:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) stopRecordingWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        [[LinphoneHelper instance] stopRecording:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) linphoneCallEnableEchoCancellation:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        NSNumber* enabled = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] linphoneCallEnableEchoCancellation:[enabled boolValue] linphoneCall:call];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) linphoneCallEnableEchoCancellationWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        NSNumber* enabled = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] linphoneCallEnableEchoCancellation:[enabled boolValue] linphoneCall:call];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) linphoneCallEnableEchoLimiter:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getCurrentCall];
    if (call) {
        NSNumber* enabled = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] linphoneCallEnableEchoLimiter:[enabled boolValue] linphoneCall:call];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No current call."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) linphoneCallEnableEchoLimiterWithCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    LinphoneCall *call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        NSNumber* enabled = [[command arguments] objectAtIndex:0];
        [[LinphoneHelper instance] linphoneCallEnableEchoLimiter:[enabled boolValue] linphoneCall:call];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - Controlling network parameters (ports, mtu...) Functions

- (void) setAudioPort:(CDVInvokedUrlCommand*)command {
    NSNumber* port = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAudioPort:[port intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setVideoPort:(CDVInvokedUrlCommand*)command {
    NSNumber* port = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoPort:[port intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setTextPort:(CDVInvokedUrlCommand*)command {
    NSNumber* port = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setTextPort:[port intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setSipPort:(CDVInvokedUrlCommand*)command {
    NSNumber* port = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setSipPort:[port intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setSipTransport:(CDVInvokedUrlCommand*)command {
    NSNumber* udpPort = [[command arguments] objectAtIndex:0];
    NSNumber* tcpPort = [[command arguments] objectAtIndex:1];
    NSNumber* dtlsPort = [[command arguments] objectAtIndex:2];
    NSNumber* tlsPort = [[command arguments] objectAtIndex:3];
    LCSipTransports data;
    data.udp_port = [udpPort intValue];
    data.tcp_port = [tcpPort intValue];
    data.dtls_port = [dtlsPort intValue];
    data.tls_port = [tlsPort intValue];
    [[LinphoneHelper instance] setSipTransport:&data];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableIpv6:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableIpv6:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setSipDscp:(CDVInvokedUrlCommand*)command {
    NSNumber* dscp = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setSipDscp:[dscp intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setAudioDscp:(CDVInvokedUrlCommand*)command {
    NSNumber* dscp = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAudioDscp:[dscp intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setVideoDscp:(CDVInvokedUrlCommand*)command {
    NSNumber* dscp = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoDscp:[dscp intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setStunServer:(CDVInvokedUrlCommand*)command {
    NSString* stunServer = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setStunServer:stunServer];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setNatAddress:(CDVInvokedUrlCommand*)command {
    NSString* natAddress = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setNatAddress:natAddress];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setFirewallPolicy:(CDVInvokedUrlCommand*)command {
    NSString* firewallPolicy = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setFirewallPolicy:firewallPolicy];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setNetworkReachable:(CDVInvokedUrlCommand*)command {
    NSNumber* networkReachable = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setNetworkReachable:[networkReachable boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableKeepAlive:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableKeepAlive:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableSdp200Ack:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableSdp200Ack:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNetworkParameters:(CDVInvokedUrlCommand*)command {
    TTNetworkParameters* networkParameters = [[LinphoneHelper instance] getNetworkParameters];
    
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       networkParameters.audioPort, @"audioPort",
                                       networkParameters.videoPort, @"videoPort",
                                       networkParameters.textPort, @"textPort",
                                       networkParameters.audioPortRange.min, @"audioPortRange$min",
                                       networkParameters.audioPortRange.max, @"audioPortRange$max",
                                       networkParameters.videoPortRange.min, @"videoPortRange$min",
                                       networkParameters.videoPortRange.max, @"videoPortRange$max",
                                       networkParameters.textPortRange.min, @"textPortRange$min",
                                       networkParameters.textPortRange.max, @"textPortRange$max",
                                       networkParameters.sipPort, @"sipPort",
                                       networkParameters.isIpv6Enabled, @"isIpv6Enabled",
                                       networkParameters.sipDscp, @"sipDscp",
                                       networkParameters.audioDscp, @"audioDscp",
                                       networkParameters.videoDscp, @"videoDscp",
                                       [LinphonePlugin applyString:networkParameters.stunServer], @"stunServer",
                                       networkParameters.isUpnpAvailable, @"isUpnpAvailable",
                                       [LinphonePlugin applyString:networkParameters.upnpState.upnpState], @"upnpState",
                                       [LinphonePlugin applyString:networkParameters.upnpExternalIpAddress], @"upnpExternalIpAddress",
                                       [LinphonePlugin applyString:networkParameters.natAddress], @"natAddress",
                                       networkParameters.firewallPolicy.firewallPolicy, @"firewallPolicy",
                                       networkParameters.isNetworkReachable, @"isNetworkReachable",
                                       networkParameters.keepAliveEnabled, @"keepAliveEnabled",
                                       networkParameters.isSdp200AckEnabled, @"isSdp200AckEnabled",
                                       networkParameters.udpPort, @"udpPort",
                                       networkParameters.tcpPort, @"tcpPort",
                                       networkParameters.dtlsPort, @"dtlsPort",
                                       networkParameters.tlsPort, @"tlsPort",
                                       nil
                                       ];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - Controlling media parameters Functions

- (void) setAudioCodecs:(CDVInvokedUrlCommand*)command {
    NSString* codecListString = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAudioCodecs:[LinphonePlugin parseCodecList:codecListString]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setVideoCodecs:(CDVInvokedUrlCommand*)command {
    NSString* codecListString = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoCodecs:[LinphonePlugin parseCodecList:codecListString]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setAudioPortRange:(CDVInvokedUrlCommand*)command {
    NSNumber* min = [[command arguments] objectAtIndex:0];
    NSNumber* max = [[command arguments] objectAtIndex:1];
    [[LinphoneHelper instance] setAudioPortRangeWithMinPort:[min intValue] maxPort:[max intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setVideoPortRange:(CDVInvokedUrlCommand*)command {
    NSNumber* min = [[command arguments] objectAtIndex:0];
    NSNumber* max = [[command arguments] objectAtIndex:1];
    [[LinphoneHelper instance] setVideoPortRangeWithMinPort:[min intValue] maxPort:[max intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setTextPortRange:(CDVInvokedUrlCommand*)command {
    NSNumber* min = [[command arguments] objectAtIndex:0];
    NSNumber* max = [[command arguments] objectAtIndex:1];
    [[LinphoneHelper instance] setTextPortRangeWithMinPort:[min intValue] maxPort:[max intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setNortpTimeout:(CDVInvokedUrlCommand*)command {
    NSNumber* nortpTimeout = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setNortpTimeout:[nortpTimeout intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setUseInfoForDtmf:(CDVInvokedUrlCommand*)command {
    NSNumber* useInfo = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setUseInfoForDtmf:[useInfo boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setUseRfc2833ForDtmf:(CDVInvokedUrlCommand*)command {
    NSNumber* useRfc2833 = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setUseRfc2833ForDtmf:[useRfc2833 boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setRingLevel:(CDVInvokedUrlCommand*)command {
    NSNumber* level = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRingLevel:[level intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setMicGainDb:(CDVInvokedUrlCommand*)command {
    NSNumber* gainDb = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setMicGainDb:[gainDb floatValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setPlaybackGainDb:(CDVInvokedUrlCommand*)command {
    NSNumber* gainDb = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setPlaybackGainDb:[gainDb floatValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setPlayLevel:(CDVInvokedUrlCommand*)command {
    NSNumber* level = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setPlayLevel:[level intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setRecLevel:(CDVInvokedUrlCommand*)command {
    NSNumber* level = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRecLevel:[level intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) soundDeviceCanCapture:(CDVInvokedUrlCommand*)command {
    NSString* devid = [[command arguments] objectAtIndex:0];
    BOOL canCapture = [[LinphoneHelper instance] soundDeviceCanCapture:devid];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:canCapture];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) soundDeviceCanPlayback:(CDVInvokedUrlCommand*)command {
    NSString* devid = [[command arguments] objectAtIndex:0];
    BOOL canPlayback = [[LinphoneHelper instance] soundDeviceCanPlayback:devid];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:canPlayback];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setRingerDevice:(CDVInvokedUrlCommand*)command {
    NSString* devid = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRingerDevice:devid];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setPlaybackDevice:(CDVInvokedUrlCommand*)command {
    NSString* devid = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setPlaybackDevice:devid];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setCaptureDevice:(CDVInvokedUrlCommand*)command {
    NSString* devid = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setCaptureDevice:devid];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setRing:(CDVInvokedUrlCommand*)command {
    NSString* path = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRing:path];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setRingback:(CDVInvokedUrlCommand*)command {
    NSString* path = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRingback:path];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableEchoCancellation:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableEchoCancellation:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setVideoPolicy:(CDVInvokedUrlCommand*)command { // TODO
//    NSString* videoPolicy = [[command arguments] objectAtIndex:0];
//    LinphoneVideoPolicy* videoPolicy;
//    videoPolicy.automatically_initiate
//    [[LinphoneHelper instance] setVideoPolicy:[videoPolicy boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableVideoPreview:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableVideoPreview:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableSelfView:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableSelfView:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setVideoDevice:(CDVInvokedUrlCommand*)command {
    NSString* deviceId = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoDevice:deviceId];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setDeviceRotation:(CDVInvokedUrlCommand*)command {
    NSNumber* rotation = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setDeviceRotation:[rotation intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) playDtmf:(CDVInvokedUrlCommand*)command {
    NSString* dtmf = [[command arguments] objectAtIndex:0];
    NSNumber* durationInMS = [[command arguments] objectAtIndex:1];
    
    const char key = *[[dtmf substringToIndex:1] UTF8String];
    [[LinphoneHelper instance] playDtmf:key duration:[durationInMS intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) stopDtmf:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] stopDtmf];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setMtu:(CDVInvokedUrlCommand*)command {
    NSNumber* mtu = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setMtu:[mtu intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) stopRinging:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] stopRinging];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setAvpfMode:(CDVInvokedUrlCommand*)command {
    NSString* mode = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAvpfMode:mode];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setAvpfRRInterval:(CDVInvokedUrlCommand*)command {
    NSNumber* interval = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAvpfRRInterval:[interval intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setDownloadBandwidth:(CDVInvokedUrlCommand*)command {
    NSNumber* bandwidth = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setDownloadBandwidth:[bandwidth intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setUploadBandwidth:(CDVInvokedUrlCommand*)command {
    NSNumber* bandwidth = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setUploadBandwidth:[bandwidth intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableAdaptiveRateControl:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableAdaptiveRateControl:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setAdaptiveRateAlgorithm:(CDVInvokedUrlCommand*)command {
    NSString* algorithm = [[command arguments] objectAtIndex:0];
    CDVPluginResult* pluginResult;
    if ([@"Simple" isEqualToString:algorithm]
            || [@"Stateful" isEqualToString:algorithm]) {
        [[LinphoneHelper instance] setAdaptiveRateAlgorithm:algorithm];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Wrong parameter."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setDownloadPtime:(CDVInvokedUrlCommand*)command {
    NSNumber* ptime = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setDownloadPtime:[ptime intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setUploadPtime:(CDVInvokedUrlCommand*)command {
    NSNumber* ptime = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setUploadPtime:[ptime intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setSipTransportTimeout:(CDVInvokedUrlCommand*)command {
    NSNumber* timeoutInMS = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setSipTransportTimeout:[timeoutInMS intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableDnsSrv:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableDnsSrv:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getAudioCodecs:(CDVInvokedUrlCommand*)command {
    NSArray* codecArray = [[LinphoneHelper instance] getAudioCodecs];
    NSArray* resultArray = [LinphonePlugin getResultCodecArray:codecArray];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getVideoCodecs:(CDVInvokedUrlCommand*)command {
    NSArray* codecArray = [[LinphoneHelper instance] getVideoCodecs];
    NSArray* resultArray = [LinphonePlugin getResultCodecArray:codecArray];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getTextCodecs:(CDVInvokedUrlCommand*)command {
    NSArray* codecArray = [[LinphoneHelper instance] getTextCodecs];
    NSArray* resultArray = [LinphonePlugin getResultCodecArray:codecArray];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setPayloadTypeBitrate:(CDVInvokedUrlCommand*)command {
    NSString* mimeType = [[command arguments] objectAtIndex:0];
    NSNumber* clockRate = [[command arguments] objectAtIndex:1];
    NSNumber* bitrate = [[command arguments] objectAtIndex:2];
    [[LinphoneHelper instance] setPayloadTypeBitrate:mimeType rate:[clockRate intValue] bitrate:[bitrate intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enablePayloadType:(CDVInvokedUrlCommand*)command {
    NSString* mimeType = [[command arguments] objectAtIndex:0];
    NSNumber* clockRate = [[command arguments] objectAtIndex:1];
    NSNumber* enabled = [[command arguments] objectAtIndex:2];
    [[LinphoneHelper instance] enablePayloadType:mimeType rate:[clockRate intValue] enable:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) findPayloadType:(CDVInvokedUrlCommand*)command {
    NSString* mimeType = [[command arguments] objectAtIndex:0];
    NSNumber* clockRate = [[command arguments] objectAtIndex:1];
    NSNumber* channels = [[command arguments] objectAtIndex:2];
    TTPayloadType* payloadType = [[LinphoneHelper instance] findPayloadType:mimeType rate:[clockRate intValue] channels:[channels intValue]];
    NSDictionary* resultDict = [LinphonePlugin getCodecDictionary:payloadType];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setPayloadTypeNumber:(CDVInvokedUrlCommand*)command {
    NSString* mimeType = [[command arguments] objectAtIndex:0];
    NSNumber* clockRate = [[command arguments] objectAtIndex:1];
    NSNumber* number = [[command arguments] objectAtIndex:2];
    [[LinphoneHelper instance] setPayloadTypeNumber:mimeType rate:[clockRate intValue] number:[number intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableAudioAdaptiveJittcomp:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableAudioAdaptiveJittcomp:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setAudioJittcomp:(CDVInvokedUrlCommand*)command {
    NSNumber* millisecond = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAudioJittcomp:[millisecond intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableVideoAdaptiveJittcomp:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableVideoAdaptiveJittcomp:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setVideoJittcomp:(CDVInvokedUrlCommand*)command {
    NSNumber* milliseconds = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoJittcomp:[milliseconds intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) reloadSoundDevices:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] reloadSoundDevices];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setRemoteRingbackTone:(CDVInvokedUrlCommand*)command {
    NSString* ring = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRemoteRingbackTone:ring];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setRingDuringIncomingEarlyMedia:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRingDuringIncomingEarlyMedia:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableEchoLimiter:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableEchoLimiter:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableVideoCapture:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableVideoCapture:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableVideoDisplay:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableVideoDisplay:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableVideoSourceReuse:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableVideoSourceReuse:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setPreferredVideoSize:(CDVInvokedUrlCommand*)command {
    NSNumber *width = [[command arguments] objectAtIndex:0];
    NSNumber *height = [[command arguments] objectAtIndex:1];
    [[LinphoneHelper instance] setPreferredVideoSize:[width intValue] height:[height intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setPreviewVideoSize:(CDVInvokedUrlCommand*)command {
    NSNumber *width = [[command arguments] objectAtIndex:0];
    NSNumber *height = [[command arguments] objectAtIndex:1];
    [[LinphoneHelper instance] setPreviewVideoSize:[width intValue] height:[height intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setPreviewVideoSizeByName:(CDVInvokedUrlCommand*)command {
    NSString* name = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setPreviewVideoSizeByName:name];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setPreferredVideoSizeByName:(CDVInvokedUrlCommand*)command {
    NSString* name = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setPreferredVideoSizeByName:name];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setPreferredFramerate:(CDVInvokedUrlCommand*)command {
    NSNumber* fps = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setPreferredFramerate:[fps floatValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) reloadVideoDevices:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] reloadVideoDevices];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setStaticPicture:(CDVInvokedUrlCommand*)command {
    NSString* path = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setStaticPicture:path];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setStaticPictureFps:(CDVInvokedUrlCommand*)command {
    NSNumber* fps = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setStaticPictureFps:[fps floatValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) usePreviewWindow:(CDVInvokedUrlCommand*)command {
    NSNumber* use = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] usePreviewWindow:[use boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setUseFiles:(CDVInvokedUrlCommand*)command {
    NSNumber* use = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setUseFiles:[use boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setPlayFile:(CDVInvokedUrlCommand*)command {
    NSString* file = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setPlayFile:file];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setRecordFile:(CDVInvokedUrlCommand*)command {
    NSString* file = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setRecordFile:file];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setMediaEncryption:(CDVInvokedUrlCommand*)command {
    NSString* mediaEncryption = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setMediaEncryption:mediaEncryption];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setMediaEncryptionMandatory:(CDVInvokedUrlCommand*)command {
    NSNumber* mandatory = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setMediaEncryptionMandatory:[mandatory boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setAudioMulticastAddress:(CDVInvokedUrlCommand*)command {
    NSString* ip = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAudioMulticastAddress:ip];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setVideoMulticastAddress:(CDVInvokedUrlCommand*)command {
    NSString* ip = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoMulticastAddress:ip];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setAudioMulticastTtl:(CDVInvokedUrlCommand*)command {
    NSNumber* ttl = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setAudioMulticastTtl:[ttl intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setVideoMulticastTtl:(CDVInvokedUrlCommand*)command {
    NSNumber* ttl = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoMulticastTtl:[ttl intValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableAudioMulticast:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableAudioMulticast:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) enableVideoMulticast:(CDVInvokedUrlCommand*)command {
    NSNumber* enabled = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] enableVideoMulticast:[enabled boolValue]];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) setVideoDisplayFilter:(CDVInvokedUrlCommand*)command {
    NSString* filterName = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setVideoDisplayFilter:filterName];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
- (void) getMediaParameters:(CDVInvokedUrlCommand*)command {
    TTMediaParameters* mediaParameters = [[LinphoneHelper instance] getMediaParameters];
    
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       mediaParameters.audioJittcomp, @"audioJittcomp",
                                       mediaParameters.videoJittcomp, @"videoJittcomp",
                                       mediaParameters.nortpTimeout, @"nortpTimeout",
                                       mediaParameters.useInfoForDtmf, @"useInfoForDtmf",
                                       mediaParameters.useRfc2833ForDtmf, @"useRfc2833ForDtmf",
                                       mediaParameters.playLevel, @"playLevel",
                                       mediaParameters.ringLevel, @"ringLevel",
                                       mediaParameters.recLevel, @"recLevel",
                                       mediaParameters.micGainDb, @"micGainDb",
                                       mediaParameters.playbackGainDb, @"playbackGainDb",
                                       [LinphonePlugin applyString:mediaParameters.ringerDevice], @"ringerDevice",
                                       [LinphonePlugin applyString:mediaParameters.playbackDevice], @"playbackDevice",
                                       [LinphonePlugin applyString:mediaParameters.captureDevice], @"captureDevice",
                                       [LinphonePlugin applyString:mediaParameters.soundDevices], @"soundDevices",
                                       [LinphonePlugin applyString:mediaParameters.videoDevices], @"videoDevices",
                                       [LinphonePlugin applyString:mediaParameters.videoDevice], @"videoDevice",
                                       [LinphonePlugin applyString:mediaParameters.ring], @"ring",
                                       [LinphonePlugin applyString:mediaParameters.ringback], @"ringback",
                                       mediaParameters.echoCancellationEnabled, @"echoCancellationEnabled",
                                       mediaParameters.videoPreviewEnabled, @"videoPreviewEnabled",
                                       mediaParameters.deviceRotation, @"deviceRotation",
                                       [LinphonePlugin applyString:mediaParameters.avpfMode.avpfMode], @"avpfMode",
                                       mediaParameters.avpfRRInterval, @"avpfRRInterval",
                                       mediaParameters.downloadBandwidth, @"downloadBandwidth",
                                       mediaParameters.uploadBandwidth, @"uploadBandwidth",
                                       mediaParameters.adaptiveRateControlEnabled, @"adaptiveRateControlEnabled",
                                       [LinphonePlugin applyString:mediaParameters.adaptiveRateAlgorithm], @"adaptiveRateAlgorithm",
                                       mediaParameters.downloadTime, @"downloadTime",
                                       mediaParameters.uploadPtime, @"uploadPtime",
                                       mediaParameters.sipTransportTimeout, @"sipTransportTimeout",
                                       mediaParameters.dnsSrvEnabled, @"dnsSrvEnabled",
                                       mediaParameters.audioAdaptiveJittcompEnabled, @"audioAdaptiveJittcompEnabled",
                                       mediaParameters.videoAdaptiveJittcompEnabled, @"videoAdaptiveJittcompEnabled",
                                       [LinphonePlugin applyString:mediaParameters.remoteRingbackTone], @"remoteRingbackTone",
                                       mediaParameters.echoLimiterEnabled, @"echoLimiterEnabled",
                                       mediaParameters.videoEnabled, @"videoEnabled",
                                       mediaParameters.videoCaptureEnabled, @"videoCaptureEnabled",
                                       mediaParameters.videoDisplayEnabled, @"videoDisplayEnabled",
                                       mediaParameters.preferredFramerate, @"preferredFramerate",
                                       [LinphonePlugin applyString:mediaParameters.staticPicture], @"staticPicture",
                                       mediaParameters.staticPictureFps, @"staticPictureFps",
                                       [LinphonePlugin applyString:mediaParameters.playFile], @"playFile",
                                       [LinphonePlugin applyString:mediaParameters.recordFile], @"recordFile",
                                       [LinphonePlugin applyString:mediaParameters.mediaEncryption.mediaEncryption], @"mediaEncryption",
                                       mediaParameters.isMediaEncryptionMandatory, @"isMediaEncryptionMandatory",
                                       [LinphonePlugin applyString:mediaParameters.supportedFileFormats], @"supportedFileFormats",
                                       [LinphonePlugin applyString:mediaParameters.audioMulticastAddress], @"audioMulticastAddress",
                                       [LinphonePlugin applyString:mediaParameters.videoMulticastAddress], @"videoMulticastAddress",
                                       mediaParameters.audioMulticastTtl, @"audioMulticastTtl",
                                       mediaParameters.videoMulticastTtl, @"videoMulticastTtl",
                                       mediaParameters.audioMulticastEnabled, @"audioMulticastEnabled",
                                       mediaParameters.videoMulticastEnabled, @"videoMulticastEnabled",
                                       [LinphonePlugin applyString:mediaParameters.videoDisplayFilter], @"videoDisplayFilter",
                                       mediaParameters.selfViewEnabled, @"selfViewEnabled",
                                       mediaParameters.micEnabled, @"micEnabled",
                                       mediaParameters.preferredVideoSize.width, @"preferredVideoSize.width",
                                       mediaParameters.preferredVideoSize.height, @"preferredVideoSize.height",
                                       mediaParameters.currentPreviewVideoSize.width, @"currentPreviewVideoSize.width",
                                       mediaParameters.currentPreviewVideoSize.height, @"currentPreviewVideoSize.height",
                                       mediaParameters.previewVideoSize.width, @"previewVideoSize.width",
                                       mediaParameters.previewVideoSize.height, @"previewVideoSize.height",
                                       mediaParameters.automaticallyAccept, @"automaticallyAccept",
                                       mediaParameters.automaticallyInitiate, @"automaticallyInitiate",
                                       mediaParameters.mtu, @"mtu",
                                       mediaParameters.ringDuringIncomingEarlyMedia, @"ringDuringIncomingEarlyMedia",
                                       mediaParameters.useFiles, @"useFiles",
                                       nil
                                       ];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Managing call logs Functions

- (void) getCallLogs:(CDVInvokedUrlCommand*)command { // TODO
    NSString* callStatus = [[command arguments] objectAtIndex:0];
    NSString* callDirection = [[command arguments] objectAtIndex:1];
    NSDictionary* callLogs = [[LinphoneHelper instance] getCallLogs:callStatus callDirection:callDirection];
    NSMutableDictionary* resultDict = [[NSMutableDictionary alloc] init];
    for (int index = 0; index < [callLogs allKeys].count; index++) {
        NSDate* key = [[callLogs allKeys] objectAtIndex:index];
        NSArray* value = [callLogs objectForKey:key];
        NSMutableArray* resultArray = [[NSMutableArray alloc] init];
        for (int logIndex = 0; logIndex < value.count; logIndex++) {
            TTCallLog* callLog = [value objectAtIndex:logIndex];
            NSDictionary* callLogDict = [LinphonePlugin getCallLogDictionary:callLog];
            [resultArray addObject:callLogDict];
        }
        
        [resultDict setObject:resultArray forKey:[LinphonePlugin dateToString:key]];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearCallLogs:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] clearCallLogs];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getCallPeerHistoryForCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    NSArray* callLogs = [[LinphoneHelper instance] getCallPeerHistoryForCallId:callId];
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < callLogs.count; index++) {
        TTCallLog* value = [callLogs objectAtIndex:index];
        NSDictionary* callLogDict = [LinphonePlugin getCallLogDictionary:value];
        [resultArray addObject:callLogDict];
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) findCallLogFromCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    TTCallLog* callLog = [[LinphoneHelper instance] findCallLogFromCallId:callId];
    NSDictionary* resultDict = [LinphonePlugin getCallLogDictionary:callLog];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) removeCallLogFromCallId:(CDVInvokedUrlCommand*)command {
    NSString* callId = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] removeCallLogWithCallId:callId];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getLastOutgoingCallLog:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    TTCallLog* callLog = [[LinphoneHelper instance] getLastOutgoingCallLog];
    if (callLog) {
        NSDictionary* resultDict = [LinphonePlugin getCallLogDictionary:callLog];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"No last outgoing call log found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getMissedCallsCount:(CDVInvokedUrlCommand*)command {
    int count = [[LinphoneHelper instance] getMissedCallsCount];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:count];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) resetMissedCallsCount:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] resetMissedCallsCount];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - Making an audio conference Functions

- (void) getAudioConferenceInformation:(CDVInvokedUrlCommand*)command {
    TTConference* conference = [[LinphoneHelper instance] getTTConference];
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       conference.localInputVolume, @"localInputVolume",
                                       conference.size, @"size",
                                       conference.isConference, @"isConference",
                                       nil
                                       ];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getAllCalls:(CDVInvokedUrlCommand*)command {
    NSArray* allCalls = [[LinphoneHelper instance] getAllCalls];

    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < allCalls.count; index++) {
        TTLinphoneCall* call = [allCalls objectAtIndex:index];
        [resultArray addObject:[LinphonePlugin getCallDictionary:call]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addToConference:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* callId = [[command arguments] objectAtIndex:0];
    LinphoneCall* call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        [[LinphoneHelper instance] addToConference:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) removeFromConference:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* callId = [[command arguments] objectAtIndex:0];
    LinphoneCall* call = [[LinphoneHelper instance] getLinphoneCallFromCallId:callId];
    if (call) {
        [[LinphoneHelper instance] removeFromConference:call];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Call ID not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) leaveConference:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] leaveConference];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enterConference:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] enterConference];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addAllToConference:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] addAllToConference];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) startConferenceRecording:(CDVInvokedUrlCommand*)command {
    NSString* path = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] startConferenceRecording:path];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) stopConferenceRecording:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] stopConferenceRecording];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - Chat room and Messaging Functions

- (void) getAllChatRooms:(CDVInvokedUrlCommand*)command {
    NSArray* allChatRooms = [[LinphoneHelper instance] getAllChatRooms];
    
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < allChatRooms.count; index++) {
        TTLinphoneChatRoom* chatRoom = [allChatRooms objectAtIndex:index];
        [resultArray addObject:[LinphonePlugin getChatRoomDictionary:chatRoom]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setChatDatabasePath:(CDVInvokedUrlCommand*)command {
    NSString* path = [[command arguments] objectAtIndex:0];
    [[LinphoneHelper instance] setChatDatabasePath:path];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getChatRoomWithUsername:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    LinphoneChatRoom* linphoneChatRoom = [[LinphoneHelper instance] getChatRoomWithUsername:username domain:domain];
    
    TTLinphoneChatRoom* ttlinphoneChatRoom = [[TTLinphoneChatRoom alloc] init];
    [ttlinphoneChatRoom parseLinphoneChatRoom:linphoneChatRoom];
    NSDictionary* resultDict = [LinphonePlugin getChatRoomDictionary:ttlinphoneChatRoom];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getChatRoomFromUri:(CDVInvokedUrlCommand*)command {
    NSString* toUri = [[command arguments] objectAtIndex:0];
    LinphoneChatRoom* linphoneChatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    TTLinphoneChatRoom* ttlinphoneChatRoom = [[TTLinphoneChatRoom alloc] init];
    [ttlinphoneChatRoom parseLinphoneChatRoom:linphoneChatRoom];
    NSDictionary* resultDict = [LinphonePlugin getChatRoomDictionary:ttlinphoneChatRoom];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) deleteChatRoom:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        [[LinphoneHelper instance] deleteChatRoom:chatRoom];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) disableChat:(CDVInvokedUrlCommand*)command {
    NSString* reason = [[command arguments] objectAtIndex:0];
    LinphoneReason linphoneReason = [TTLinphoneReason getLinphoneReasonWithString:reason];
    [[LinphoneHelper instance] disableChat:linphoneReason];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableChat:(CDVInvokedUrlCommand*)command {
    [[LinphoneHelper instance] enableChat];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) uploadFileMessage:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* url = [[command arguments] objectAtIndex:0];
    NSString* toUri = [[command arguments] objectAtIndex:1];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        NSURL *objectUrl=[NSURL URLWithString:url];
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:objectUrl]];
        
        [[LinphoneHelper instance] upload:img withURL:objectUrl forChatRoom:chatRoom];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) startFileDownload:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSNumber* messageStoreId = [[command arguments] objectAtIndex:1];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        LinphoneChatMessage *chatMessage = [[LinphoneHelper instance] findChatMessageWithChatRoom:chatRoom messageStoreId:[messageStoreId unsignedIntValue]];
        if (chatMessage) {
            [[LinphoneHelper instance] startFileDownload:chatMessage];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Message store ID not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) cancelFileDownload:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSNumber* messageStoreId = [[command arguments] objectAtIndex:1];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        LinphoneChatMessage *chatMessage = [[LinphoneHelper instance] findChatMessageWithChatRoom:chatRoom messageStoreId:[messageStoreId unsignedIntValue]];
        if (chatMessage) {
            [[LinphoneHelper instance] cancelFileDownload:chatMessage];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Message store ID not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) cancelFileUpload:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        [[LinphoneHelper instance] cancelFileUpload];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendMessageWithChatRoom:(CDVInvokedUrlCommand*)command {

    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSString* message = [[command arguments] objectAtIndex:1];
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        [[LinphoneHelper instance] sendMessageWithChatRoom:chatRoom message:message withExterlBodyUrl:nil withInternalURL:nil];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) markAsRead:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        [[LinphoneHelper instance] markAsRead:chatRoom];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) deleteMessage:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSNumber* messageStoreId = [[command arguments] objectAtIndex:1];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        LinphoneChatMessage *chatMessage = [[LinphoneHelper instance] findChatMessageWithChatRoom:chatRoom messageStoreId:[messageStoreId unsignedIntValue]];
        if (chatMessage) {
            [[LinphoneHelper instance] deleteMessage:chatRoom chatMessage:chatMessage];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Message store ID not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) deleteHistory:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        [[LinphoneHelper instance] deleteHistory:chatRoom];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) getHistory:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSNumber* numberOfMessages = [[command arguments] objectAtIndex:1];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        NSArray* resultArray = [[LinphoneHelper instance] getHistory:chatRoom numberOfMessages:[numberOfMessages intValue]];
        
        NSMutableArray* result = [[NSMutableArray alloc] init];
        for (int index = 0; index < resultArray.count; index++) {
            TTLinphoneChatMessage* chatRoom = [resultArray objectAtIndex:index];
            [result addObject:[LinphonePlugin getChatMessageDictionary:chatRoom]];
        }
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:result];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) getHistoryRange:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSNumber* begin = [[command arguments] objectAtIndex:1];
    NSNumber* end = [[command arguments] objectAtIndex:2];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        NSArray* resultArray = [[LinphoneHelper instance] getHistoryRange:chatRoom begin:[begin intValue] end:[end intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) compose:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        [[LinphoneHelper instance] compose:chatRoom];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) addCustomHeader:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSNumber* messageStoreId = [[command arguments] objectAtIndex:1];
    NSString* headerName = [[command arguments] objectAtIndex:2];
    NSString* headerValue = [[command arguments] objectAtIndex:3];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        LinphoneChatMessage *chatMessage = [[LinphoneHelper instance] findChatMessageWithChatRoom:chatRoom messageStoreId:[messageStoreId unsignedIntValue]];
        if (chatMessage) {
            [[LinphoneHelper instance] addCustomHeader:chatMessage headerName:headerName headerValue:headerValue];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Message store ID not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) getCustomHeader:(CDVInvokedUrlCommand*)command {
    CDVPluginResult* pluginResult;
    NSString* toUri = [[command arguments] objectAtIndex:0];
    NSNumber* messageStoreId = [[command arguments] objectAtIndex:1];
    NSString* headerName = [[command arguments] objectAtIndex:2];
    
    LinphoneChatRoom *chatRoom = [[LinphoneHelper instance] getChatRoomFromUri:toUri];
    if (chatRoom) {
        LinphoneChatMessage *chatMessage = [[LinphoneHelper instance] findChatMessageWithChatRoom:chatRoom messageStoreId:[messageStoreId unsignedIntValue]];
        if (chatMessage) {
            const char* headerValue = [[LinphoneHelper instance] getCustomHeader:chatMessage headerName:headerName];
            if (headerValue) {
                NSString* value = [NSString stringWithUTF8String:headerValue];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Header not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Message store ID not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Chat room not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


#pragma mark - Managing Buddies and buddy list and presence Functions

-(void) getMyBuddy:(CDVInvokedUrlCommand*)command {
    TTLinphonePresenceModel *ttlinphonePresenceModel = [[TTLinphonePresenceModel alloc] init];
    [ttlinphonePresenceModel parseLinphonePresenceModel:[[LinphoneHelper instance] getMyOnlineStatus]];
    NSDictionary *resultDict = [LinphonePlugin getPresenceModelDictionary:ttlinphonePresenceModel];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


-(void) findFriendByUsername:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        TTLinphoneFriend* ttlinphoneFriend = [[TTLinphoneFriend alloc] init];
        [ttlinphoneFriend parseLinphoneFriend:friend];
        NSDictionary* resultDict = [LinphonePlugin getLinphoneFriendDictionary:ttlinphoneFriend];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) getFriendList:(CDVInvokedUrlCommand*)command {
    
    NSArray* allFriends = [[LinphoneHelper instance] getFriendList];
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < allFriends.count; index++) {
        TTLinphoneFriend* friend = [allFriends objectAtIndex:index];
        [resultArray addObject:[LinphonePlugin getLinphoneFriendDictionary:friend]];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultArray];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) notifyAllFriendList:(CDVInvokedUrlCommand*)command {
    NSString* activityType = [[command arguments] objectAtIndex:0];
    NSString* description = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult;
    LinphonePresenceActivityType linphonePresenceActivityType = [TTLinphonePresenceActivityType getLinphonePresenceActivityTypeWithString:activityType];
    LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] createNewLinphonePresenceModelWithActivity:linphonePresenceActivityType description:description];
    if (presenceModel) {
        [[LinphoneHelper instance] notifyAllFriendList:presenceModel];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addFriend:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (!friend) {
        friend = [[LinphoneHelper instance] createOrEditLinphoneFriendWithAddress:username domain:domain];
        [[LinphoneHelper instance] addFriend:friend];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend already added."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) removeFriend:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        [[LinphoneHelper instance] removeFriend:friend];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) acceptSubscriber:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        [[LinphoneHelper instance] acceptSubscriber:friend];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) rejectSubscriber:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult* pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        [[LinphoneHelper instance] rejectSubscriber:friend];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void) findPresenceModelByUsername:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            TTLinphonePresenceModel* ttlinphonePresenceModel = [[TTLinphonePresenceModel alloc] init];
            [ttlinphonePresenceModel parseLinphonePresenceModel:presenceModel];
            NSDictionary* resultDict = [LinphonePlugin getPresenceModelDictionary:ttlinphonePresenceModel];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setBasicStatus:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* basicStatus = [[command arguments] objectAtIndex:2];
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceBasicStatus linphonePresenceBasicStatus = [TTLinphonePresenceBasicStatus getLinphonePresenceBasicStatusWithString:basicStatus];
            [[LinphoneHelper instance] setBasicStatus:presenceModel basicStatus:linphonePresenceBasicStatus];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setContact:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* contact = [[command arguments] objectAtIndex:2];
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            [[LinphoneHelper instance] setContact:presenceModel contact:contact];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) setActivity:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* activityType = [[command arguments] objectAtIndex:2];
    NSString* description = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceActivityType linphonePresenceActivityType = [TTLinphonePresenceActivityType getLinphonePresenceActivityTypeWithString:activityType];
            [[LinphoneHelper instance] setActivity:presenceModel activity:linphonePresenceActivityType description:description];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNthActivity:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* index = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceActivity* linphonePresenceActivity = [[LinphoneHelper instance] getNthActivity:presenceModel index:[index unsignedIntValue]];

            if (linphonePresenceActivity) {
                TTLinphonePresenceActivity* ttlinphonePresenceActivity = [[TTLinphonePresenceActivity alloc] init];
                [ttlinphonePresenceActivity parseLinphonePresenceActivity:linphonePresenceActivity];
                NSDictionary* resultDict = [LinphonePlugin getPresenceActivityDictionary:ttlinphonePresenceActivity];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence activity not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
        
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addActivity:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* presenceActivityType = [[command arguments] objectAtIndex:2];
    NSString* description = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceActivityType linphonePresenceActivityType = [TTLinphonePresenceActivityType getLinphonePresenceActivityTypeWithString:presenceActivityType];
            LinphonePresenceActivity* linphonePresenceActivity = [[LinphoneHelper instance] createNewWithActivity:linphonePresenceActivityType description:description];
            [[LinphoneHelper instance] addActivity:presenceModel activity:linphonePresenceActivity];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearActivities:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            [[LinphoneHelper instance] clearActivities:presenceModel];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNote:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* lang = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceNote* linphonePresenceNote = [[LinphoneHelper instance] getNote:presenceModel lang:lang];
            if (linphonePresenceNote) {
                TTLinphonePresenceNote* ttlinphonePresenceNote = [[TTLinphonePresenceNote alloc] init];
                [ttlinphonePresenceNote parseLinphonePresenceNote:linphonePresenceNote];
                NSDictionary* resultDict = [LinphonePlugin getPresenceNoteDictionary:ttlinphonePresenceNote];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Note not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addNoteContent:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* noteContent = [[command arguments] objectAtIndex:2];
    NSString* lang = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            [[LinphoneHelper instance] addNote:presenceModel noteContent:noteContent lang:lang];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearNotes:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            [[LinphoneHelper instance] clearNotes:presenceModel];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNthService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* index = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceService* linphonePresenceService = [[LinphoneHelper instance] getNthService:presenceModel index:[index unsignedIntValue]];
            if (linphonePresenceService) {
                TTLinphonePresenceService* ttlinphonePresenceService = [[TTLinphonePresenceService alloc] init];
                [ttlinphonePresenceService parseLinphonePresenceService:linphonePresenceService];
                NSDictionary* resultDict = [LinphonePlugin getPresenceServiceDictionary:ttlinphonePresenceService];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence service not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSString* basicStatus = [[command arguments] objectAtIndex:2];
    NSString* contact = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceBasicStatus linphonePresenceBasicStatus = [TTLinphonePresenceBasicStatus getLinphonePresenceBasicStatusWithString:basicStatus];
            
            LinphonePresenceService* presenceService = [[LinphoneHelper instance] createNewService:linphonePresenceBasicStatus contact:contact];
            [[LinphoneHelper instance] addService:presenceModel service:presenceService];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearServices:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            [[LinphoneHelper instance] clearServices:presenceModel];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNthPerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* index = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[index unsignedIntValue]];
            if (linphonePresencePerson) {
                TTLinphonePresencePerson* ttlinphonePresencePerson = [[TTLinphonePresencePerson alloc] init];
                [ttlinphonePresencePerson parseLinphonePresencePerson:linphonePresencePerson];
                NSDictionary* resultDict = [LinphonePlugin getPresencePersonDictionary:ttlinphonePresencePerson];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addPerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson *linphonePresencePerson = [[LinphoneHelper instance] createNewPerson];
            [[LinphoneHelper instance] addPerson:presenceModel person:linphonePresencePerson];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearPerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            [[LinphoneHelper instance] clearPerson:presenceModel];
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setIdForLinphonePresenceService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* serviceIndex = [[command arguments] objectAtIndex:2];
    NSString* ID = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceService* linphonePresenceService = [[LinphoneHelper instance] getNthService:presenceModel index:[serviceIndex unsignedIntValue]];
            if (linphonePresenceService) {
                [[LinphoneHelper instance] setIdForLinphonePresenceService:linphonePresenceService id:ID];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence service not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setBasicStatusForLinphonePresenceService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* serviceIndex = [[command arguments] objectAtIndex:2];
    NSString* basicStatus = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceService* linphonePresenceService = [[LinphoneHelper instance] getNthService:presenceModel index:[serviceIndex unsignedIntValue]];
            if (linphonePresenceService) {
                LinphonePresenceBasicStatus linphonePresenceBasicStatus = [TTLinphonePresenceBasicStatus getLinphonePresenceBasicStatusWithString:basicStatus];
                [[LinphoneHelper instance] setBasicStatusForLinphonePresenceService:linphonePresenceService basicStatus:linphonePresenceBasicStatus];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence service not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setContactForLinphonePresenceService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* serviceIndex = [[command arguments] objectAtIndex:2];
    NSString* contact = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceService* linphonePresenceService = [[LinphoneHelper instance] getNthService:presenceModel index:[serviceIndex unsignedIntValue]];
            if (linphonePresenceService) {
                [[LinphoneHelper instance] setContactForLinphonePresenceService:linphonePresenceService contact:contact];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence service not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNthNoteFromService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* serviceIndex = [[command arguments] objectAtIndex:2];
    NSNumber* noteIndex = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceService* linphonePresenceService = [[LinphoneHelper instance] getNthService:presenceModel index:[serviceIndex unsignedIntValue]];
            if (linphonePresenceService) {
                LinphonePresenceNote* linphonePresenceNote = [[LinphoneHelper instance] getNthNoteFromService:linphonePresenceService index:[noteIndex unsignedIntValue]];
                if (linphonePresenceNote) {
                    TTLinphonePresenceNote *ttlinphonePresenceNote = [[TTLinphonePresenceNote alloc] init];
                    [ttlinphonePresenceNote parseLinphonePresenceNote:linphonePresenceNote];
                    
                    NSDictionary* resultDict = [LinphonePlugin getPresenceNoteDictionary:ttlinphonePresenceNote];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence note not found."];
                }
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence service not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addNoteForLinphonePresenceService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* serviceIndex = [[command arguments] objectAtIndex:2];
    NSString* content = [[command arguments] objectAtIndex:3];
    NSString* lang = [[command arguments] objectAtIndex:4];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceService* linphonePresenceService = [[LinphoneHelper instance] getNthService:presenceModel index:[serviceIndex unsignedIntValue]];
            if (linphonePresenceService) {
                LinphonePresenceNote* linphonePresenceNote = [[LinphoneHelper instance] createNewNote:content lang:lang];
                [[LinphoneHelper instance] addNoteForLinphonePresenceService:linphonePresenceService note:linphonePresenceNote];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence service not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearNotesForLinphonePresenceService:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* serviceIndex = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresenceService* linphonePresenceService = [[LinphoneHelper instance] getNthService:presenceModel index:[serviceIndex unsignedIntValue]];
            if (linphonePresenceService) {
                [[LinphoneHelper instance] clearNotesForLinphonePresenceService:linphonePresenceService];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence service not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) setIdForLinphonePresencePerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    NSString* ID = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                [[LinphoneHelper instance] setIdForLinphonePresencePerson:linphonePresencePerson id:ID];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNthActivityForLinphonePresencePerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    NSNumber* activityIndex = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                LinphonePresenceActivity* linphonePresenceActivity = [[LinphoneHelper instance] getNthActivityForLinphonePresencePerson:linphonePresencePerson index:[activityIndex unsignedIntValue]];
                if (linphonePresenceActivity) {
                    TTLinphonePresenceActivity* ttlinphonePresenceActivity = [[TTLinphonePresenceActivity alloc] init];
                    [ttlinphonePresenceActivity parseLinphonePresenceActivity:linphonePresenceActivity];
                    
                    NSDictionary* resultDict = [LinphonePlugin getPresenceActivityDictionary:ttlinphonePresenceActivity];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence activity not found."];
                }
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addActivityForLinphonePresencePerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    NSString* presenceActivityType = [[command arguments] objectAtIndex:3];
    NSString* description = [[command arguments] objectAtIndex:4];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                LinphonePresenceActivityType linphonePresenceActivityType = [TTLinphonePresenceActivityType getLinphonePresenceActivityTypeWithString:presenceActivityType];
                
                LinphonePresenceActivity* linphonePresenceActivity = [[LinphoneHelper instance] createNewWithActivity:linphonePresenceActivityType description:description];
                [[LinphoneHelper instance] addActivityForLinphonePresencePerson:linphonePresencePerson activity:linphonePresenceActivity];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearActivitiesForLinphonePresencePerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                [[LinphoneHelper instance] clearActivitiesForLinphonePresencePerson:linphonePresencePerson];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNthNoteFromPerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    NSNumber* noteIndex = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                LinphonePresenceNote* linphonePresenceNote = [[LinphoneHelper instance] getNthNoteFromPerson:linphonePresencePerson index:[noteIndex unsignedIntValue]];
                if (linphonePresenceNote) {
                    TTLinphonePresenceNote* ttlinphonePresenceNote = [[TTLinphonePresenceNote alloc] init];
                    [ttlinphonePresenceNote parseLinphonePresenceNote:linphonePresenceNote];
                    NSDictionary* resultDict = [LinphonePlugin getPresenceNoteDictionary:ttlinphonePresenceNote];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence note not found."];
                }
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addNoteForLinphonePresencePerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    NSString* content = [[command arguments] objectAtIndex:3];
    NSString* lang = [[command arguments] objectAtIndex:4];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                LinphonePresenceNote* linphonePresenceNote = [[LinphoneHelper instance] createNewNote:content lang:lang];
                [[LinphoneHelper instance] addNoteForLinphonePresencePerson:linphonePresencePerson note:linphonePresenceNote];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearNotesForLinphonePresencePerson:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                [[LinphoneHelper instance] clearNotesForLinphonePresencePerson:linphonePresencePerson];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) getNthActivitiesNote:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    NSNumber* noteIndex = [[command arguments] objectAtIndex:3];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                LinphonePresenceNote* linphonePresenceNote = [[LinphoneHelper instance] getNthActivitiesNote:linphonePresencePerson index:[noteIndex unsignedIntValue]];
                if (linphonePresenceNote) {
                    TTLinphonePresenceNote* ttlinphonePresenceNote = [[TTLinphonePresenceNote alloc] init];
                    [ttlinphonePresenceNote parseLinphonePresenceNote:linphonePresenceNote];
                    NSDictionary* resultDict = [LinphonePlugin getPresenceNoteDictionary:ttlinphonePresenceNote];
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:resultDict];
                } else {
                    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence note not found."];
                }
                
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) addActivitiesNote:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    NSString* content = [[command arguments] objectAtIndex:3];
    NSString* lang = [[command arguments] objectAtIndex:4];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                LinphonePresenceNote* linphonePresenceNote = [[LinphoneHelper instance] createNewNote:content lang:lang];
                [[LinphoneHelper instance] addActivitiesNote:linphonePresencePerson note:linphonePresenceNote];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) clearActivitiesNotes:(CDVInvokedUrlCommand*)command {
    NSString* username = [[command arguments] objectAtIndex:0];
    NSString* domain = [[command arguments] objectAtIndex:1];
    NSNumber* personIndex = [[command arguments] objectAtIndex:2];
    
    CDVPluginResult *pluginResult;
    LinphoneFriend* friend = [[LinphoneHelper instance] findFriendByUsername:username domain:domain];
    if (friend) {
        const LinphonePresenceModel* presenceModel = [[LinphoneHelper instance] findPresenceModel:friend];
        if (presenceModel) {
            LinphonePresencePerson* linphonePresencePerson = [[LinphoneHelper instance] getNthPerson:presenceModel index:[personIndex unsignedIntValue]];
            if (linphonePresencePerson) {
                [[LinphoneHelper instance] clearActivitiesNotes:linphonePresencePerson];
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence person not found."];
            }
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Presence model not found."];
        }
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Friend not found."];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Generic Functions

+(NSArray*) getResultCodecArray:(NSArray*)codecArray {
    NSMutableArray* resultArray = [[NSMutableArray alloc] init];
    for (int index = 0; index < codecArray.count; index++) {
        TTPayloadType* payloadType = [codecArray objectAtIndex:index];
        NSDictionary *resultDict = [LinphonePlugin getCodecDictionary:payloadType];
        [resultArray addObject:resultDict];
    }
    return resultArray;
}

+(NSDictionary*) getCodecDictionary:(TTPayloadType*)payloadType {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       [self applyString:payloadType.mimeType], @"mimeType",
                                       payloadType.clockRate, @"clockRate",
                                       payloadType.channels, @"channels",
                                       payloadType.payloadTypeEnabled, @"payloadTypeEnabled",
                                       payloadType.isVbr, @"isVbr",
                                       payloadType.bitrate, @"bitrate",
                                       payloadType.number, @"number",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getCallLogDictionary:(TTCallLog*)callLog {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       [self applyString:callLog.fromAddress.username], @"fromAddress$username",
                                       [self applyString:callLog.fromAddress.domain], @"fromAddress$domain",
                                       [self applyString:callLog.toAddress.username], @"toAddress$username",
                                       [self applyString:callLog.toAddress.domain], @"toAddress$domain",
                                       callLog.duration, @"duration",
                                       callLog.callDir.callDir, @"callDir",
                                       callLog.callId, @"callId",
                                       callLog.quality, @"quality",
                                       callLog.remoteAddress.username, @"remoteAddress$username",
                                       callLog.remoteAddress.domain, @"remoteAddress$domain",
                                       [LinphonePlugin dateToString:callLog.startDate], @"startDate",
//                                       [self applyString:callLog.callLogStr], @"callLogStr",
                                       callLog.videoEnabled, @"videoEnabled",
                                       callLog.wasConference, @"wasConference",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getCallDictionary:(TTLinphoneCall*)call {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       call.playVolume, @"playVolume",
                                       call.recordVolume, @"recordVolume",
                                       call.speakerVolumeGain, @"speakerVolumeGain",
                                       call.microphoneVolumeGain, @"microphoneVolumeGain",
                                       call.currentQuality, @"currentQuality",
                                       call.averageQuality, @"averageQuality",
                                       call.mediaInProgress, @"mediaInProgress",
                                       call.callParams.audioMulticastEnabled, @"audioMulticastEnabled",
                                       call.callParams.videoMulticastEnabled, @"videoMulticastEnabled",
                                       call.callParams.realtimeTextEnabled, @"realtimeTextEnabled",
                                       [self applyString:call.callLog.callId], @"callId",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getChatRoomDictionary:(TTLinphoneChatRoom*)chatRoom {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       chatRoom.isRemoteComposing, @"isRemoteComposing",
                                       chatRoom.unreadMessagesCount, @"unreadMessagesCount",
                                       [self applyString:chatRoom.peerAddress.username], @"peerUsername",
                                       [self applyString:chatRoom.peerAddress.domain], @"peerDomain",
//                                       chatRoom.chatRoomString, @"chatRoomString",
                                       [self applyString:chatRoom.call.callLog.callId], @"callId",
//                                       [LinphonePlugin getCallDictionary:chatRoom.call], @"call",
                                       chatRoom.historySize, @"historySize",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getChatMessageDictionary:(TTLinphoneChatMessage*)chatMessage {
    NSMutableDictionary* resultDict1 = [[NSMutableDictionary alloc] init];
    
    [resultDict1 setObject:chatMessage.isRead forKey:@"isRead"];
    [resultDict1 setObject:chatMessage.isOutgoing forKey:@"isOutgoing"];
    [resultDict1 setObject:chatMessage.storageId forKey:@"storageId"];
    [resultDict1 setObject:chatMessage.storage forKey:@"storage"];
    [resultDict1 setObject:[self applyString:chatMessage.reason.reason] forKey:@"reason"];
    [resultDict1 setObject:[self applyString:chatMessage.fileTransferFilepath] forKey:@"fileTransferFilepath"];
    [resultDict1 setObject:[self applyString:chatMessage.localAddress.username] forKey:@"localAddress$username"];
    [resultDict1 setObject:[self applyString:chatMessage.localAddress.domain] forKey:@"localAddress$domain"];
    [resultDict1 setObject:chatMessage.peerAddress.username forKey:@"peerAddress$username"];
    [resultDict1 setObject:chatMessage.peerAddress.domain forKey:@"peerAddress$domain"];
    [resultDict1 setObject:[self applyString:chatMessage.text] forKey:@"text"];
    [resultDict1 setObject:[self applyString:chatMessage.appdata] forKey:@"appdata"];
    [resultDict1 setObject:chatMessage.time forKey:@"time"];
    [resultDict1 setObject:chatMessage.chatMessageState.chatMessageState forKey:@"chatMessageState"];
    [resultDict1 setObject:[self applyString:chatMessage.fromAddress.username] forKey:@"fromAddress$username"];
    [resultDict1 setObject:[self applyString:chatMessage.fromAddress.domain] forKey:@"fromAddress$domain"];
    [resultDict1 setObject:[self applyString:chatMessage.toAddress.username] forKey:@"toAddress.username"];
    [resultDict1 setObject:[self applyString:chatMessage.toAddress.domain] forKey:@"toAddress.domain"];
    [resultDict1 setObject:[self applyString:chatMessage.externalBodyUrl] forKey:@"externalBodyUrl"];
//    [resultDict1 setObject:[self applyString:chatMessage.errorInfo] forKey:@"errorInfo"];
//    [resultDict1 setObject:[self applyString:chatMessage.chatMessageCbs] forKey:@"chatMessageCbs"];
    return resultDict1;
}

+(NSDictionary*) getTTLinphoneCallStatsDictionary:(TTLinphoneCallStats*)callStats {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       callStats.senderLossRate, @"senderLossRate",
                                       callStats.receiverLossRate, @"receiverLossRate",
                                       callStats.downloadBandwidth, @"downloadBandwidth",
                                       callStats.uploadBandwidth, @"uploadBandwidth",
                                       callStats.senderInterarrivalJitter, @"senderInterarrivalJitter",
                                       callStats.receiverInterarrivalJitter, @"receiverInterarrivalJitter",
                                       callStats.latePacketsCumulativeNumber, @"latePacketsCumulativeNumber",
                                       [LinphonePlugin applyString:callStats.iceState.iceState], @"iceState",
                                       [LinphonePlugin applyString:callStats.upnpState.upnpState], @"upnpState",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getLinphoneFriendDictionary:(TTLinphoneFriend*)friend {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       [LinphonePlugin applyString:friend.name], @"name",
                                       friend.subscribesEnable, @"subscribesEnable",
                                       friend.isInList, @"isInList",
                                       [LinphonePlugin applyString:friend.address.username], @"username",
                                       [LinphonePlugin applyString:friend.address.domain], @"domain",
                                       [LinphonePlugin applyString:friend.subscribePolicy.subscribePolicy], @"subscribePolicy",
//                                       [LinphonePlugin applyString:friend.onlineStatus.onlineStatus], @"onlineStatus",
//                                       friend.presenceModel.presenceModel, @"presenceModel",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getPresenceActivityDictionary:(TTLinphonePresenceActivity*)activity {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       [LinphonePlugin applyString:activity.presenceActivityType.presenceActivityType], @"presenceActivityType",
                                       [LinphonePlugin applyString:activity.activityDescription], @"description",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getPresenceServiceDictionary:(TTLinphonePresenceService*)service {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       service.basicStatus.basicStatus, @"basicStatus",
                                       [LinphonePlugin applyString:service.contact], @"contact",
                                       service.numberOfNotes, @"numberOfNotes",
                                       [LinphonePlugin applyString:service.serviceId], @"serviceId",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getPresenceNoteDictionary:(TTLinphonePresenceNote*)note {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       [LinphonePlugin applyString:note.lang], @"lang",
                                       [LinphonePlugin applyString:note.content], @"content",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getPresenceModelDictionary:(TTLinphonePresenceModel*)model {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       model.timestamp, @"timestamp",
                                       [LinphonePlugin applyString:model.contact], @"contact",
                                       [LinphonePlugin applyString:model.activity.presenceActivityType.presenceActivityType], @"presenceActivityType",
                                       [LinphonePlugin applyString:model.activity.activityDescription], @"activityDescription",
                                       [LinphonePlugin applyString:model.basicStatus.basicStatus], @"basicStatus",
                                       model.numberOfServices, @"numberOfServices",
                                       model.numberOfPersons, @"numberOfPersons",
                                       nil
                                       ];
    return resultDict;
}

+(NSDictionary*) getPresencePersonDictionary:(TTLinphonePresencePerson*)person {
    NSMutableDictionary *resultDict = [ [NSMutableDictionary alloc]
                                       initWithObjectsAndKeys :
                                       person.personId, @"personId",
                                       person.numberOfActivities, @"numberOfActivities",
                                       person.numberOfNotes, @"numberOfNotes",
                                       person.numberOfActivitiesNotes, @"numberOfActivitiesNotes",
                                       nil
                                       ];
    return resultDict;
}

+ (NSString*) applyString:(NSString*)string {
    return string ? string : @"";
}

+(MSList*) parseCodecList:(NSString*) codecListString {
    
}

+ (NSString*)dateToString:(NSDate*)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    return stringFromDate;
}

@end