//
//  LinphoneHelper.h
//  HelloCordova
//
//  Created by Apple on 4/23/16.
//
//

#import <Foundation/Foundation.h>

#import "FileTransferDelegate.h"

#import "TTCallLog.h"
#import "TTLinphoneMediaEncryption.h"
#import "TTLinphoneAddress.h"
#import "TTLinphoneChatMessage.h"
#import "TTLinphoneUpnpState.h"
#import "TTLinphoneAVPFMode.h"
#import "TTMediaParameters.h"
#import "TTNetworkParameters.h"
#import "TTLinphoneCall.h"
#import "TTRange.h"
#import "TTLinphoneCallStats.h"
#import "TTLinphoneCallParams.h"
#import "TTPayloadType.h"
#import "TTConference.h"
#import "TTLinphoneFriend.h"
#import "TTLinphonePresenceActivity.h"
#import "TTLinphonePresenceActivityType.h"
#import "TTLinphonePresenceService.h"
#import "TTLinphonePresenceNote.h"
#import "TTLinphonePresencePerson.h"



@interface LinphoneHelper : NSObject {
    FileTransferDelegate *_ftd;
}

+ (LinphoneHelper*)instance;



- (void) initLinphoneCore;
- (void) destroyLinphoneCore;
- (void) registerSIPWithUsername:(NSString*)username displayName:(NSString*)displayName domain:(NSString*)domain password:(NSString*)password transport:(NSString*)transport;
- (void) deregisterSIPWithUsername:(NSString*)username domain:(NSString*)domain;
- (bool) getRegisterStatusSIPWithUsername:(NSString*)username domain:(NSString*)domain;
- (void) makeCallWithUsername:(NSString*)username domain:(NSString*)domain displayName:(NSString*)displayName;
- (void) acceptCall;
- (void) declineCall;
- (void) sendDtmf:(LinphoneCall*)call dtmf:(char)dtmf;
- (int) getVolumeMax;
- (void) volume:(int)volume;
- (void) terminateCall:(LinphoneCall*)call;
- (void) enableSpeaker;
- (void) disableSpeaker;
- (void) holdCall:(LinphoneCall*)call;
- (void) unholdCall:(LinphoneCall*)call;
- (void) startListener;


#pragma mark - Obtaining information about a running call: sound volumes, quality indicators Functions

-(LinphoneCall*) getCurrentCall;

-(void) setSpeakerVolumeGain:(LinphoneCall*)call volume:(int)volume;

-(void) setMicrophoneVolumeGain:(LinphoneCall*)call volume:(int)volume;

-(TTLinphoneCallStats*) getAudioStats:(LinphoneCall*)call;

-(TTLinphoneCallStats*) getVideoStats:(LinphoneCall*)call;

-(TTLinphoneCallStats*) getTextStats:(LinphoneCall*)call;

-(void) startRecording:(LinphoneCall*)call;

-(void) stopRecording:(LinphoneCall*)call;

-(void) linphoneCallEnableEchoCancellation:(BOOL)enabled linphoneCall:(LinphoneCall*)call;

-(void) linphoneCallEnableEchoLimiter:(BOOL)enabled linphoneCall:(LinphoneCall*)call;

-(TTLinphoneCall*) getTTLinphoneCall:(LinphoneCall*)call;


#pragma mark - Controlling network parameters (ports, mtu...) Functions

-(void) setAudioPort:(int)port;

-(void) setVideoPort:(int)port;

-(void) setTextPort:(int)port;

-(void) setSipPort:(int)port;

-(void) setSipTransport:(const LCSipTransports*) tr_config;

-(void) enableIpv6:(BOOL)enabled;

-(void) setSipDscp:(int)dscp;

-(void) setAudioDscp:(int)dscp;

-(void) setVideoDscp:(int)dscp;

-(void) setStunServer:(NSString*) server;

-(void) setNatAddress:(NSString*) address;

-(void) setFirewallPolicy:(NSString*) firewallPolicy;

-(void) setNetworkReachable:(BOOL)reachable;

-(void) enableKeepAlive:(BOOL)enabled;

-(void) enableSdp200Ack:(BOOL) enabled;

-(TTNetworkParameters*) getNetworkParameters;


#pragma mark - Controlling media parameters Functions

-(int) setAudioCodecs:(MSList*) codecs;

-(int) setVideoCodecs:(MSList*) codecs;

-(void) setAudioPortRangeWithMinPort:(int)minPort maxPort:(int)maxPort;

-(void) setVideoPortRangeWithMinPort:(int)minPort maxPort:(int)maxPort;

-(void) setTextPortRangeWithMinPort:(int)minPort maxPort:(int)maxPort;

-(void) setNortpTimeout:(int)nortpTimeout;

