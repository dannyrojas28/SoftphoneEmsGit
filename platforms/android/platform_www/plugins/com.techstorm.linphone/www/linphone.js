cordova.define("com.techstorm.linphone.LinphonePlugin", function(require, exports, module) {
var Linphone = function() {};
               
/**
 * Start linphone core.
 */
               Linphone.prototype.initLinphoneCore = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "initLinphoneCore", []);
               };
               
/**
 * Register a SIP account.
 * @param {string} username - The username of the SIP account to register.
 * @param {string} domain - The domain of the SIP account to register.
 * @param {string} displayName - The display name of the SIP account to register.
 * @param {string} password - The password of the SIP account to register.
 * @param {string} transport - The transport of the SIP account to register.
 */
               Linphone.prototype.registerSIP = function(username, displayName, domain, password, transport, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "registerSIP", [username, displayName, domain, password, transport]);
               };
               
/**
 * De-register a SIP account.
 * @param {string} username - The username of the SIP account to be de-registered.
 * @param {string} domain - The domain of the SIP account to be de-registered.
 */
               Linphone.prototype.deregisterSIP = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "deregisterSIP", [username, domain]);
               };
               
/**
 * Indicating that the user is sucessfully registered.
 * @param {string} username - The username of the SIP account to be chec.ked
 * @param {string} domain - The domain of the SIP account to be checked.
 */
               Linphone.prototype.getRegisterStatusSIP = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getRegisterStatusSIP", [username, domain]);
               };
               
/**
 * Initiates an outgoing call given a destination. this can make multiple outgoing calls.
 * @param {string} username - The username of destination.
 * @param {string} domain - The domain of destination.
 * @param {string} displayName - The display name of destination.
 */
               Linphone.prototype.makeCall = function(username, domain, displayName, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "makeCall", [username, domain, displayName]);
               };
               
/**
 * Accept an incoming call.
 */
               Linphone.prototype.acceptCall = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "acceptCall", []);
               };
               
/**
 * Decline an incoming call or hangup the current call which is in call.
 */
               Linphone.prototype.declineCall = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "declineCall", []);
               };
               
               
               
               // Managing call logs Functions
               
/**
 * Get the list of call logs (past calls) given status and direction.
 * @param {string} callStatus - The status of the call needed to search. Leaving as empty string mean get all call log with all statuses. OPTIONS: CallSuccess, CallAborted, CallMissed, CallDeclined.
 * @param {string} callDirection - The direction of the call needed to search. Leaving as empty string mean get all call log with all directions. OPTIONS: CallOutgoing, CallIncoming.
 */
               Linphone.prototype.getCallLogs = function(callStatus, callDirection, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getCallLogs", [callStatus, callDirection]);
               };
               
/**
 * Get the list of call logs (past calls) related to a peer given a call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.getCallPeerHistoryForCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getCallPeerHistoryForCallId", [callId]);
               };
               
/**
 * Erase the call log.
 */
               Linphone.prototype.clearCallLogs = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearCallLogs", []);
               };
               
/**
 * Get the list of call logs given a call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.findCallLogFromCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "findCallLogFromCallId", [callId]);
               };
               
/**
 * Delete an call log given a call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.removeCallLogFromCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "removeCallLogFromCallId", [callId]);
               };
               
/**
 * Get the last outgoing call log.
 */
               Linphone.prototype.getLastOutgoingCallLog = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getLastOutgoingCallLog", []);
               };
               
/**
 * Get number of miss calls.
 */
               Linphone.prototype.getMissedCallsCount = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getMissedCallsCount", []);
               };
               
/**
 * Reset the counter of missed calls.
 */
               Linphone.prototype.resetMissedCallsCount = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "resetMissedCallsCount", []);
               };
               
               
               
               // Obtaining information about a running call: sound volumes, quality indicators
               
/**
 * Get information of the current call if one is in call.
 */
               Linphone.prototype.getCallInformation = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getCallInformation", []);
               };
               
/**
 * Get information of a call given call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.getCallInformationWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getCallInformationWithCallId", [callId]);
               };
               
/**
 * Terminate the current call if one is in call, or terminate conference if one is in conference. Note: this will terminate all calls if no current call found.
 */
               Linphone.prototype.terminateCall = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "terminateCall", []);
               };
               
/**
 * Terminate a call given call ID, or terminate conference if one is in conference. Note: this will terminate all calls if call ID not found.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.terminateCallWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "terminateCallWithCallId", [callId]);
               };
               
/**
 * Send the specified dtmf.
 *
 * The dtmf is automatically played to the user.
 * @param {string} dtmf - The dtmf name specified as a char, such as '0', '#' etc...
 */
               Linphone.prototype.sendDtmf = function(dtmf, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "sendDtmf", [keyCode]);
               };
               
/**
 * Send the specified dtmf given call ID.
 *
 * The dtmf is automatically played to the user.
 * @param {string} callId - The identity of the call.
 * @param {string} keyCode - The dtmf name specified as a char, such as '0', '#' etc...
 */
               Linphone.prototype.sendDtmfWithCallId = function(callId, keyCode, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "sendDtmfWithCallId", [callId, keyCode]);
               };
               
/**
 * Disable the microphone.
 */
               Linphone.prototype.muteCall = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "muteCall", []);
               };
               
/**
 * Enable the microphone.
 */
               Linphone.prototype.unmuteCall = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "unmuteCall", []);
               };
               
/**
 * Enable the speaker.
 */
               Linphone.prototype.enableSpeaker = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableSpeaker", []);
               };
               
/**
 * Disable the speaker.
 */
               Linphone.prototype.disableSpeaker = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "disableSpeaker", []);
               };
               
/**
 * Pause the current call if one is in call, or leave conference if one is in conference. Note: this will pause all calls if no current call found.
 */
               Linphone.prototype.holdCall = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "holdCall", []);
               };
               
/**
 * Pause a call given call ID, or leave conference if one is in conference. Note: this will pause all calls if call ID not found.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.holdCallWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "holdCallWithCallId", [callId]);
               };
               
/**
 * Resume the current call if one is in call, or enter conference if one is in conference. Note: this will resume all calls if no current call found.
 */
               Linphone.prototype.unholdCall = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "unholdCall", []);
               };
               
/**
 * Resume a call given call ID, or enter conference if one is in conference. Note: this will resume all calls if call ID not found.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.unholdCallWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "unholdCallWithCallId", [callId]);
               };
               
/**
 * Set speaker volume gain for the current call.
 * If the sound backend supports it, the new gain will synchronized with the system mixer.
 * @param {float} volume - Percentage of the max supported gain. Valid values are in [ 0.0 : 1.0 ].
 */
               Linphone.prototype.setSpeakerVolumeGain = function(volume, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setSpeakerVolumeGain", [volume]);
               };
               
/**
 * Set speaker volume gain for a call given call ID.
 * If the sound backend supports it, the new gain will synchronized with the system mixer.
 * @param {string} callId - The identity of the call.
 * @param {float} volume - Percentage of the max supported gain. Valid values are in [ 0.0 : 1.0 ].
 */
               Linphone.prototype.setSpeakerVolumeGainWithCallId = function(callId, volume, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setSpeakerVolumeGainWithCallId", [callId, volume]);
               };
               
/**
 * Set microphone volume gain for the current call.
 * If the sound backend supports it, the new gain will synchronized with the system mixer.
 * @param {float} volume - Percentage of the max supported gain. Valid values are in [ 0.0 : 1.0 ].
 */
               Linphone.prototype.setMicrophoneVolumeGain = function(volume, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setMicrophoneVolumeGain", [volume]);
               };
               
/**
 * Set microphone volume gain for a call given call ID.
 * If the sound backend supports it, the new gain will synchronized with the system mixer.
 * @param {string} callId - The identity of the call.
 * @param {float} volume - Percentage of the max supported gain. Valid values are in [ 0.0 : 1.0 ].
 */
               Linphone.prototype.setMicrophoneVolumeGainWithCallId = function(callId, volume, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setMicrophoneVolumeGainWithCallId", [callId, volume]);
               };
               
/**
 * Get audio stats which carries various statistic informations regarding quality of audio streams for the current call. At any time, the application can access last computed statistics by using this function.
 */
               Linphone.prototype.getAudioStats = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getAudioStats", []);
               };
               
/**
 * Get audio stats which carries various statistic informations regarding quality of audio streams for a call given call ID. At any time, the application can access last computed statistics by using this function.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.getAudioStatsWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getAudioStatsWithCallId", [callId]);
               };
               
/**
 * Get video stats which carries various statistic informations regarding quality of video streams for the current call. At any time, the application can access last computed statistics by using this function.
 */
               Linphone.prototype.getVideoStats = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getVideoStats", []);
               };
               
