#import <Cordova/CDV.h>

@interface LinphonePlugin : CDVPlugin

- (void) initLinphoneCore:(CDVInvokedUrlCommand*)command;
- (void) destroyLinphoneCore:(CDVInvokedUrlCommand*)command;
- (void) registerSIP:(CDVInvokedUrlCommand*)command;
- (void) deregisterSIP:(CDVInvokedUrlCommand*)command;
- (void) getRegisterStatusSIP:(CDVInvokedUrlCommand*)command;
- (void) makeCall:(CDVInvokedUrlCommand*)command;
- (void) acceptCall:(CDVInvokedUrlCommand*)command;
- (void) declineCall:(CDVInvokedUrlCommand*)command;
- (void) startListener:(CDVInvokedUrlCommand*)command;

#pragma mark - Managing call logs Functions
- (void) getCallLogs:(CDVInvokedUrlCommand*)command;
- (void) clearCallLogs:(CDVInvokedUrlCommand*)command;
- (void) getCallPeerHistoryForCallId:(CDVInvokedUrlCommand*)command;
- (void) findCallLogFromCallId:(CDVInvokedUrlCommand*)command;
- (void) removeCallLogFromCallId:(CDVInvokedUrlCommand*)command;
- (void) getLastOutgoingCallLog:(CDVInvokedUrlCommand*)command;
- (void) getMissedCallsCount:(CDVInvokedUrlCommand*)command;
- (void) resetMissedCallsCount:(CDVInvokedUrlCommand*)command;

#pragma mark - Obtaining information about a running call: sound volumes, quality indicators Functions
- (void) getCallInformation:(CDVInvokedUrlCommand*)command;
- (void) getCallInformationWithCallId:(CDVInvokedUrlCommand*)command;
- (void) terminateCall:(CDVInvokedUrlCommand*)command;
- (void) terminateCallWithCallId:(CDVInvokedUrlCommand*)command;
- (void) sendDtmf:(CDVInvokedUrlCommand*)command;
- (void) sendDtmfWithCallId:(CDVInvokedUrlCommand*)command;
- (void) muteCall:(CDVInvokedUrlCommand*)command;
- (void) unmuteCall:(CDVInvokedUrlCommand*)command;
- (void) enableSpeaker:(CDVInvokedUrlCommand*)command;
- (void) disableSpeaker:(CDVInvokedUrlCommand*)command;
- (void) holdCall:(CDVInvokedUrlCommand*)command;
- (void) holdCallWithCallId:(CDVInvokedUrlCommand*)command;
- (void) unholdCall:(CDVInvokedUrlCommand*)command;
- (void) unholdCallWithCallId:(CDVInvokedUrlCommand*)command;
- (void) setSpeakerVolumeGain:(CDVInvokedUrlCommand*)command;
- (void) setSpeakerVolumeGainWithCallId:(CDVInvokedUrlCommand*)command;
- (void) setMicrophoneVolumeGain:(CDVInvokedUrlCommand*)command;
- (void) setMicrophoneVolumeGainWithCallId:(CDVInvokedUrlCommand*)command;
- (void) getAudioStats:(CDVInvokedUrlCommand*)command;
- (void) getAudioStatsWithCallId:(CDVInvokedUrlCommand*)command;
- (void) getVideoStats:(CDVInvokedUrlCommand*)command;
- (void) getVideoStatsWithCallId:(CDVInvokedUrlCommand*)command;
- (void) getTextStats:(CDVInvokedUrlCommand*)command;
- (void) getTextStatsWithCallId:(CDVInvokedUrlCommand*)command;
- (void) startRecording:(CDVInvokedUrlCommand*)command;
- (void) startRecordingWithCallId:(CDVInvokedUrlCommand*)command;
- (void) stopRecording:(CDVInvokedUrlCommand*)command;
- (void) stopRecordingWithCallId:(CDVInvokedUrlCommand*)command;
- (void) linphoneCallEnableEchoCancellation:(CDVInvokedUrlCommand*)command;
- (void) linphoneCallEnableEchoCancellationWithCallId:(CDVInvokedUrlCommand*)command;
- (void) linphoneCallEnableEchoLimiter:(CDVInvokedUrlCommand*)command;
- (void) linphoneCallEnableEchoLimiterWithCallId:(CDVInvokedUrlCommand*)command;