-(void) setUseInfoForDtmf:(BOOL) useInfo;

-(void) setUseRfc2833ForDtmf:(BOOL)useRfc2833;

-(void) setRingLevel:(int)level;

-(void) setMicGainDb:(float)gaindb;

-(void) setPlaybackGainDb:(float)gaindb;

-(void) setPlayLevel:(int)level;

-(void) setRecLevel:(int)level;

-(BOOL) soundDeviceCanCapture:(NSString*)devid;

-(BOOL) soundDeviceCanPlayback:(NSString*)devid;

-(int) setRingerDevice:(NSString*)devid;

-(int) setPlaybackDevice:(NSString*)devid;

-(int) setCaptureDevice:(NSString*)devid;

-(void) setRing:(NSString*)path;

-(void) setRingback:(NSString*) path;

-(void) enableEchoCancellation:(BOOL) enabled;

-(void) setVideoPolicy:(LinphoneVideoPolicy*)policy;

-(void) enableVideoPreview:(BOOL)enabled;

-(void) enableSelfView:(BOOL)enabled;

-(int) setVideoDevice:(NSString*)id;

-(void) setDeviceRotation:(int)rotation;

-(void) playDtmf:(char)dtmf duration:(int)durationInMS;

-(void) stopDtmf;

-(void) setMtu:(int)mtu;

-(void) stopRinging;

-(void) setAvpfMode:(NSString*)mode;

-(void) setAvpfRRInterval:(int)interval;

-(void) setDownloadBandwidth:(int)bandwidth;

-(void) setUploadBandwidth:(int)bandwidth;


-(void) enableAdaptiveRateControl:(BOOL)enabled;

-(void) setAdaptiveRateAlgorithm:(NSString*)algorithm;

-(void) setDownloadPtime:(int)ptime;

-(void) setUploadPtime:(int)ptime;

-(void) setSipTransportTimeout:(int)timeoutInMS;

-(void) enableDnsSrv:(BOOL)enabled;

-(NSArray*) getAudioCodecs;

-(NSArray*) getVideoCodecs;

-(NSArray*) getTextCodecs;

-(void) setPayloadTypeBitrate:(NSString*)type rate:(int)rate bitrate:(int)bitrate;

-(int) enablePayloadType:(NSString*)type rate:(int)rate enable:(BOOL)enable;

-(TTPayloadType*) findPayloadType:(NSString*)type rate:(int)rate channels:(int)channels;

-(void) setPayloadTypeNumber:(NSString*)type rate:(int)rate number:(int)number;

-(void) enableAudioAdaptiveJittcomp:(BOOL) enabled;

-(void) setAudioJittcomp:(int) millisecond;

-(void) enableVideoAdaptiveJittcomp:(BOOL) enabled;

-(void) setVideoJittcomp:(int) milliseconds;

-(void) reloadSoundDevices;

-(void) setRemoteRingbackTone:(NSString*) ring;

-(void) setRingDuringIncomingEarlyMedia:(BOOL)enabled;

-(void) enableEchoLimiter:(BOOL)enabled;

-(void) enableMic:(BOOL)enabled;

-(void) enableVideoCapture:(BOOL)enabled;

-(void) enableVideoDisplay:(BOOL)enabled;

-(void) enableVideoSourceReuse:(BOOL)enabled;

-(void) setPreferredVideoSize:(int)width height:(int)height;

-(void) setPreviewVideoSize:(int)width height:(int)height;

-(void) setPreviewVideoSizeByName:(NSString*)name;

-(void) setPreferredVideoSizeByName:(NSString*)name;

-(void) setPreferredFramerate:(float)fps;

-(void) reloadVideoDevices;

-(int) setStaticPicture:(NSString*)path;

-(int) setStaticPictureFps:(float)fps;

-(void) usePreviewWindow:(BOOL)use;

-(void) setUseFiles:(BOOL)use;

-(void) setPlayFile:(NSString*)file;

-(void) setRecordFile:(NSString*)file;

-(int) setMediaEncryption:(NSString*)mediaEncryption;

-(void) setMediaEncryptionMandatory:(BOOL)mandatory;

-(int) setAudioMulticastAddress:(NSString*)ip;

-(int) setVideoMulticastAddress:(NSString*)ip;

-(int) setAudioMulticastTtl:(int)ttl;

-(int) setVideoMulticastTtl:(int)ttl;

-(void) enableAudioMulticast:(BOOL)enabled;

-(void) enableVideoMulticast:(BOOL)enabled;

-(void) setVideoDisplayFilter:(NSString*)filterName;

-(TTMediaParameters*) getMediaParameters;


#pragma mark - Managing call logs Functions