/**
 * Get video stats which carries various statistic informations regarding quality of video streams for a call given call ID. At any time, the application can access last computed statistics by using this function.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.getVideoStatsWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getVideoStatsWithCallId", [callId]);
               };
               
/**
 * Get text stats which carries various statistic informations regarding quality of text streams for the current call. At any time, the application can access last computed statistics by using this function.
 */
               Linphone.prototype.getTextStats = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getTextStats", []);
               };
               
/**
 * Get text stats which carries various statistic informations regarding quality of text streams for a call given call ID. At any time, the application can access last computed statistics by using this function.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.getTextStatsWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getTextStatsWithCallId", [callId]);
               };
               
/**
 * Start recording for the current call.
 */
               Linphone.prototype.startRecording = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "startRecording", []);
               };
               
/**
 * Start recording for a call given call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.startRecordingWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "startRecordingWithCallId", [callId]);
               };
               
/**
 * Stop recording for the current call.
 */
               Linphone.prototype.stopRecording = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "stopRecording", []);
               };
               
/**
 * Stop recording for a call given call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.stopRecordingWithCallId = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "stopRecordingWithCallId", [callId]);
               };
               
/**
 * Enables or disable echo cancellation for the current call.
 */
               Linphone.prototype.linphoneCallEnableEchoCancellation = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "linphoneCallEnableEchoCancellation", [enabled]);
               };
               
/**
 * Enables or disable echo cancellation for a call given call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.linphoneCallEnableEchoCancellationWithCallId = function(callId, enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "linphoneCallEnableEchoCancellationWithCallId", [callId, enabled]);
               };
               
/**
 * Enables or disable echo limiter for the current call.
 */
               Linphone.prototype.linphoneCallEnableEchoLimiter = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "linphoneCallEnableEchoLimiter", [enabled]);
               };
               
/**
 * Enables or disable echo limiter for a call given call ID.
 * @param {string} callId - The identity of the call.
 */
               Linphone.prototype.linphoneCallEnableEchoLimiterWithCallId = function(callId, enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "linphoneCallEnableEchoLimiterWithCallId", [callId, enabled]);
               };
               
               
               
               
               // Controlling network parameters (ports, mtu...)
               
/**
 * Get network parameters (ports, mtu...).
 */
               Linphone.prototype.getNetworkParameters = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNetworkParameters", []);
               };
               
/**
 * Sets the UDP port used for audio streaming. A value if -1 will request the system to allocate the local port randomly. This is recommended in order to avoid firewall warnings.
 * @param {int} audioPort - The audio port to be used.
 */
               Linphone.prototype.setAudioPort = function(audioPort, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAudioPort", [audioPort]);
               };
               
/**
 * Sets the UDP port used for video streaming. A value if -1 will request the system to allocate the local port randomly. This is recommended in order to avoid firewall warnings.
 * @param {int} videoPort - The video port to be used.
 */
               Linphone.prototype.setVideoPort = function(videoPort, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoPort", [videoPort]);
               };
               
/**
 * Sets the UDP port used for text streaming. A value if -1 will request the system to allocate the local port randomly. This is recommended in order to avoid firewall warnings.
 * @param {int} textPort - The text port to be used.
 */
               Linphone.prototype.setTextPort = function(textPort, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setTextPort", [textPort]);
               };
               
/**
 * Sets the UDP port to be used by SIP.
 * @param {int} sipPort - The sip port to be used.
 */
               Linphone.prototype.setSipPort = function(sipPort, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setSipPort", [sipPort]);
               };
               
/**
 * Sets the ports to be used for each of transport (UDP or TCP)
 *
 * A zero value port for a given transport means the transport is not used. A value of LC_SIP_TRANSPORT_RANDOM (-1) means the port is to be choosen randomly by the system.
 * @param {int} udpPort - The UDP port to be used.
 * @param {int} tcpPort - The TCP port to be used.
 * @param {int} dtlsPort - The DTLS port to be used.
 * @param {int} tlsPort - The TLS port to be used.
 */
               Linphone.prototype.setSipTransport = function(udpPort, tcpPort, dtlsPort, tlsPort, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setSipTransport", [udpPort, tcpPort, dtlsPort, tlsPort]);
               };
               
/**
 * Turns IPv6 support on or off.
 * Note
 *      IPv6 support is exclusive with IPv4 in liblinphone: when IPv6 is turned on, IPv4 calls won't be possible anymore. By default IPv6 support is off.
 * @param {boolean} enabled - Define whether the feature is enabled or not.
 */
               Linphone.prototype.enableIpv6 = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableIpv6", [enabled]);
               };
               
/**
 * Set the DSCP field for SIP signaling channel.
 *
 * The DSCP defines the quality of service in IP packets.
 * @param {int} sipDscp - The sip DSCP to be used.
 */
               Linphone.prototype.setSipDscp = function(sipDscp, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setSipDscp", [sipDscp]);
               };
               
/**
 * Set the DSCP field for outgoing audio streams.
 *
 * The DSCP defines the quality of service in IP packets.
 * @param {int} audioDscp - The audio DSCP to be used.
 */
               Linphone.prototype.setAudioDscp = function(audioDscp, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAudioDscp", [audioDscp]);
               };
               
/**
 * Set the DSCP field for outgoing video streams.
 *
 * The DSCP defines the quality of service in IP packets.
 * @param {int} videoDscp - The video DSCP to be used.
 */
               Linphone.prototype.setVideoDscp = function(videoDscp, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoDscp", [videoDscp]);
               };
               
/**
 * Set the STUN server address to use when the firewall policy is set to STUN.
 * @param {string} stunServer - The STUN server address to use.
 */
               Linphone.prototype.setStunServer = function(stunServer, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setStunServer", [stunServer]);
               };
               
/**
 * Set the public IP address of NAT when using the firewall policy is set to use NAT.
 * @param {string} natAddress - The public IP address of NAT to use.
 */
               Linphone.prototype.setNatAddress = function(natAddress, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setNatAddress", [natAddress]);
               };
               
/**
 * Set the policy to use to pass through firewalls.
 * @param {string} firewallPolicy - The firewall policy to be used. OPTIONS: PolicyNoFirewall, PolicyUseNatAddress, PolicyUseStun, PolicyUseIce, PolicyUseUpnp.
 */
               Linphone.prototype.setFirewallPolicy = function(firewallPolicy, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setFirewallPolicy", [firewallPolicy]);
               };
               
/**
 * This method is called by the application to notify the linphone core library when network is reachable.
 * Calling this method with true trigger linphone to initiate a registration process for all proxies.
 * Calling this method disables the automatic network detection mode. It means you must call this method after each network state changes.
 * @param {boolean} enabled - Define whether the feature is enabled or not.
 */
               Linphone.prototype.enableNetworkReachable = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setNetworkReachable", [enabled]);
               };
               
/**
 * Enable signaling keep alive. small udp packet sent periodically to keep udp NAT association.
 * @param {boolean} enabled - Define whether the feature is enabled or not.
 */
               Linphone.prototype.enableKeepAlive = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableKeepAlive", [enabled]);
               };
               
/**
 * Control when media offer is sent in SIP INVITE.
 * @param {boolean} enabled - True if INVITE has to be sent whitout SDP.
 */
               Linphone.prototype.enableSdp200Ack = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableSdp200Ack", [enabled]);
               };
               
/**
 * Get media parameters.
 */
               Linphone.prototype.getMediaParameters = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getMediaParameters", []);
               };
               
/**
 * Sets the list of audio codecs.
 * @param {string} audio_codecs - The audio codecs to be used.
 */
               Linphone.prototype.setAudioCodecs = function(audio_codecs, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAudioCodecs", [audio_codecs]);
               };
               
/**
 * Sets the list of video codecs.
 * @param {string} video_codecs - The video codecs to be used.
 */
               Linphone.prototype.setVideoCodecs = function(video_codecs, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoCodecs", [video_codecs]);
               };
               
/**
 * Sets the UDP port range from which to randomly select the port used for audio streaming.
 * @param {int} audio_port_min - The min audio port to be used.
 * @param {int} audio_port_max - The max audio port to be used.
 */
               Linphone.prototype.setAudioPortRange = function(audio_port_min, audio_port_max, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAudioPortRange", [audio_port_min, audio_port_max]);
               };
               
/**
 * Sets the UDP port range from which to randomly select the port used for video streaming.
 * @param {int} video_port_min - The min video port to be used.
 * @param {int} video_port_max - The max video port to be used.
 */
               Linphone.prototype.setVideoPortRange = function(video_port_min, video_port_max, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoPortRange", [video_port_min, video_port_max]);
               };
               
/**
 * Sets the UDP port range from which to randomly select the port used for text streaming.
 * @param {int} text_port_min - The min text port to be used.
 * @param {int} text_port_max - The max text port to be used.
 */
               Linphone.prototype.setTextPortRange = function(text_port_min, text_port_max, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setTextPortRange", [text_port_min, text_port_max]);
               };
               
/**
 * Sets the no-rtp timeout value in seconds.
 * @param {int} nortp_timeout - The nortp timeout in second.
 */
               Linphone.prototype.setNortpTimeout = function(nortp_timeout, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setNortpTimeout", [nortp_timeout]);
               };
               