#pragma mark - Controlling network parameters (ports, mtu...) Functions
- (void) setAudioPort:(CDVInvokedUrlCommand*)command;
- (void) setVideoPort:(CDVInvokedUrlCommand*)command;
- (void) setTextPort:(CDVInvokedUrlCommand*)command;
- (void) setSipPort:(CDVInvokedUrlCommand*)command;
- (void) setSipTransport:(CDVInvokedUrlCommand*)command;
- (void) enableIpv6:(CDVInvokedUrlCommand*)command;
- (void) setSipDscp:(CDVInvokedUrlCommand*)command;
- (void) setAudioDscp:(CDVInvokedUrlCommand*)command;
- (void) setVideoDscp:(CDVInvokedUrlCommand*)command;
- (void) setStunServer:(CDVInvokedUrlCommand*)command;
- (void) setNatAddress:(CDVInvokedUrlCommand*)command;
- (void) setFirewallPolicy:(CDVInvokedUrlCommand*)command;
- (void) setNetworkReachable:(CDVInvokedUrlCommand*)command;
- (void) enableKeepAlive:(CDVInvokedUrlCommand*)command;
- (void) enableSdp200Ack:(CDVInvokedUrlCommand*)command;
- (void) getNetworkParameters:(CDVInvokedUrlCommand*)command;

#pragma mark - Controlling media parameters Functions
- (void) setAudioCodecs:(CDVInvokedUrlCommand*)command;
- (void) setVideoCodecs:(CDVInvokedUrlCommand*)command;
- (void) setAudioPortRange:(CDVInvokedUrlCommand*)command;
- (void) setVideoPortRange:(CDVInvokedUrlCommand*)command;
- (void) setTextPortRange:(CDVInvokedUrlCommand*)command;
- (void) setNortpTimeout:(CDVInvokedUrlCommand*)command;
- (void) setUseInfoForDtmf:(CDVInvokedUrlCommand*)command;
- (void) setUseRfc2833ForDtmf:(CDVInvokedUrlCommand*)command;
- (void) setRingLevel:(CDVInvokedUrlCommand*)command;
- (void) setMicGainDb:(CDVInvokedUrlCommand*)command;
- (void) setPlaybackGainDb:(CDVInvokedUrlCommand*)command;
- (void) setPlayLevel:(CDVInvokedUrlCommand*)command;
- (void) setRecLevel:(CDVInvokedUrlCommand*)command;
- (void) soundDeviceCanCapture:(CDVInvokedUrlCommand*)command;
- (void) soundDeviceCanPlayback:(CDVInvokedUrlCommand*)command;
- (void) setRingerDevice:(CDVInvokedUrlCommand*)command;
- (void) setPlaybackDevice:(CDVInvokedUrlCommand*)command;
- (void) setCaptureDevice:(CDVInvokedUrlCommand*)command;
- (void) setRing:(CDVInvokedUrlCommand*)command;
- (void) setRingback:(CDVInvokedUrlCommand*)command;
- (void) enableEchoCancellation:(CDVInvokedUrlCommand*)command;
- (void) setVideoPolicy:(CDVInvokedUrlCommand*)command;
- (void) enableVideoPreview:(CDVInvokedUrlCommand*)command;
- (void) enableSelfView:(CDVInvokedUrlCommand*)command;
- (void) setVideoDevice:(CDVInvokedUrlCommand*)command;
- (void) setDeviceRotation:(CDVInvokedUrlCommand*)command;
- (void) playDtmf:(CDVInvokedUrlCommand*)command;
- (void) stopDtmf:(CDVInvokedUrlCommand*)command;
- (void) setMtu:(CDVInvokedUrlCommand*)command;
- (void) stopRinging:(CDVInvokedUrlCommand*)command;
- (void) setAvpfMode:(CDVInvokedUrlCommand*)command;
- (void) setAvpfRRInterval:(CDVInvokedUrlCommand*)command;
- (void) setDownloadBandwidth:(CDVInvokedUrlCommand*)command;
- (void) setUploadBandwidth:(CDVInvokedUrlCommand*)command;
- (void) enableAdaptiveRateControl:(CDVInvokedUrlCommand*)command;
- (void) setAdaptiveRateAlgorithm:(CDVInvokedUrlCommand*)command;
- (void) setDownloadPtime:(CDVInvokedUrlCommand*)command;
- (void) setUploadPtime:(CDVInvokedUrlCommand*)command;
- (void) setSipTransportTimeout:(CDVInvokedUrlCommand*)command;
- (void) enableDnsSrv:(CDVInvokedUrlCommand*)command;
- (void) getAudioCodecs:(CDVInvokedUrlCommand*)command;
- (void) getVideoCodecs:(CDVInvokedUrlCommand*)command;
- (void) getTextCodecs:(CDVInvokedUrlCommand*)command;
- (void) setPayloadTypeBitrate:(CDVInvokedUrlCommand*)command;
- (void) enablePayloadType:(CDVInvokedUrlCommand*)command;
- (void) findPayloadType:(CDVInvokedUrlCommand*)command;
- (void) setPayloadTypeNumber:(CDVInvokedUrlCommand*)command;
- (void) enableAudioAdaptiveJittcomp:(CDVInvokedUrlCommand*)command;
- (void) setAudioJittcomp:(CDVInvokedUrlCommand*)command;
- (void) enableVideoAdaptiveJittcomp:(CDVInvokedUrlCommand*)command;
- (void) setVideoJittcomp:(CDVInvokedUrlCommand*)command;
- (void) reloadSoundDevices:(CDVInvokedUrlCommand*)command;
- (void) setRemoteRingbackTone:(CDVInvokedUrlCommand*)command;
- (void) setRingDuringIncomingEarlyMedia:(CDVInvokedUrlCommand*)command;
- (void) enableEchoLimiter:(CDVInvokedUrlCommand*)command;
- (void) enableVideoCapture:(CDVInvokedUrlCommand*)command;
- (void) enableVideoDisplay:(CDVInvokedUrlCommand*)command;
- (void) enableVideoSourceReuse:(CDVInvokedUrlCommand*)command;
- (void) setPreferredVideoSize:(CDVInvokedUrlCommand*)command;
- (void) setPreviewVideoSize:(CDVInvokedUrlCommand*)command;
- (void) setPreviewVideoSizeByName:(CDVInvokedUrlCommand*)command;
- (void) setPreferredVideoSizeByName:(CDVInvokedUrlCommand*)command;
- (void) setPreferredFramerate:(CDVInvokedUrlCommand*)command;
- (void) reloadVideoDevices:(CDVInvokedUrlCommand*)command;
- (void) setStaticPicture:(CDVInvokedUrlCommand*)command;
- (void) setStaticPictureFps:(CDVInvokedUrlCommand*)command;
- (void) usePreviewWindow:(CDVInvokedUrlCommand*)command;
- (void) setUseFiles:(CDVInvokedUrlCommand*)command;
- (void) setPlayFile:(CDVInvokedUrlCommand*)command;
- (void) setRecordFile:(CDVInvokedUrlCommand*)command;
- (void) setMediaEncryption:(CDVInvokedUrlCommand*)command;
- (void) setMediaEncryptionMandatory:(CDVInvokedUrlCommand*)command;
- (void) setAudioMulticastAddress:(CDVInvokedUrlCommand*)command;
- (void) setVideoMulticastAddress:(CDVInvokedUrlCommand*)command;
- (void) setAudioMulticastTtl:(CDVInvokedUrlCommand*)command;
- (void) setVideoMulticastTtl:(CDVInvokedUrlCommand*)command;
- (void) enableAudioMulticast:(CDVInvokedUrlCommand*)command;
- (void) enableVideoMulticast:(CDVInvokedUrlCommand*)command;
- (void) setVideoDisplayFilter:(CDVInvokedUrlCommand*)command;
- (void) getMediaParameters:(CDVInvokedUrlCommand*)command;