- (NSDictionary*) getCallLogs:(NSString*)callStatus callDirection:(NSString*)callDirection;
- (void) clearCallLogs;
- (NSArray*) getCallPeerHistoryForCallId:(NSString*)callId;
- (TTCallLog*) findCallLogFromCallId:(NSString*)callId;
- (void) removeCallLogWithCallId:(NSString*)callId;
- (TTCallLog*) getLastOutgoingCallLog;
- (int) getMissedCallsCount;
- (void) resetMissedCallsCount;


#pragma mark - Making an audio conference Functions

- (TTConference*) getTTConference;
- (NSArray*) getAllCalls;
- (void) addToConference:(LinphoneCall*)call;
- (void) removeFromConference:(LinphoneCall*)call;
- (void) leaveConference;
- (void) enterConference;
- (void) addAllToConference;
- (void) startConferenceRecording:(NSString*)path;
- (void) stopConferenceRecording;
- (LinphoneCall*) getLinphoneCallFromCallId:(NSString*)callid;


#pragma mark - Managing Buddies and buddy list and presence Functions

- (LinphonePresenceModel*) getMyOnlineStatus;

- (LinphoneFriend*) findFriendByUsername:(NSString*)username domain:(NSString*)domain;

- (const LinphonePresenceModel*) findPresenceModelByUsername:(NSString*)username domain:(NSString*)domain;

- (const LinphonePresenceModel*) findPresenceModel:(LinphoneFriend*)friend;

- (NSArray*) getFriendList;

- (LinphoneFriend*) createOrEditLinphoneFriendWithAddress:(NSString*)username domain:(NSString*)domain;

- (void) notifyAllFriendList:(LinphonePresenceModel *)presence;

- (void) addFriend:(LinphoneFriend*)linphoneFriend;

- (void) removeFriend:(LinphoneFriend*)linphoneFriend;

- (void) acceptSubscriber:(LinphoneFriend*)linphoneFriend;

- (void) rejectSubscriber:(LinphoneFriend*)linphoneFriend;

- (LinphonePresenceModel*) createNewLinphonePresenceModelWithActivity:(LinphonePresenceActivityType)activity description:(NSString*)description;

- (void) setBasicStatus:(LinphonePresenceModel*) model basicStatus:(LinphonePresenceBasicStatus)basicStatus;

- (void) setContact:(LinphonePresenceModel*) model contact:(NSString*)contact;

- (void) setActivity:(LinphonePresenceModel*)model activity:(LinphonePresenceActivityType)activity description:(NSString*)description;

- (LinphonePresenceActivity*) getNthActivity:(LinphonePresenceModel*)model index:(unsigned int)index;

- (LinphonePresenceActivity*) createNewWithActivity:(LinphonePresenceActivityType)type description:(NSString*)description;

- (void) addActivity:(LinphonePresenceModel*)model activity:(LinphonePresenceActivity*) activity;

- (void) clearActivities:(LinphonePresenceModel*)model;

- (LinphonePresenceNote*) getNote:(LinphonePresenceModel*)model lang:(NSString*)lang;

- (void) addNote:(LinphonePresenceModel*)model noteContent:(NSString*)noteContent lang:(NSString*)lang;

- (void) clearNotes:(LinphonePresenceModel*)model;

- (LinphonePresenceService*) getNthService:(LinphonePresenceModel*)model index:(unsigned int)index;

- (LinphonePresenceService*) createNewService:(LinphonePresenceBasicStatus)basicStatus contact:(NSString*)contact;

- (void) addService:(LinphonePresenceModel*)model service:(LinphonePresenceService *)service;

- (void) clearServices:(LinphonePresenceModel*)model;

- (LinphonePresencePerson*) getNthPerson:(LinphonePresenceModel*)model index:(unsigned int)index;

- (LinphonePresencePerson*) createNewPerson;

- (void) addPerson:(LinphonePresenceModel*)model person:(LinphonePresencePerson*)person;

- (void) clearPerson:(LinphonePresenceModel*)model;

- (void) setIdForLinphonePresenceService:(LinphonePresenceService*)service id:(NSString*)id;

- (void) setBasicStatusForLinphonePresenceService:(LinphonePresenceService*)service basicStatus:(LinphonePresenceBasicStatus) basicStatus;

- (void) setContactForLinphonePresenceService:(LinphonePresenceService*)service contact:(NSString*) contact;

- (LinphonePresenceNote*) getNthNoteFromService:(LinphonePresenceService*)service index:(unsigned int) index;

- (LinphonePresenceNote*) createNewNote:(NSString*)content lang:(NSString*)lang;

- (void) addNoteForLinphonePresenceService:(LinphonePresenceService*)service note:(LinphonePresenceNote *)note;

- (void) clearNotesForLinphonePresenceService:(LinphonePresenceService*)service;

- (void) setIdForLinphonePresencePerson:(LinphonePresencePerson*)person id:(NSString*)id;