/**
 * Sets whether SIP INFO is to be used for sending digits.
 * @param {boolean} enabled - Define whether the feature is enabled or not.
 */
               Linphone.prototype.setUseInfoForDtmf = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setUseInfoForDtmf", [enabled]);
               };
               
/**
 * Sets whether RFC2833 is to be used for sending digits.
 * @param {boolean} enabled - Define whether the feature is enabled or not.
 */
               Linphone.prototype.setUseRfc2833ForDtmf = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setUseRfc2833ForDtmf", [enabled]);
               };
               
/**
 * Set sound ring level in 0-100 scale.
 * @param {int} ring_level - The ring level to be used.
 */
               Linphone.prototype.setRingLevel = function(ring_level, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRingLevel", [ring_level]);
               };
               
/**
 * Allow to control microphone level: gain in db.
 * @param {float} mic_gain_db - The mic gain to be used.
 */
               Linphone.prototype.setMicGainDb = function(mic_gain_db, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setMicGainDb", [mic_gain_db]);
               };
               
/**
 * Allow to control play level before entering sound card: gain in db.
 * @param {float} playback_gain_db - The playback gain to be used.
 */
               Linphone.prototype.setPlaybackGainDb = function(playback_gain_db, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPlaybackGainDb", [playback_gain_db]);
               };
               
/**
 * Set sound playback level in 0-100 scale.
 * @param {int} play_level - The play level to be used.
 */
               Linphone.prototype.setPlayLevel = function(play_level, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPlayLevel", [play_level]);
               };
               
/**
 * Set sound capture level in 0-100 scale.
 * @param {int} rec_level - The rec level to be used.
 */
               Linphone.prototype.setRecLevel = function(rec_level, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRecLevel", [rec_level]);
               };
               
/**
 * Returns true if the specified sound device can capture sound.
 * @param {string} devid_can_capture - The device name.
 */
               Linphone.prototype.soundDeviceCanCapture = function(devid_can_capture, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "soundDeviceCanCapture", [devid_can_capture]);
               };
               
/**
 * Returns true if the specified sound device can play sound.
 * @param {string} devid_can_playback - The device name.
 */
               Linphone.prototype.soundDeviceCanPlayback = function(devid_can_playback, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "soundDeviceCanPlayback", [devid_can_playback]);
               };
               
/**
 * Sets the sound device used for ringing.
 * @param {string} ringer_device - The device name.
 */
               Linphone.prototype.setRingerDevice = function(ringer_device, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRingerDevice", [ringer_device]);
               };
               
/**
 * Sets the sound device used for playback.
 * @param {string} playback_device - The device name.
 */
               Linphone.prototype.setPlaybackDevice = function(playback_device, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPlaybackDevice", [playback_device]);
               };
               
/**
 * Sets the sound device used for capture.
 * @param {string} capture_device - The device name.
 */
               Linphone.prototype.setCaptureDevice = function(capture_device, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setCaptureDevice", [capture_device]);
               };
               
/**
 * Sets the path to a wav file used for ringing.
 * @param {string} ring_path - The file must be a wav 16bit linear. Local ring is disabled if null
 */
               Linphone.prototype.setRing = function(ring_path, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRing", [ring_path]);
               };
               
/**
 * Sets the path to a wav file used for ringing back.
 *
 * Ringback means the ring that is heard when it's ringing at the remote party.
 * @param {string} ringback_path - The file must be a wav 16bit linear. Local ringback is disabled if null
 */
               Linphone.prototype.setRingback = function(ringback_path, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRingback", [ringback_path]);
               };
               
/**
 * Enables or disable echo cancellation. Value is saved and used for subsequent calls. This actually controls software echo cancellation. If hardware echo cancellation is available, it will be always used and activated for calls, regardless of the value passed to this function. When hardware echo cancellation is available, the software one is of course not activated.
 * @param {boolean} enabled - Define whether the feature is enabled or not.
 */
               Linphone.prototype.enableEchoCancellation = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableEchoCancellation", [enabled]);
               };
               
/**
 * Sets the default policy for video. This policy defines whether:
 *
 * - video shall be initiated by default for outgoing calls
 * - video shall be accepter by default for incoming calls
 * @param {boolean} automatically_initiate - Enable video automatically initiated or not.
 * @param {boolean} automatically_accept - Enable video automatically accepted or not.
 */
               Linphone.prototype.setVideoPolicy = function(automatically_initiate, automatically_accept, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoPolicy", [automatically_initiate, automatically_accept]);
               };
               
/**
 * Controls video preview enablement.
 *
 * Video preview refers to the action of displaying the local webcam image to the user while not in call.
 * @param {boolean} enabled - Enable video preview or not.
 */
               Linphone.prototype.enableVideoPreview = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableVideoPreview", [enabled]);
               };
               
/**
 * Enables or disable self view during calls.
 *
 * Self-view refers to having local webcam image inserted in corner of the video window during calls. This function works at any time, including during calls.
 * @param {boolean} enabled - Enable self view or not.
 */
               Linphone.prototype.enableSelfView = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableSelfView", [enabled]);
               };
               
/**
 * Sets the active video device.
 * @param {string} video_device - The name of the video device.
 */
               Linphone.prototype.setVideoDevice = function(video_device, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoDevice", [video_device]);
               };
               
/**
 * Tells the core the device current orientation. This can be used by capture filters on mobile devices to select between portrait/landscape mode and to produce properly oriented images. The exact meaning of the value in rotation if left to each device specific implementations.
 * @param {int} device_rotation - IOS supported values are 0 for UIInterfaceOrientationPortrait and 270 for UIInterfaceOrientationLandscapeRight.
 */
               Linphone.prototype.setDeviceRotation = function(device_rotation, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setDeviceRotation", [device_rotation]);
               };
               
/**
 * Plays a dtmf sound to the local user.
 * @param {string} play_dtmf_key - DTMF to play ['0'..'16'] | '#' | '#'.
 * @param {int} duration_in_ms - duration in ms, -1 means play until next further call to Linphone.stopDtmf().
 */
               Linphone.prototype.playDtmf = function(play_dtmf_key, duration_in_ms, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "playDtmf", [play_dtmf_key, duration_in_ms]);
               };
               
/**
 * Stops playing a dtmf started by Linphone.playDtmf();
 */
               Linphone.prototype.stopDtmf = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "stopDtmf", []);
               };
               
/**
 * Sets the maximum transmission unit size in bytes. This information is useful for sending RTP packets. Default value is 1500.
 * @param {int} mtu - MTU to be used.
 */
               Linphone.prototype.setMtu = function(mtu, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setMtu", [mtu]);
               };
               
/**
 * Whenever the liblinphone is playing a ring to advertise an incoming call or ringback of an outgoing call, this function stops the ringing. Typical use is to stop ringing when the user requests to ignore the call.
 */
               Linphone.prototype.stopRinging = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "stopRinging", []);
               };
               
/**
 * Enable RTCP feedback (also known as RTP/AVPF profile). Setting AVPFDefault is equivalent to AVPFDisabled. This setting can be overriden per proxy config with setting AVPF mode. The value set here is used for calls placed or received out of any proxy configured, or if the proxy config is configured with AVPFDefault.
 * @param {string} avpf_mode - The AVPF mode to be used. OPTIONS: AVPFDefault, AVPFDisabled, AVPFEnabled.
 */
               Linphone.prototype.setAvpfMode = function(avpf_mode, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAvpfMode", [avpf_mode]);
               };
               
/**
 * Set the avpf report interval in seconds.
 * @param {int} avpf_rr_interval - Interval in seconds.
 */
               Linphone.prototype.setAvpfRRInterval = function(avpf_rr_interval, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAvpfRRInterval", [avpf_rr_interval]);
               };
               
/**
 * Sets maximum available download bandwidth
 * This is IP bandwidth, in kbit/s.
 * This information is used signaled to other parties during
 * calls (within SDP messages) so that the remote end can have
 * sufficient knowledge to properly configure its audio & video
 * codec output bitrate to not overflow available bandwidth.
 * @param {int} download_bandwidth - The bandwidth in kbits/s, 0 for infinite.
 */
               Linphone.prototype.setDownloadBandwidth = function(download_bandwidth, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setDownloadBandwidth", [download_bandwidth]);
               };
               
/**
 * Sets maximum available upload bandwidth
 * This is IP bandwidth, in kbit/s.
 * This information is used by liblinphone together with remote
 * side available bandwidth signaled in SDP messages to properly
 * configure audio & video codec's output bitrate.
 * @param {int} upload_bandwidth - The bandwidth in kbits/s, 0 for infinite
 */
               Linphone.prototype.setUploadBandwidth = function(upload_bandwidth, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setUploadBandwidth", [upload_bandwidth]);
               };
               