#pragma mark - Making an audio conference Functions
- (void) getAudioConferenceInformation:(CDVInvokedUrlCommand*)command;
- (void) getAllCalls:(CDVInvokedUrlCommand*)command;
- (void) addToConference:(CDVInvokedUrlCommand*)command;
- (void) removeFromConference:(CDVInvokedUrlCommand*)command;
- (void) leaveConference:(CDVInvokedUrlCommand*)command;
- (void) enterConference:(CDVInvokedUrlCommand*)command;
- (void) addAllToConference:(CDVInvokedUrlCommand*)command;
- (void) startConferenceRecording:(CDVInvokedUrlCommand*)command;
- (void) stopConferenceRecording:(CDVInvokedUrlCommand*)command;


#pragma mark - Chat room and Messaging Functions

- (void) getAllChatRooms:(CDVInvokedUrlCommand*)command;

- (void) setChatDatabasePath:(CDVInvokedUrlCommand*)command;

- (void) getChatRoomWithUsername:(CDVInvokedUrlCommand*)command;

- (void) getChatRoomFromUri:(CDVInvokedUrlCommand*)command;

- (void) deleteChatRoom:(CDVInvokedUrlCommand*)command;

- (void) disableChat:(CDVInvokedUrlCommand*)command;

- (void) enableChat:(CDVInvokedUrlCommand*)command;