- (LinphonePresenceActivity*) getNthActivityForLinphonePresencePerson:(LinphonePresencePerson*)person index:(unsigned int)index;

- (void) addActivityForLinphonePresencePerson:(LinphonePresencePerson*)person activity:(LinphonePresenceActivity *)activity;

- (void) clearActivitiesForLinphonePresencePerson:(LinphonePresencePerson*)person;

- (LinphonePresenceNote*) getNthNoteFromPerson:(LinphonePresencePerson*)person index:(unsigned int)index;

- (void) addNoteForLinphonePresencePerson:(LinphonePresencePerson*)person note:(LinphonePresenceNote*)note;

- (void) clearNotesForLinphonePresencePerson:(LinphonePresencePerson*)person;

- (LinphonePresenceNote*) getNthActivitiesNote:(LinphonePresencePerson*)person index:(unsigned int)index;

- (void) addActivitiesNote:(LinphonePresencePerson*)person note:(LinphonePresenceNote*)note;

- (void) clearActivitiesNotes:(LinphonePresencePerson*)person;

- (void) createNewLinphonePresenceActivity:(NSString*)presenceActivityType description:(NSString*)description;

- (void) setTypeForLinphonePresenceActivity:(LinphonePresenceActivity*)activity type:(NSString*)type;

- (void) setDescriptionForLinphonePresenceActivity:(LinphonePresenceActivity*)activity description:(NSString*)description;

- (void) setContentForLinphonePresenceNote:(LinphonePresenceNote*)note content:(NSString*)content;

- (void) setLangForLinphonePresenceNote:(LinphonePresenceNote*)note lang:(NSString*)lang;



#pragma mark - Chat room and Messaging Functions

-(NSArray*) getAllChatRooms;

-(void) setChatDatabasePath:(NSString*)path;

-(LinphoneChatRoom *) getChatRoomWithUsername:(NSString*)username domain:(NSString*)domain;

-(LinphoneChatRoom *) getChatRoomFromUri:(NSString*) toUri;

-(void) deleteChatRoom:(LinphoneChatRoom*) chatRoom;

-(void) disableChat:(LinphoneReason) denyReason;

-(void) enableChat;

-(void) upload:(UIImage *)image withURL:(NSURL *)url forChatRoom:(LinphoneChatRoom *)chatRoom;

-(void) startFileDownload:(LinphoneChatMessage *)message;

-(void) cancelFileDownload:(LinphoneChatMessage *)message;

-(void) cancelFileUpload;

- (BOOL)sendMessageWithChatRoom:(LinphoneChatRoom *)chatRoom message:(NSString*)message withExterlBodyUrl:(NSURL *)externalUrl withInternalURL:(NSURL *)internalUrl;

-(void) markAsRead:(LinphoneChatRoom*) chatRoom;

-(void) deleteMessage:(LinphoneChatRoom*) chatRoom chatMessage:(LinphoneChatMessage*) message;

-(void) deleteHistory:(LinphoneChatRoom*) chatRoom;

-(NSArray*) getHistory:(LinphoneChatRoom *) chatRoom numberOfMessages:(int)numberOfMessages;

-(NSArray*) getHistoryRange:(LinphoneChatRoom *) chatRoom begin:(int)begin end:(int)end;

-(void) compose:(LinphoneChatRoom *) chatRoom;

- (int)unreadTotalMessageCount;

- (LinphoneChatRoom *)findChatRoomForContact:(NSString *)contact;

- (LinphoneChatMessage *)findChatMessageWithChatRoom:(LinphoneChatRoom *)chatRoom messageStoreId:(unsigned int)messageStoreId;

- (LinphoneChatMessageCbs *)getLinphoneChatMessageCbs:(LinphoneChatMessage *)message;

-(void) addCustomHeader:(LinphoneChatMessage *)message headerName:(NSString*)headerName headerValue:(NSString*)headerValue;

-(const char*) getCustomHeader:(LinphoneChatMessage *)message headerName:(NSString*)headerName;

-(void) setMsgStateChangedCb:(LinphoneChatMessageCbs *)cbs msgStateChangedCb:(LinphoneChatMessageCbsMsgStateChangedCb)cb;

-(void) setFileTransferRecv:(LinphoneChatMessageCbs *)cbs fileTransferRecvCb:(LinphoneChatMessageCbsFileTransferRecvCb)cb;

-(void) setFileTransferSend:(LinphoneChatMessageCbs *)cbs fileTransferSendCb:(LinphoneChatMessageCbsFileTransferSendCb)cb;

-(void) setFileTransferProgressIndication:(LinphoneChatMessageCbs *)cbs fileTransferProgressIndicationCb:(LinphoneChatMessageCbsFileTransferProgressIndicationCb)cb;
@end