/**
 * Enable adaptive rate control.
 *
 * Adaptive rate control consists in using RTCP feedback provided information to dynamically
 * control the output bitrate of the audio and video encoders, so that we can adapt to the network conditions and
 * available bandwidth. Control of the audio encoder is done in case of audio-only call, and control of the video encoder is done for audio & video calls.
 * Adaptive rate control feature is enabled by default.
 * @param {boolean} enabled - Define whether the feature is enabled or not.
 */
               Linphone.prototype.enableAdaptiveRateControl = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableAdaptiveRateControl", [enabled]);
               };
               
/**
 * Sets adaptive rate algorithm. It will be used for each new calls starting from
 * now. Calls already started will not be updated.
 * @param {string} apdative_rate_algorithm - The apdative rate algorithm. OPTIONS: Simple, Stateful.
 */
               Linphone.prototype.setAdaptiveRateAlgorithm = function(apdative_rate_algorithm, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAdaptiveRateAlgorithm", [apdative_rate_algorithm]);
               };
               
/**
 * Set audio packetization time linphone expects to receive from peer.
 * A value of zero means that ptime is not specified.
 * @param {int} download_ptime - The download ptime.
 */
               Linphone.prototype.setDownloadPtime = function(download_ptime, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setDownloadPtime", [download_ptime]);
               };
               
/**
 * Set audio packetization time linphone will send (in absence of requirement from peer)
 * A value of 0 stands for the current codec default packetization time.
 * @param {int} upload_ptime - The upload ptime.
 */
               Linphone.prototype.setUploadPtime = function(upload_ptime, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setUploadPtime", [upload_ptime]);
               };
               
/**
 * Set the SIP transport timeout.
 * @param {int} sip_transport_timeout - The SIP transport timeout in milliseconds.
 */
               Linphone.prototype.setSipTransportTimeout = function(sip_transport_timeout, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setSipTransportTimeout", [sip_transport_timeout]);
               };
               
/**
 * Enable or disable DNS SRV resolution.
 * @param {boolean} enabled - TRUE to enable DNS SRV resolution, FALSE to disable it.
 */
               Linphone.prototype.enableDnsSrv = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableDnsSrv", [enabled]);
               };
               
/**
 * Returns the list of available audio codecs.
 */
               Linphone.prototype.getAudioCodecs = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getAudioCodecs", []);
               };
               
/**
 * Returns the list of available video codecs.
 */
               Linphone.prototype.getVideoCodecs = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getVideoCodecs", []);
               };
               
/**
 * Returns the list of available text codecs.
 */
               Linphone.prototype.getTextCodecs = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getTextCodecs", []);
               };
               
/**
 * Set an explicit bitrate (IP bitrate, not codec bitrate) for a given codec, in kbit/s.
 * @param {string} type - Payload mime type (I.E SPEEX, PCMU, VP8).
 * @param {int} rate - Rate.
 * @param {int} bitrate - The IP bitrate in kbit/s.
 */
               Linphone.prototype.setPayloadTypeBitrate = function(type, rate, bitrate, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPayloadTypeBitrate", [type, rate, bitrate]);
               };
               
/**
 * Enable or disable the use of the specified payload type.
 * @param {string} type - Payload mime type (I.E SPEEX, PCMU, VP8).
 * @param {int} rate - Rate.
 * @param {boolean} enabled - TRUE to enable the payload type, FALSE to disable it.
 */
               Linphone.prototype.enablePayloadType = function(type, rate, enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enablePayloadType", [type, rate, enabled]);
               };
               
/**
 * Get payload type from mime type and clock rate
 * This function searches in audio and video codecs for the given payload type name and clockrate.
 * @param {string} type - Payload mime type (I.E SPEEX, PCMU, VP8).
 * @param {int} rate - Rate can be -1 if want to ignore rate for searching.
 * @param {int} channels - number of channels, can be -1 if want to ignore channels for searching.
 */
               Linphone.prototype.findPayloadType = function(type, rate, channels, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "findPayloadType", [type, rate, channels]);
               };
               
/**
 * Force a number for a payload type. The LinphoneCore does payload type number assignment automatically. THis function is to be used mainly for tests, in order
 * to override the automatic assignment mechanism.
 * @param {string} type - Payload mime type (I.E SPEEX, PCMU, VP8).
 * @param {int} rate - Rate can be -1 if want to ignore rate for searching.
 * @param {int} number - Payload number.
 */
               Linphone.prototype.setPayloadTypeNumber = function(type, rate, number, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPayloadTypeNumber", [type, rate, number]);
               };
               
/**
 * Enable or disable the audio adaptive jitter compensation.
 * @param {boolean} enabled - TRUE to enable the audio adaptive jitter compensation, FALSE to disable it.
 */
               Linphone.prototype.enableAudioAdaptiveJittcomp = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableAudioAdaptiveJittcomp", [enabled]);
               };
               
/**
 * Sets the nominal audio jitter buffer size in milliseconds.
 * The value takes effect immediately for all running and pending calls, if any.
 * A value of 0 disables the jitter buffer.
 * @param {int} audio_jittcomp_millisecond - The audio JITTCOMP in millisecond.
 */
               Linphone.prototype.setAudioJittcomp = function(audio_jittcomp_millisecond, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAudioJittcomp", [audio_jittcomp_millisecond]);
               };
               
/**
 * Enable or disable the video adaptive jitter compensation.
 * @param {boolean} enabled - TRUE to enable the video adaptive jitter compensation, FALSE to disable it.
 */
               Linphone.prototype.enableVideoAdaptiveJittcomp = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableVideoAdaptiveJittcomp", [enabled]);
               };
               
/**
 * Sets the nominal video jitter buffer size in milliseconds.
 * The value takes effect immediately for all running and pending calls, if any.
 * A value of 0 disables the jitter buffer.
 * @param {int} video_jittcomp_millisecond - Video JITTCOMP in millisecond.
 */
               Linphone.prototype.setVideoJittcomp = function(video_jittcomp_millisecond, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoJittcomp", [video_jittcomp_millisecond]);
               };
               
/**
 * Update detection of sound devices.
 *
 * Use this function when the application is notified of USB plug events, so that
 * list of available hardwares for sound playback and capture is updated.
 */
               Linphone.prototype.reloadSoundDevices = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "reloadSoundDevices", []);
               };
               
/**
 * Specify a ring back tone to be played to far end during incoming calls.
 * @param {string} remote_ringback_tone - The path to the ring back tone to be played.
 */
               Linphone.prototype.setRemoteRingbackTone = function(remote_ringback_tone, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRemoteRingbackTone", [remote_ringback_tone]);
               };
               
/**
 * Enable or disable the ring play during an incoming early media call.
 * @param {boolean} enabled - A boolean value telling whether to enable ringing during an incoming early media call.
 */
               Linphone.prototype.setRingDuringIncomingEarlyMedia = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRingDuringIncomingEarlyMedia", [enabled]);
               };
               
/**
 * Enables or disable echo limiter.
 * @param {boolean} enabled - TRUE to enable echo limiter, FALSE to disable it.
 */
               Linphone.prototype.enableEchoLimiter = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableEchoLimiter", [enabled]);
               };
               
/**
 * Enable or disable video capture.
 *
 * This function does not have any effect during calls. It just indicates the #LinphoneCore to
 * initiate future calls with video capture or not.
 * @param {boolean} enabled - TRUE to enable video capture, FALSE to disable it.
 */
               Linphone.prototype.enableVideoCapture = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableVideoCapture", [enabled]);
               };
               
/**
 * Enable or disable video display.
 *
 * This function does not have any effect during calls. It just indicates the #LinphoneCore to
 * initiate future calls with video display or not.
 * @param {boolean} enabled - TRUE to enable video display, FALSE to disable it.
 */
               Linphone.prototype.enableVideoDisplay = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableVideoDisplay", [enabled]);
               };
               
/**
 * Enable or disable video source reuse when switching from preview to actual video call.
 *
 * This source reuse is useful when you always display the preview, even before calls are initiated.
 * By keeping the video source for the transition to a real video call, you will smooth out the
 * source close/reopen cycle.
 *
 * This function does not have any effect durfing calls. It just indicates the #LinphoneCore to
 * initiate future calls with video source reuse or not.
 * Also, at the end of a video call, the source will be closed whatsoever for now.
 * @param {boolean} enabled - TRUE to enable video source reuse. FALSE to disable it for subsequent calls.
 */
               Linphone.prototype.enableVideoSourceReuse = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableVideoSourceReuse", [enabled]);
               };
               
/**
 * Sets the preferred video size.
 *
 * This applies only to the stream that is captured and sent to the remote party,
 * since we accept all standard video size on the receive path.
 * @param {int} preferred_video_size_width - Prefered video size width
 * @param {int} preferred_video_size_height - Prefered video size height
 */
               Linphone.prototype.setPreferredVideoSize = function(preferred_video_size_width, preferred_video_size_height, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPreferredVideoSize", [preferred_video_size_width, preferred_video_size_height]);
               };
               