-(void) uploadFileMessage:(CDVInvokedUrlCommand*)command;

-(void) startFileDownload:(CDVInvokedUrlCommand*)command;

-(void) cancelFileDownload:(CDVInvokedUrlCommand*)command;

-(void) cancelFileUpload:(CDVInvokedUrlCommand*)command;

- (void)sendMessageWithChatRoom:(CDVInvokedUrlCommand*)command;

-(void) markAsRead:(CDVInvokedUrlCommand*)command;

-(void) deleteMessage:(CDVInvokedUrlCommand*)command;

-(void) deleteHistory:(CDVInvokedUrlCommand*)command;

-(void) getHistory:(CDVInvokedUrlCommand*)command;

-(void) getHistoryRange:(CDVInvokedUrlCommand*)command;

-(void) compose:(CDVInvokedUrlCommand*)command;

-(void) addCustomHeader:(CDVInvokedUrlCommand*)command;

-(void) getCustomHeader:(CDVInvokedUrlCommand*)command;

#pragma mark - Managing Buddies and buddy list and presence Functions

-(void) getMyBuddy:(CDVInvokedUrlCommand*)command;

-(void) findFriendByUsername:(CDVInvokedUrlCommand*)command;

-(void) getFriendList:(CDVInvokedUrlCommand*)command;

- (void) notifyAllFriendList:(CDVInvokedUrlCommand*)command;

- (void) addFriend:(CDVInvokedUrlCommand*)command;

- (void) removeFriend:(CDVInvokedUrlCommand*)command;

- (void) acceptSubscriber:(CDVInvokedUrlCommand*)command;

- (void) rejectSubscriber:(CDVInvokedUrlCommand*)command;

-(void) findPresenceModelByUsername:(CDVInvokedUrlCommand*)command;

- (void) setBasicStatus:(CDVInvokedUrlCommand*)command;

- (void) setContact:(CDVInvokedUrlCommand*)command;

- (void) setActivity:(CDVInvokedUrlCommand*)command;

- (void) getNthActivity:(CDVInvokedUrlCommand*)command;

- (void) addActivity:(CDVInvokedUrlCommand*)command;

- (void) clearActivities:(CDVInvokedUrlCommand*)command;

- (void) getNote:(CDVInvokedUrlCommand*)command;

- (void) addNoteContent:(CDVInvokedUrlCommand*)command;

- (void) clearNotes:(CDVInvokedUrlCommand*)command;

- (void) getNthService:(CDVInvokedUrlCommand*)command;

- (void) addService:(CDVInvokedUrlCommand*)command;

- (void) clearServices:(CDVInvokedUrlCommand*)command;

- (void) getNthPerson:(CDVInvokedUrlCommand*)command;

- (void) addPerson:(CDVInvokedUrlCommand*)command;

- (void) clearPerson:(CDVInvokedUrlCommand*)command;

- (void) setIdForLinphonePresenceService:(CDVInvokedUrlCommand*)command;

- (void) setBasicStatusForLinphonePresenceService:(CDVInvokedUrlCommand*)command;

- (void) setContactForLinphonePresenceService:(CDVInvokedUrlCommand*)command;

- (void) getNthNoteFromService:(CDVInvokedUrlCommand*)command;

- (void) addNoteForLinphonePresenceService:(CDVInvokedUrlCommand*)command;

- (void) clearNotesForLinphonePresenceService:(CDVInvokedUrlCommand*)command;

- (void) setIdForLinphonePresencePerson:(CDVInvokedUrlCommand*)command;

- (void) getNthActivityForLinphonePresencePerson:(CDVInvokedUrlCommand*)command;

- (void) addActivityForLinphonePresencePerson:(CDVInvokedUrlCommand*)command;

- (void) clearActivitiesForLinphonePresencePerson:(CDVInvokedUrlCommand*)command;

- (void) getNthNoteFromPerson:(CDVInvokedUrlCommand*)command;

- (void) addNoteForLinphonePresencePerson:(CDVInvokedUrlCommand*)command;

- (void) clearNotesForLinphonePresencePerson:(CDVInvokedUrlCommand*)command;

- (void) getNthActivitiesNote:(CDVInvokedUrlCommand*)command;

- (void) addActivitiesNote:(CDVInvokedUrlCommand*)command;

- (void) clearActivitiesNotes:(CDVInvokedUrlCommand*)command;

@end