/**
 * Sets the video size for the captured (preview) video.
 * This method is for advanced usage where a video capture must be set independently of the size of the stream actually sent through the call.
 * This allows for example to have the preview window with HD resolution even if due to bandwidth constraint the sent video size is small.
 * Using this feature increases the CPU consumption, since a rescaling will be done internally.
 * @param {int} preview_video_size_width - Preview video size width
 * @param {int} preview_video_size_height - Preview video size height
 */
               Linphone.prototype.setPreviewVideoSize = function(preview_video_size_width, preview_video_size_height, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPreviewVideoSize", [preview_video_size_width, preview_video_size_height]);
               };
               
/**
 * Sets the preview video size by its name. See Linphone.setPreviewVideoSize() for more information about this feature.
 *
 * Video resolution names are: qcif, svga, cif, vga, 4cif, svga ...
 * @param {string} preview_video_size_name - The name of preview video size.
 */
               Linphone.prototype.setPreviewVideoSizeByName = function(preview_video_size_name, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPreviewVideoSizeByName", [preview_video_size_name]);
               };
               
/**
 * Sets the preferred video size by its name.
 *
 * This is identical to Linphone.setPreferredVideoSize() except
 * that it takes the name of the video resolution as input.
 * Video resolution names are: qcif, svga, cif, vga, 4cif, svga ...
 * @param {string} preferred_video_size_name - The name of preferred video size.
 */
               Linphone.prototype.setPreferredVideoSizeByName = function(preferred_video_size_name, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPreferredVideoSizeByName", [preferred_video_size_name]);
               };
               
/**
 * Set the preferred frame rate for video.
 * Based on the available bandwidth constraints and network conditions, the video encoder
 * remains free to lower the framerate. There is no warranty that the preferred frame rate be the actual framerate.
 * used during a call. Default value is 0, which means "use encoder's default fps value".
 * @param {float} preferred_framerate_fps - The target frame rate in number of frames per seconds.
 */
               Linphone.prototype.setPreferredFramerate = function(preferred_framerate_fps, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPreferredFramerate", [preferred_framerate_fps]);
               };
               
/**
 * Update detection of camera devices.
 *
 * Use this function when the application is notified of USB plug events, so that
 * list of available hardwares for video capture is updated.
 */
               Linphone.prototype.reloadVideoDevices = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "reloadVideoDevices", []);
               };
               
/**
 * Set the path to the image file to stream when "Static picture" is set as the video device.
 * @param {string} static_picture_path - The path to the image file to use.
 */
               Linphone.prototype.setStaticPicture = function(static_picture_path, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setStaticPicture", [static_picture_path]);
               };
               
/**
 * Set the frame rate for static picture.
 * @param {float} static_picture_fps - The new frame rate to use for static picture.
 */
               Linphone.prototype.setStaticPictureFps = function(static_picture_fps, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setStaticPictureFps", [static_picture_fps]);
               };
               
/**
 * Tells the core to use a separate window for local camera preview video, instead of
 * inserting local view within the remote video window.
 * @param {boolean} enabled - TRUE to use a separate window, FALSE to insert the preview in the remote video window.
 */
               Linphone.prototype.usePreviewWindow = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "usePreviewWindow", [enabled]);
               };
               
/**
 * Ask the core to stream audio from and to files, instead of using the soundcard.
 * @param {boolean} enabled - yesno A boolean value asking to stream audio from and to files or not.
 */
               Linphone.prototype.setUseFiles = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setUseFiles", [enabled]);
               };
               
/**
 * Sets a wav file to be played when putting somebody on hold,
 * or when files are used instead of soundcards (see linphone_core_set_use_files()).
 *
 * The file must be a 16 bit linear wav file.
 * @param {string} play_file - The path to the file to be played when putting somebody on hold.
 */
               Linphone.prototype.setPlayFile = function(play_file, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setPlayFile", [play_file]);
               };
               
/**
 * Sets a wav file where incoming stream is to be recorded,
 * when files are used instead of soundcards (see linphone_core_set_use_files()).
 *
 * This feature is different from call recording (linphone_call_params_set_record_file())
 * The file will be a 16 bit linear wav file.
 * @param {string} record_file - The path to the file where incoming stream is to be recorded.
 */
               Linphone.prototype.setRecordFile = function(record_file, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setRecordFile", [record_file]);
               };
               
/**
 * Choose the media encryption policy to be used for RTP packets.
 * @param {string} media_encryption - The media encryption policy to be used. OPTIONS: MediaEncryptionNone, MediaEncryptionSRTP, MediaEncryptionZRTP, MediaEncryptionDTLS.
 */
               Linphone.prototype.setMediaEncryption = function(media_encryption, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setMediaEncryption", [media_encryption]);
               };
               
/**
 * Define behaviour when encryption parameters negociation fails on outgoing call.
 * @param {boolean} enabled - If set to TRUE call will fail; if set to FALSE will resend an INVITE with encryption disabled.
 */
               Linphone.prototype.setMediaEncryptionMandatory = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setMediaEncryptionMandatory", [enabled]);
               };
               
/**
 * Use to set multicast address to be used for audio stream.
 * @param {string} audio_multicast_address - An ipv4/6 multicast address.
 */
               Linphone.prototype.setAudioMulticastAddress = function(audio_multicast_address, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAudioMulticastAddress", [audio_multicast_address]);
               };
               
/**
 * Use to set multicast address to be used for video stream.
 * @param {string} video_multicast_address - An ipv4/6 multicast address.
 */
               Linphone.prototype.setVideoMulticastAddress = function(video_multicast_address, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoMulticastAddress", [video_multicast_address]);
               };
               
/**
 * Use to set multicast ttl to be used for audio stream.
 * @param {int} audio_multicast_ttl - Value or -1 if not used. [0..255] default value is 1
 */
               Linphone.prototype.setAudioMulticastTtl = function(audio_multicast_ttl, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setAudioMulticastTtl", [audio_multicast_ttl]);
               };
               
/**
 * Use to set multicast ttl to be used for video stream.
 * @param {int} video_multicast_ttl - Value or -1 if not used. [0..255] default value is 1
 */
               Linphone.prototype.setVideoMulticastTtl = function(video_multicast_ttl, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoMulticastTtl", [video_multicast_ttl]);
               };
               
/**
 * Use to enable multicast rtp for audio stream.
 * * If enabled, outgoing calls put a multicast address from #linphone_core_get_video_multicast_addr into audio cline. In case of outgoing call audio stream is sent to this multicast address.
 *
 * For incoming calls behavior is unchanged.
 * @param {boolean} enabled - If yes, subsequent calls will propose multicast ip set by Linphone.setAudioMulticastAddress().
 */
               Linphone.prototype.enableAudioMulticast = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableAudioMulticast", [enabled]);
               };
               
/**
 * Use to enable multicast rtp for video stream.
 * If enabled, outgoing calls put a multicast address from #linphone_core_get_video_multicast_addr into video cline. In case of outgoing call video stream is sent to this  multicast address.
 *
 * For incoming calls behavior is unchanged.
 * @param {boolean} enabled - If yes, subsequent calls will propose multicast ip set by Linphone.setVideoMulticastAddress().
 */
               Linphone.prototype.enableVideoMulticast = function(enabled, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableVideoMulticast", [enabled]);
               };
               
/**
 * Set the name of the mediastreamer2 filter to be used for rendering video. This is for advanced users of the library, mainly to workaround hardware/driver bugs.
 * @param {string} video_display_filter_name - The name of the mediastreamer2 filter to be used for rendering video.
 */
               Linphone.prototype.setVideoDisplayFilter = function(video_display_filter_name, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setVideoDisplayFilter", [video_display_filter_name]);
               };
               
/**
 * Get audio conference information.
 */
               Linphone.prototype.getAudioConferenceInformation = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getAudioConferenceInformation", []);
               };
               
/**
 * Returns the current list of calls.
 */
               Linphone.prototype.getAllCalls = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getAllCalls", []);
               };
               
/**
 * Add a participant to the conference. If no conference is going on
 * a new internal conference context is created and the participant is
 * added to it.
 * @param {string} callId - The identity of a call with the participant to add
 */
               Linphone.prototype.addToConference = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addToConference", [callId]);
               };
               
/**
 * Remove a call from the conference.
 *
 * After removing the remote participant belonging to the supplied call, the call becomes a normal call in paused state.
 * If one single remote participant is left alone together with the local user in the conference after the removal, then the conference is
 * automatically transformed into a simple call in StreamsRunning state.
 * The conference's resources are then automatically destroyed.
 *
 * In other words, unless linphone_core_leave_conference() is explicitly called, the last remote participant of a conference is automatically
 * put in a simple call in running state.
 * @param {string} callId - The identity of a call that has been previously merged into the conference.
 */
               Linphone.prototype.removeFromConference = function(callId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "removeFromConference", [callId]);
               };
               
/**
 * Make the local participant leave the running conference
 */
               Linphone.prototype.leaveConference = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "leaveConference", []);
               };
               
/**
 * Join the local participant to the running conference
 */
               Linphone.prototype.enterConference = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enterConference", []);
               };
               
/**
 * Add all current calls into the conference. If no conference is running
 * a new internal conference context is created and all current calls
 * are added to it.
 */
               Linphone.prototype.addAllToConference = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addAllToConference", []);
               };
               
/**
 * Start recording the running conference
 * @param {string} path - Path to the file where the recording will be written
 */
               Linphone.prototype.startConferenceRecording = function(path, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "startConferenceRecording", [path]);
               };
               
/**
 * Stop recording the running conference
 */
               Linphone.prototype.stopConferenceRecording = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "stopConferenceRecording", []);
               };
               
               
               // Obtaining information about a running call: sound volumes, quality indicators
               
/**
 * Returns an list of chat rooms
 */
               Linphone.prototype.getAllChatRooms = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getAllChatRooms", []);
               };
               
/**
 * Sets the database filename where chat messages will be stored. If the file does not exist, it will be created.
 * @param {string} path - Filesystem path.
 */
               Linphone.prototype.setChatDatabasePath = function(path, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setChatDatabasePath", [path]);
               };
               
/**
 * Get a chat room whose peer is the supplied address. If it does not exist yet, it will be created.
 * No reference is transfered to the application. The LinphoneCore keeps a reference on the chat room.
 * @param {string} username - The username of distination address for messages.
 * @param {string} domain - The domain of distination address for messages.
 */
               Linphone.prototype.getChatRoomWithUsername = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getChatRoomWithUsername", [username, domain]);
               };
               
/**
 * Get a chat room for messaging from a sip uri like sip:joe@sip.linphone.org. If it does not exist yet, it will be created.
 * No reference is transfered to the application. The LinphoneCore keeps a reference on the chat room.
 * @param {string} contactUri - The destination address for messages.
 */
               Linphone.prototype.getChatRoomFromUri = function(contactUri, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getChatRoomFromUri", [contactUri]);
               };
               
/**
 * Removes a chatroom including all message history.
 * @param {string} contactUri - The destination address for messages.
 */
               Linphone.prototype.deleteChatRoom = function(contactUri, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "deleteChatRoom", [contactUri]);
               };
               
/**
 * Inconditionnaly disable incoming chat messages.
 * @param {string} reason - The deny reason. OPTIONS: ReasonNone, ReasonNoResponse, ReasonDeclined, ReasonNotFound, ReasonNotAnswered, ReasonBusy, ReasonIOError, ReasonDoNotDisturb, ReasonUnauthorized, ReasonNotAcceptable, ReasonNoMatch, ReasonMovedPermanently, ReasonGone, ReasonTemporarilyUnavailable, ReasonAddressIncomplete, ReasonNotImplemented.
 */
               Linphone.prototype.disableChat = function(reason, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "disableChat", [reason]);
               };
               
/**
 * Enable reception of incoming chat messages.
 * By default it is enabled but it can be disabled with Linphone.disableChat().
 */
               Linphone.prototype.enableChat = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "enableChat", []);
               };
               
/**
 * Start the upload of the file message to remote server.
 * @param {string} url - URL of the file to be uploaded.
 * @param {string} contactUri - The destination address for messages.
 */
               Linphone.prototype.uploadFileMessage = function(url, contactUri, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "uploadFileMessage", [url, contactUri]);
               };
               
/**
 * Start the download of the file referenced in a file message from remote server.
 * @param {string} contactUri - The destination address for messages.
 * @param {int} messageStoreId - The identity of message to be downloaded.
 */
               Linphone.prototype.startFileDownload = function(contactUri, messageStoreId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "startFileDownload", [contactUri, messageStoreId]);
               };
               
/**
 * Cancel an ongoing file transfer attached to this message.(download)
 * @param {string} contactUri - The destination address for messages.
 * @param {int} messageStoreId - The identity of message to be canceled.
 */
               Linphone.prototype.cancelFileDownload = function(contactUri, messageStoreId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "cancelFileDownload", [contactUri, messageStoreId]);
               };
               
/**
 * Cancel an ongoing file transfer attached to this message.(upload)
 * @param {string} contactUri - The destination address for messages.
 */
               Linphone.prototype.cancelFileUpload = function(contactUri, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "cancelFileUpload", [contactUri]);
               };
               
/**
 * Send a message to peer member of a chat room.
 * @param {string} contactUri - The destination address for messages.
 * @param {string} message - The message to be sent.
 */
               Linphone.prototype.sendMessageWithChatRoom = function(contactUri, message, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "sendMessageWithChatRoom", [contactUri, message]);
               };
               
/**
 * Mark all messages of the conversation as read
 * @param {string} contactUri - The destination address for messages.
 */
               Linphone.prototype.markAsRead = function(contactUri, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "markAsRead", [contactUri]);
               };
               
/**
 * Delete a message from the chat room history.
 * @param {string} contactUri - The destination address for messages.
 * @param {int} messageStoreId - The identity of message to be removed.
 */
               Linphone.prototype.deleteMessage = function(contactUri, messageStoreId, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "deleteMessage", [contactUri, messageStoreId]);
               };
               
/**
 * Delete all messages from the history
 * @param {string} contactUri - The destination address for messages.
 */
               Linphone.prototype.deleteHistory = function(contactUri, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "deleteHistory", [contactUri]);
               };
               
/**
 * Gets a number of most recent messages from chat room, sorted from oldest to most recent.
 * @param {string} contactUri - The destination address for messages.
 * @param {int} numberOfMessages - The number of messages to be got.
 */
               Linphone.prototype.getHistory = function(contactUri, numberOfMessages, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getHistory", [contactUri, numberOfMessages]);
               };
               
/**
 * Gets the partial list of messages in the given range, sorted from oldest to most recent.
 * @param {string} contactUri - The destination address for messages.
 * @param {int} min - The beginning of partial list.
 * @param {int} max - The ending of partial list.
 */
               Linphone.prototype.getHistoryRange = function(contactUri, min, max, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getHistoryRange", [contactUri, min, max]);
               };
               
/**
 * Notifies the destination of the chat message being composed that the user is typing a new message.
 * @param {string} contactUri - The destination address for messages.
 */
               Linphone.prototype.compose = function(contactUri, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "compose", [contactUri]);
               };
               
/**
 * Add custom headers to the message.
 * @param {string} contactUri - The destination address for messages.
 * @param {int} messageStoreId - The identity of message to be added with custom header.
 * @param {string} headerName - The name of the header name.
 * @param {string} headerValue - Header value.
 */
               Linphone.prototype.addCustomHeader = function(contactUri, messageStoreId, headerName, headerValue, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addCustomHeader", [contactUri, messageStoreId, headerName, headerValue]);
               };
               
/**
 * Retrieve a custom header value given its name.
 * @param {string} contactUri - The destination address for messages.
 * @param {int} messageStoreId - The identity of message to be retrieved.
 * @param {string} headerName - Header name searched.
 */
               Linphone.prototype.getCustomHeader = function(contactUri, messageStoreId, headerName, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getCustomHeader", [contactUri, messageStoreId, headerName]);
               };
               
               
               
               
               // Managing buddies and buddy list and presence
               
/**
 * Get my buddy information.
 */
               Linphone.prototype.getMyBuddy = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getMyBuddy", []);
               };
               
/**
 * Search a friend by its destination address.
 * @param {string} username - The username of destination address.
 * @param {string} domain - The domain of destination address.
 */
               Linphone.prototype.findFriendByUsername = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "findFriendByUsername", [username, domain]);
               };
               
/**
 * Search a friend by its destination address.
 * @param {string} username - The username of destination address.
 * @param {string} domain - The domain of destination address.
 */
               Linphone.prototype.getFriendList = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getFriendList", []);
               };
               
/**
 * Notify all friends that have subscribed
 * @param {string} activityType - The activity to set for notifying. OPTIONS: PresenceActivityOffline, PresenceActivityOnline, PresenceActivityAppointment, PresenceActivityAway, PresenceActivityBreakfast, PresenceActivityBusy, PresenceActivityDinner, PresenceActivityHoliday, PresenceActivityInTransit, PresenceActivityLookingForWork, PresenceActivityLunch, PresenceActivityMeal, PresenceActivityMeeting, PresenceActivityOnThePhone, PresenceActivityOther, PresenceActivityPerformance, PresenceActivityPermanentAbsence, PresenceActivityPlaying, PresenceActivityPresentation, PresenceActivityShopping, PresenceActivitySleeping, PresenceActivitySpectator, PresenceActivitySteering, PresenceActivityTravel, PresenceActivityTV, PresenceActivityUnknown, PresenceActivityVacation, PresenceActivityWorking, PresenceActivityWorship.
 * @param {string} description - An additional description of the activity (mainly useful for the 'other' activity). Set it to NULL to not add a description.
 */
               Linphone.prototype.notifyAllFriendList = function(activityType, description, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "notifyAllFriendList", [activityType, description]);
               };
               
/**
 * Add a friend to the current buddy list, if Linphone.acceptSubscriber() is called, a SIP SUBSCRIBE message is sent.
 * @param {string} username - The username of destination address to be added.
 * @param {string} domain - The domain of destination address to be added.
 */
               Linphone.prototype.addFriend = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addFriend", [username, domain]);
               };
               
/**
 * Removes a friend from the buddy list
 * @param {string} username - The username of destination address to be removed.
 * @param {string} domain - The domain of destination address to be removed.
 */
               Linphone.prototype.removeFriend = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "removeFriend", [username, domain]);
               };
               
/**
 * Configure incoming subscription policy for this friend.
 * @param {string} username - The username of destination address to be configured.
 * @param {string} domain - The domain of destination address to be configured.
 */
               Linphone.prototype.acceptSubscriber = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "acceptSubscriber", [username, domain]);
               };
               
/**
 * Black list a friend.
 * @param {string} username - The username of destination address to be configured.
 * @param {string} domain - The domain of destination address to be configured.
 */
               Linphone.prototype.rejectSubscriber = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "rejectSubscriber", [username, domain]);
               };
               
/**
 * Get the presence model of a friend
 * @param {string} username - The username of destination address to be searched.
 * @param {string} domain - The domain of destination address to be searched.
 */
               Linphone.prototype.findPresenceModelByUsername = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "findPresenceModelByUsername", [username, domain]);
               };
               
/**
 * Sets the basic status of a presence model.
 * @param {string} username - The username of destination address to be set.
 * @param {string} domain - The domain of destination address to be set.
 */
               Linphone.prototype.setBasicStatus = function(username, domain, basicstatus, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setBasicStatus", [username, domain, basicstatus]);
               };
               
/**
 * Sets the contact of a presence model.
 *
 * WARNING: This function will modify the basic status of the model according to the activity being set.
 * If you don't want the basic status to be modified automatically, you can use the combination of Linphone.setBasicStatus(),
 * Linphone.clearActivities() and Linphone.addActivity().
 * @param {string} username - The username of destination address to be set.
 * @param {string} domain - The domain of destination address to be set.
 * @param {string} contact - The contact string to set.
 */
               Linphone.prototype.setContact = function(username, domain, contact, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setContact", [username, domain, contact]);
               };
               
/**
 * Sets the activity of a presence model (limits to only one activity).
 *
 * WARNING: This function will modify the basic status of the model according to the activity being set.
 * If you don't want the basic status to be modified automatically, you can use the combination of Linphone.setBasicStatus(),
 * Linphone.clearActivities() and Linphone.addActivity().
 * @param {string} username - The username of destination address to be set.
 * @param {string} domain - The domain of destination address to be set.
 * @param {string} activityType - The activity type to set for the model. OPTIONS: PresenceActivityOffline, PresenceActivityOnline, PresenceActivityAppointment, PresenceActivityAway, PresenceActivityBreakfast, PresenceActivityBusy, PresenceActivityDinner, PresenceActivityHoliday, PresenceActivityInTransit, PresenceActivityLookingForWork, PresenceActivityLunch, PresenceActivityMeal, PresenceActivityMeeting, PresenceActivityOnThePhone, PresenceActivityOther, PresenceActivityPerformance, PresenceActivityPermanentAbsence, PresenceActivityPlaying, PresenceActivityPresentation, PresenceActivityShopping, PresenceActivitySleeping, PresenceActivitySpectator, PresenceActivitySteering, PresenceActivityTravel, PresenceActivityTV, PresenceActivityUnknown, PresenceActivityVacation, PresenceActivityWorking, PresenceActivityWorship.
 * @param {string} description - An additional description of the activity to set for the model. Can be NULL if no additional description is to be added.
 */
               Linphone.prototype.setActivity = function(username, domain, activitytype, description, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setActivity", [username, domain, activitytype, description]);
               };
               
/**
 * Gets the nth activity of a presence model.presence model of a friend
 * @param {string} username - The username of a presence model to get the activity from.
 * @param {string} domain - The domain of a presence model to get the activity from.
 * @param {int} index - The index of the activity to get (the first activity having the index 0).
 */
               Linphone.prototype.getNthActivity = function(username, domain, index, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNthActivity", [username, domain, index]);
               };
               
/**
 * Adds an activity to a presence model.
 * @param {string} username - The username of a presence model for which to add an activity.
 * @param {string} domain - The domain of a presence model for which to add an activity.
 * @param {string} activitytype - The activity type to add to the model. OPTIONS: PresenceActivityOffline, PresenceActivityOnline, PresenceActivityAppointment, PresenceActivityAway, PresenceActivityBreakfast, PresenceActivityBusy, PresenceActivityDinner, PresenceActivityHoliday, PresenceActivityInTransit, PresenceActivityLookingForWork, PresenceActivityLunch, PresenceActivityMeal, PresenceActivityMeeting, PresenceActivityOnThePhone, PresenceActivityOther, PresenceActivityPerformance, PresenceActivityPermanentAbsence, PresenceActivityPlaying, PresenceActivityPresentation, PresenceActivityShopping, PresenceActivitySleeping, PresenceActivitySpectator, PresenceActivitySteering, PresenceActivityTravel, PresenceActivityTV, PresenceActivityUnknown, PresenceActivityVacation, PresenceActivityWorking, PresenceActivityWorship.
 * @param {string} description - An additional description of the activity to add to the model. Can be NULL if no additional description is to be added.
 */
               Linphone.prototype.addActivity = function(username, domain, activitytype, description, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addActivity", [username, domain, activitytype, description]);
               };
               
/**
 * Clears the activities of a presence model.
 * @param {string} username - The username of a presence model for which to clear the activities.
 * @param {string} domain - The domain of a presence model for which to clear the activities.
 */
               Linphone.prototype.clearActivities = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearActivities", [username, domain]);
               };
               
/**
 * Gets the first note of a presence model (there is usually only one).
 * @param {string} username - The username of a presence model to get the note from.
 * @param {string} domain - The domain of a presence model to get the note from.
 * @param {string} lang - The language of the note to get. Can be NULL to get a note that has no language specified or to get the first note whatever language it is written into.
 */
               Linphone.prototype.getNote = function(username, domain, lang, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNote", [username, domain, lang]);
               };
               
/**
 * Adds a note to a presence model.
 * @param {string} username - The username of a presence model to add a note to.
 * @param {string} domain - The domain of a presence model to add a note to.
 * @param {string} notecontent - The note to be added to the presence model.
 * @param {string} lang - The language of the note to be added. Can be NULL if no language is to be specified for the note.
 */
               Linphone.prototype.addNoteContent = function(username, domain, notecontent, lang, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addNoteContent", [username, domain, notecontent, lang]);
               };
               
/**
 * Clears all the notes of a presence model.
 * @param {string} username - The username of a presence model for which to clear notes.
 * @param {string} domain - The domain of a presence model for which to clear notes.
 */
               Linphone.prototype.clearNotes = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearNotes", [username, domain]);
               };
               
/**
 * Gets the nth service of a presence model.
 * @param {string} username - The username of a presence model to get the service from.
 * @param {string} domain - The domain of a presence model to get the service from.
 * @param {int} index - The index of the service to get (the first service having the index 0).
 */
               Linphone.prototype.getNthService = function(username, domain, index, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNthService", [username, domain, index]);
               };
               
/**
 * Adds a service to a presence model.
 * @param {string} username - The username of a presence model for which to add a service.
 * @param {string} domain - The domain of a presence model for which to add a service.
 * @param {string} basicstatus - The basic status to set for the presence service object. OPTIONS: PresenceBasicStatusOpen, PresenceBasicStatusClosed.
 * @param {string} contact - The contact string to set.
 */
               Linphone.prototype.addService = function(username, domain, basicstatus, contact, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addService", [username, domain, basicstatus, contact]);
               };
               
/**
 * Clears the services of a presence model.
 * @param {string} username - The username of a presence model for which to clear the services.
 * @param {string} domain - The domain of a presence model for which to clear the services.
 */
               Linphone.prototype.clearServices = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearServices", [username, domain]);
               };
               
/**
 * Clears the services of a presence model.
 * @param {string} username - The username of a presence model to get the person from.
 * @param {string} domain - The domain of a presence model to get the person from.
 * @param {int} index - The index of the person to get (the first person having the index 0).
 */
               Linphone.prototype.getNthPerson = function(username, domain, index, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNthPerson", [username, domain, index]);
               };
               
/**
 * Adds a person to a presence model.
 * @param {string} username - The username of a presence model for which to add a person.
 * @param {string} domain - The domain of a presence model for which to add a person.
 */
               Linphone.prototype.addPerson = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addPerson", [username, domain]);
               };
               
/**
 * Clears the persons of a presence model.
 * @param {string} username - The username of a presence model for which to clear the persons.
 * @param {string} domain - The domain of a presence model for which to clear the persons.
 */
               Linphone.prototype.clearPerson = function(username, domain, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearPerson", [username, domain]);
               };
               
/**
 * Sets the id of a presence service.
 * @param {string} username - The username of a presence service for which to set the id.
 * @param {string} domain - The domain of a presence service for which to set the id.
 * @param {int} index - The index of the service to get (the first service having the index 0).
 * @param {string} id - The id string to set. Can be NULL to generate it automatically.
 */
               Linphone.prototype.setIdForLinphonePresenceService = function(username, domain, index, id, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setIdForLinphonePresenceService", [username, domain, index, id]);
               };
               
/**
 * Sets the basic status of a presence service.
 * @param {string} username - The username of a presence service for which to set the basic status.
 * @param {string} domain - The domain of a presence service for which to set the basic status.
 * @param {int} index - The index of the service to get (the first service having the index 0).
 * @param {string} basicstatus - The basic status to set for the presence service object. OPTIONS: PresenceBasicStatusOpen, PresenceBasicStatusClosed.
 */
               Linphone.prototype.setBasicStatusForLinphonePresenceService = function(username, domain, index, basicstatus, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setBasicStatusForLinphonePresenceService", [username, domain, index, basicstatus]);
               };
               
/**
 * Sets the contact of a presence service.
 * @param {string} username - The username of a presence service for which to set the contact.
 * @param {string} domain - The domain of a presence service for which to set the contact.
 * @param {int} index - The index of the service to get (the first service having the index 0).
 * @param {string} contact - The contact string to set.
 */
               Linphone.prototype.setContactForLinphonePresenceService = function(username, domain, index, contact, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setContactForLinphonePresenceService", [username, domain, index, contact]);
               };
               
/**
 * Gets the nth note of a presence service.
 * @param {string} username - The username of a presence service to get the note from.
 * @param {string} domain - The domain of a presence service to get the note from.
 * @param {int} serviceindex - The index of the service to get (the first service having the index 0).
 * @param {int} noteindex - The index of the note to get (the first note having the index 0).
 */
               Linphone.prototype.getNthNoteFromService = function(username, domain, serviceindex, noteindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNthNoteFromService", [username, domain, serviceindex, noteindex]);
               };
               
/**
 * Adds a note to a presence service.
 * @param {string} username - The username of a presence service for which to add a note.
 * @param {string} domain - The domain of a presence service for which to add a note.
 * @param {int} serviceindex - The index of the service to get (the first service having the index 0).
 * @param {string} content - The content of the note to be added.
 * @param {string} language - The language of the note to be added. Can be NULL if no language is to be specified for the note.
 */
               Linphone.prototype.addNoteForLinphonePresenceService = function(username, domain, serviceindex, content, language, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addNoteForLinphonePresenceService", [username, domain, serviceindex, content, language]);
               };
               
/**
 * Clears the notes of a presence service.
 * @param {string} username - The username of a presence service for which to clear the notes.
 * @param {string} domain - The domain of a presence service for which to clear the notes.
 * @param {int} serviceindex - The index of the service to clear the notes (the first service having the index 0).
 */
               Linphone.prototype.clearNotesForLinphonePresenceService = function(username, domain, serviceindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearNotesForLinphonePresenceService", [username, domain, serviceindex]);
               };
               
/**
 * Sets the id of a presence person.
 * @param {string} username - The username of a presence service for which to set the id.
 * @param {string} domain - The domain of a presence service for which to set the id.
 * @param {int} personindex - The index of the presence person to set the id. (the first person having the index 0).
 * @param {string} id - The id string to set. Can be NULL to generate it automatically.
 */
               Linphone.prototype.setIdForLinphonePresencePerson = function(username, domain, personindex, id, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "setIdForLinphonePresencePerson", [username, domain, personindex, id]);
               };
               
/**
 * Gets the nth activity of a presence person.
 * @param {string} username - The username of a presence service to get the activity from.
 * @param {string} domain - The domain of a presence service to get the activity from.
 * @param {int} personindex - The index of the presence person to get the activity from. (the first person having the index 0).
 * @param {int} activityindex - The index of the activity to get (the first activity having the index 0).
 */
               Linphone.prototype.getNthActivityForLinphonePresencePerson = function(username, domain, personindex, activityindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNthActivityForLinphonePresencePerson", [username, domain, personindex, activityindex]);
               };
               
/**
 * Adds an activity to a presence person.
 * @param {string} username - The username of a presence service for which to add an activity.
 * @param {string} domain - The domain of a presence service for which to add an activity.
 * @param {int} personindex - The index of the presence person for which to add an activity. (the first person having the index 0).
 * @param {string} activitytype - The presence activity type to add to the person.
 * @param {string} description - An additional description of the activity to add to the person. Can be NULL if no additional description is to be added.
 */
               Linphone.prototype.addActivityForLinphonePresencePerson = function(username, domain, personindex, activitytype, description, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addActivityForLinphonePresencePerson", [username, domain, personindex, activitytype, description]);
               };
               
/**
 * Clears the activities of a presence person.
 * @param {string} username - The username of a presence service for which to clear the activities.
 * @param {string} domain - The domain of a presence service for which to clear the activities.
 * @param {int} personindex - The index of the presence person for which to clear the activities. (the first person having the index 0).
 */
               Linphone.prototype.clearActivitiesForLinphonePresencePerson = function(username, domain, personindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearActivitiesForLinphonePresencePerson", [username, domain, personindex]);
               };
               
/**
 * Gets the nth note of a presence person.
 * @param {string} username - The username of a presence service to get the note from.
 * @param {string} domain - The domain of a presence service to get the note from.
 * @param {int} personindex - The index of the presence person to get the note from. (the first person having the index 0).
 * @param {int} noteindex - The index of the note to get (the first note having the index 0).
 */
               Linphone.prototype.getNthNoteFromPerson = function(username, domain, personindex, noteindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNthNoteFromPerson", [username, domain, personindex, noteindex]);
               };
               
/**
 * Adds a note to a presence person.
 * @param {string} username - The username of a presence service for which to add a note.
 * @param {string} domain - The domain of a presence service for which to add a note.
 * @param {int} personindex - The index of the presence person for which to add a note. (the first person having the index 0).
 * @param {string} content - The content of the note to add to the person.
 * @param {string} language - The language of the note to add to the person. Can be NULL if no language is to be specified for the note.
 */
               Linphone.prototype.addNoteForLinphonePresencePerson = function(username, domain, personindex, content, language, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addNoteForLinphonePresencePerson", [username, domain, personindex, content, language]);
               };
               
/**
 * Clears the notes of a presence person.
 * @param {string} username - The username of a presence model for which to clear the notes.
 * @param {string} domain - The domain of a presence model for which to clear the notes.
 * @param {int} personindex - The index of the presence person for which to clear the notes. (the first person having the index 0).
 */
               Linphone.prototype.clearNotesForLinphonePresencePerson = function(username, domain, personindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearNotesForLinphonePresencePerson", [username, domain, personindex]);
               };
               
/**
 * Gets the nth activities note of a presence person.
 * @param {string} username - The username of a presence model to get the activities note from.
 * @param {string} domain - The domain of a presence model to get the activities note from.
 * @param {int} personindex - The index of the presence person to get the activities note from. (the first person having the index 0).
 * @param {int} noteindex - The index of the activities note to get (the first note having the index 0).
 */
               Linphone.prototype.getNthActivitiesNote = function(username, domain, personindex, noteindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "getNthActivitiesNote", [username, domain, personindex, noteindex]);
               };
               
/**
 * Adds an activities note to a presence person.
 * @param {string} username - The username of a presence person for which to add an activities note.
 * @param {string} domain - The domain of a presence person for which to add an activities note.
 * @param {int} personindex - The index of the presence person to add to the person. (the first person having the index 0).
 * @param {string} content - The content of the note to be added.
 * @param {string} language - The language of the note to be added. Can be NULL if no language is to be specified for the note.
 */
               Linphone.prototype.addActivitiesNote = function(username, domain, personindex, content, language, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "addActivitiesNote", [username, domain, personindex, content, language]);
               };
               
/**
 * Clears the activities notes of a presence person.
 * @param {string} username - The username of a presence person for which to clear the activities notes.
 * @param {string} domain - The domain of a presence person for which to clear the activities notes.
 * @param {int} personindex - The index of the presence person for which to clear the activities notes. (the first person having the index 0).
 */
               Linphone.prototype.clearActivitiesNotes = function(username, domain, personindex, success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "clearActivitiesNotes", [username, domain, personindex]);
               };
               
               Linphone.prototype.startListener = function(success, fail) {
               cordova.exec(success, fail, "LinphonePlugin", "startListener", []);
               };
               
               
               var linphone = new Linphone();
               module.exports = linphone;

});
