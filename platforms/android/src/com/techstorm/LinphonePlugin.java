package com.techstorm;

import android.content.Context;

import com.techstorm.objects.TTPresenceActivity;
import com.techstorm.objects.TTPresenceNote;
import com.techstorm.objects.TTPresencePerson;
import com.techstorm.objects.TTPresenceService;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.linphone.LinphoneManager;
import org.linphone.core.CallDirection;
import org.linphone.core.LinphoneAddress;
import org.linphone.core.LinphoneBuffer;
import org.linphone.core.LinphoneCall;
import org.linphone.core.LinphoneCallLog;
import org.linphone.core.LinphoneCallStats;
import org.linphone.core.LinphoneChatMessage;
import org.linphone.core.LinphoneChatRoom;
import org.linphone.core.LinphoneConference;
import org.linphone.core.LinphoneContent;
import org.linphone.core.LinphoneCore;
import org.linphone.core.LinphoneCoreException;
import org.linphone.core.LinphoneCoreListener;
import org.linphone.core.LinphoneEvent;
import org.linphone.core.LinphoneFriend;
import org.linphone.core.LinphoneFriendList;
import org.linphone.core.LinphoneInfoMessage;
import org.linphone.core.LinphoneProxyConfig;
import org.linphone.core.PayloadType;
import org.linphone.core.PresenceActivity;
import org.linphone.core.PresenceActivityType;
import org.linphone.core.PresenceBasicStatus;
import org.linphone.core.PresenceModel;
import org.linphone.core.PresenceNote;
import org.linphone.core.PresencePerson;
import org.linphone.core.PresenceService;
import org.linphone.core.PublishState;
import org.linphone.core.Reason;
import org.linphone.core.SubscriptionState;
import org.linphone.core.VideoSize;

import java.nio.ByteBuffer;
import java.util.List;

/**
 * Created by apple on 3/28/16.
 */
public class LinphonePlugin extends CordovaPlugin {

    private final static String NO_SUPPORT_ON_ANDROID = "No supported on Android";
    private final static String NO_CURRENT_CALL = "No current call.";
    private final static String WRONG_ARGUMENTS = "Wrong arguments.";
    private final static String CALL_ID_NOT_FOUND = "Call ID not found.";
    private final static String CALL_STATS_NOT_FOUND = "Call stats not found.";
    private final static String MESSAGE_STORE_ID_NOT_FOUND = "Message store ID not found.";
    private final static String CHAT_ROOM_NOT_FOUND = "Chat room not found.";
    private final static String FRIEND_NOT_FOUND = "Friend not found.";
    private final static String PRESENCE_ACTIVITY_NOT_FOUND = "Presence activity not found.";
    private final static String PRESENCE_MODEL_NOT_FOUND = "Presence model not found.";
    private final static String PRESENCE_NOTE_NOT_FOUND = "Presence note not found.";
    private final static String PRESENCE_SERVICE_NOT_FOUND = "Presence service not found.";
    private final static String PRESENCE_PERSON_NOT_FOUND = "Presence person not found.";
    private final static String FRIEND_ALREADY_ADDED = "Friend already added.";



    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext command) throws JSONException {
        final Context context = this.cordova.getActivity();
        this.cordova.getActivity().runOnUiThread(new Runnable() {

            @Override
            public void run() {
                if (action.equals("initLinphoneCore")) {
                    try {
                        LinphoneHelper.addLinphoneServiceListener(new LinphoneHelper.LinphoneServiceListener() {
                            @Override
                            public void onServiceReady() {
                                // nothing
                            }
                        });
                        LinphoneHelper.initLinphoneCore(context);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("destroyLinphoneCore")) {
                        LinphoneHelper.destroyLinphoneCore();
                }
                else if (action.equals("registerSIP")) {

                    try {
                        String username = args.get(0).toString();
                        String displayName = args.get(1).toString();
                        String domain = args.get(2).toString();
                        String password = args.get(3).toString();
                        String transport = args.get(4).toString();

                        try {
                            LinphoneHelper.registerSIP(username, displayName, domain, password, transport);
                        } catch (RuntimeException e) {
                            command.error(e.getMessage());
                            return;
                        }
                        command.success();
                    } catch (JSONException e) {
                        command.error(e.getMessage());
                    }

                }
                else if (action.equals("deregisterSIP")) {

                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        try {
                            LinphoneHelper.deregisterSIP(username, domain);
                        } catch (RuntimeException e) {
                            command.error(e.getMessage());
                            return;
                        }

                        command.success();
                    } catch (JSONException e) {
                        command.error(e.getMessage());
                    }

                }
                else if (action.equals("getRegisterStatusSIP")) {

                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        if (LinphoneHelper.getRegisterStatusSIP(username, domain)) {
                            command.success(LinphoneCore.RegistrationState.RegistrationOk.toString());
                        } else {
                            command.success(LinphoneCore.RegistrationState.RegistrationFailed.toString());
                        }

                    } catch (JSONException e) {
                        command.error(e.getMessage());
                    }

                }
                else if (action.equals("makeCall")) {

                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String displayName = args.get(2).toString();

                        LinphoneHelper.makeCall(username, domain, displayName);

                        command.success();
                    } catch (JSONException e) {
                        command.error(e.getMessage());
                    }

                }
                else if (action.equals("acceptCall")) {

                    if (LinphoneHelper.acceptCall()) {
                        command.success();
                    } else {
                        command.error("Can't accept the call.");
                    }

                }
                else if (action.equals("declineCall")) {

                    if (LinphoneHelper.declineCall()) {
                        command.success();
                    } else {
                        command.error(0);
                    }


                }
                else if (action.equals("startListener")) {

                    LinphoneHelper.addLinphoneCoreListener(new LinphoneCoreListener() {
                                @Override
                                public void authInfoRequested(LinphoneCore lc, String realm, String username, String Domain) {

                                }

                                @Override
                                public void callStatsUpdated(LinphoneCore lc, LinphoneCall call, LinphoneCallStats stats) {

                                }

                                @Override
                                public void newSubscriptionRequest(LinphoneCore lc, LinphoneFriend lf, String url) {

                                }

                                @Override
                                public void notifyPresenceReceived(LinphoneCore lc, LinphoneFriend lf) {

                                }

                                @Override
                                public void dtmfReceived(LinphoneCore lc, LinphoneCall call, int dtmf) {
                                    JSONObject result = new JSONObject();
                                    try {
                                        LinphoneAddress peerAddress = LinphoneHelper.getPeerAddress(call.getCallLog());
                                        result.put("event", "DTMF_RECEIVED");
                                        result.put("peerUsername", peerAddress.getUserName());
                                        result.put("peerDomain", peerAddress.getDomain());
                                        result.put("callId", call.getCallLog().getCallId());
                                        result.put("dtmf", ""+(char)dtmf);
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }

                                    PluginResult dataResult = new PluginResult(PluginResult.Status.OK, result);
                                    dataResult.setKeepCallback(true);
                                    command.sendPluginResult(dataResult);
                                }

                                @Override
                                public void notifyReceived(LinphoneCore lc, LinphoneCall call, LinphoneAddress from, byte[] event) {

                                }

                                @Override
                                public void transferState(LinphoneCore lc, LinphoneCall call, LinphoneCall.State new_call_state) {

                                }

                                @Override
                                public void infoReceived(LinphoneCore lc, LinphoneCall call, LinphoneInfoMessage info) {

                                }

                                @Override
                                public void subscriptionStateChanged(LinphoneCore lc, LinphoneEvent ev, SubscriptionState state) {

                                }

                                @Override
                                public void publishStateChanged(LinphoneCore lc, LinphoneEvent ev, PublishState state) {

                                }

                                @Override
                                public void show(LinphoneCore lc) {

                                }

                                @Override
                                public void displayStatus(LinphoneCore lc, String message) {

                                }

                                @Override
                                public void displayMessage(LinphoneCore lc, String message) {

                                }

                                @Override
                                public void displayWarning(LinphoneCore lc, String message) {

                                }

                                @Override
                                public void fileTransferProgressIndication(LinphoneCore lc, LinphoneChatMessage message, LinphoneContent content, int progress) {

                                }

                                @Override
                                public void fileTransferRecv(LinphoneCore lc, LinphoneChatMessage message, LinphoneContent content, byte[] buffer, int size) {

                                }

                                @Override
                                public int fileTransferSend(LinphoneCore lc, LinphoneChatMessage message, LinphoneContent content, ByteBuffer buffer, int size) {
                                    return 0;
                                }

                                @Override
                                public void uploadProgressIndication(LinphoneCore lc, int offset, int total) {

                                }

                                @Override
                                public void globalState(LinphoneCore lc, LinphoneCore.GlobalState state, String message) {

                                }

                                @Override
                                public void registrationState(LinphoneCore lc, LinphoneProxyConfig cfg, LinphoneCore.RegistrationState state, String smessage) {
                                    JSONObject result = new JSONObject();
                                    try {
                                        result.put("event", "REGISTRATION_CHANGE");
                                        result.put("message", smessage);
                                        result.put("username", cfg.getAddress().getUserName());
                                        result.put("domain", cfg.getAddress().getDomain());
                                        if (state == LinphoneCore.RegistrationState.RegistrationOk && LinphoneManager.getLc().getDefaultProxyConfig() != null && LinphoneManager.getLc().getDefaultProxyConfig().isRegistered()) {
                                            result.put("state", LinphoneCore.RegistrationState.RegistrationOk.toString());
                                        }

                                        if ((state == LinphoneCore.RegistrationState.RegistrationFailed || state == LinphoneCore.RegistrationState.RegistrationCleared)
                                                && (LinphoneManager.getLc().getDefaultProxyConfig() == null || !LinphoneManager.getLc().getDefaultProxyConfig().isRegistered())) {
                                            result.put("state", LinphoneCore.RegistrationState.RegistrationFailed.toString());
                                        }

                                        if (state == LinphoneCore.RegistrationState.RegistrationNone) {
                                            result.put("state", LinphoneCore.RegistrationState.RegistrationFailed.toString());
                                        }

                                        if (state == LinphoneCore.RegistrationState.RegistrationProgress) {
                                            result.put("state", LinphoneCore.RegistrationState.RegistrationProgress.toString());
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }

                                    PluginResult dataResult = new PluginResult(PluginResult.Status.OK, result);
                                    dataResult.setKeepCallback(true);
                                    command.sendPluginResult(dataResult);
                                }

                                @Override
                                public void configuringStatus(LinphoneCore lc, LinphoneCore.RemoteProvisioningState state, String message) {

                                }

                                @Override
                                public void messageReceived(LinphoneCore lc, LinphoneChatRoom cr, LinphoneChatMessage message) {
                                    JSONObject result = new JSONObject();
                                    try {
                                        result.put("event", "MESSAGE_RECEIVED");
                                        result.put("message", message.getText());
                                        result.put("fromUsername", cr.getPeerAddress().getUserName());
                                        result.put("fromDomain", cr.getPeerAddress().getDomain());
                                        result.put("storageId", message.getStorageId());
                                        result.put("imageFileUrl", LinphonePlugin.applyString(message.getExternalBodyUrl()));
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }

                                    PluginResult dataResult = new PluginResult(PluginResult.Status.OK, result);
                                    dataResult.setKeepCallback(true);
                                    command.sendPluginResult(dataResult);
                                }

                                @Override
                                public void callState(LinphoneCore lc, LinphoneCall call, LinphoneCall.State state, String message) {
                                    JSONObject result = new JSONObject();
                                    try {
                                        result.put("state", state.toString());
                                        result.put("message", message);
                                        result.put("caller", call.getCallLog().getFrom().getUserName());
                                        result.put("callee", call.getCallLog().getTo().getUserName());
                                        if (state == LinphoneCall.State.IncomingReceived) {
                                            result.put("event", "INCOMING_RECEIVED");

                                        } else {
                                            result.put("event", "CALL_EVENT");
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }

                                    PluginResult dataResult = new PluginResult(PluginResult.Status.OK, result);
                                    dataResult.setKeepCallback(true);
                                    command.sendPluginResult(dataResult);
                                }

                                @Override
                                public void callEncryptionChanged(LinphoneCore lc, LinphoneCall call, boolean encrypted, String authenticationToken) {

                                }

                                @Override
                                public void notifyReceived(LinphoneCore lc, LinphoneEvent ev, String eventName, LinphoneContent content) {

                                }

                                @Override
                                public void isComposingReceived(LinphoneCore lc, LinphoneChatRoom cr) {
                                    JSONObject result = new JSONObject();
                                    try {
                                        result.put("event", "TEXT_COMPOSE");
                                        result.put("peerAddress$username", cr.getPeerAddress().getUserName());
                                        result.put("peerAddress$domain", cr.getPeerAddress().getDomain());
                                        result.put("isRemoteComposing", cr.isRemoteComposing());
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }

                                    PluginResult dataResult = new PluginResult(PluginResult.Status.OK, result);
                                    dataResult.setKeepCallback(true);
                                    command.sendPluginResult(dataResult);
                                }

                                @Override
                                public void ecCalibrationStatus(LinphoneCore lc, LinphoneCore.EcCalibratorStatus status, int delay_ms, Object data) {

                                }

                                @Override
                                public void uploadStateChanged(LinphoneCore lc, LinphoneCore.LogCollectionUploadState state, String info) {

                                }

                                @Override
                                public void friendListCreated(LinphoneCore lc, LinphoneFriendList list) {

                                }

                                @Override
                                public void friendListRemoved(LinphoneCore lc, LinphoneFriendList list) {

                                }
                            });
                    LinphoneHelper.addLinphoneChatMessageListener(new LinphoneChatMessage.LinphoneChatMessageListener() {
                        @Override
                        public void onLinphoneChatMessageStateChanged(LinphoneChatMessage msg, LinphoneChatMessage.State state) {

                        }

                        @Override
                        public void onLinphoneChatMessageFileTransferReceived(LinphoneChatMessage msg, LinphoneContent content, LinphoneBuffer buffer) {
                            JSONObject result = new JSONObject();
                            try {
                                result.put("event", "FILE_TRANSFER_RECV_UPDATE");
                                result.put("chatMessageState", LinphonePlugin.getLinphoneChatMessageStateString(msg.getStatus()));
                                result.put("progress", 1);

                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }

                        @Override
                        public void onLinphoneChatMessageFileTransferSent(LinphoneChatMessage msg, LinphoneContent content, int offset, int size, LinphoneBuffer bufferToFill) {
                            JSONObject result = new JSONObject();
                            try {
                                result.put("event", "FILE_TRANSFER_SEND_UPDATE");
                                result.put("chatMessageState", LinphonePlugin.getLinphoneChatMessageStateString(msg.getStatus()));
                                result.put("progress", 1);

                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }

                        @Override
                        public void onLinphoneChatMessageFileTransferProgressChanged(LinphoneChatMessage msg, LinphoneContent content, int offset, int total) {
                            JSONObject result = new JSONObject();
                            try {
                                if (LinphoneManager.getInstance().getMessageUploadPending() == msg) {
                                    result.put("event", "FILE_TRANSFER_SEND_UPDATE");
                                } else {
                                    result.put("event", "FILE_TRANSFER_RECV_UPDATE");
                                }
                                result.put("chatMessageState", LinphonePlugin.getLinphoneChatMessageStateString(msg.getStatus()));
                                result.put("progress", (float)offset/total);

                            } catch (JSONException e) {
                                e.printStackTrace();
                            }

                            PluginResult dataResult = new PluginResult(PluginResult.Status.OK, result);
                            dataResult.setKeepCallback(true);
                            command.sendPluginResult(dataResult);
                        }
                    });

                }


                /* Obtaining information about a running call: sound volumes, quality indicators Functions */

                else if (action.equals("getAllCalls")) {
                    JSONArray resultArray = new JSONArray();
                    LinphoneCall[] calls = LinphoneHelper.getAllCalls();
                    for (LinphoneCall call : calls) {
                        JSONObject callJson = LinphonePlugin.getCallJsonObject(call);
                        resultArray.put(callJson);
                    }
                    command.success(resultArray);
                }
                else if (action.equals("getCallInformation")) {
                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        JSONObject resultJSON = LinphonePlugin.getCallJsonObject(call);
                        command.success(resultJSON);
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }
                }
                else if (action.equals("getCallInformationWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            JSONObject resultJSON = LinphonePlugin.getCallJsonObject(call);
                            command.success(resultJSON);
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("terminateCall")) {

                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        LinphoneHelper.terminateCall(call);
                        command.success();
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }
                }
                else if (action.equals("terminateCallWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            LinphoneHelper.terminateCall(call);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("sendDtmf")) {

                    try {
                        String keyCode = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        if (lc.isIncall()) {
                            if (keyCode.equals("null") || keyCode.isEmpty()) {
                                command.error("Key code is invalid.");
                                return;
                            }
                            char code = keyCode.charAt(0);
                            if (LinphoneHelper.sendDtmf(code)) {
                                command.success();
                            }
                        } else {
                            command.error("No call found.");
                        }

                    } catch (JSONException e) {
                        command.error("Key code is invalid.");
                    }

                }
                else if (action.equals("sendDtmfWithCallId")) {
        //            try {
        //                String callId = args.get(0).toString();
        //                String keyCode = args.get(1).toString();

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("muteCall")) {

                    LinphoneHelper.muteCall();
                    command.success();

                }
                else if (action.equals("unmuteCall")) {

                    LinphoneHelper.unmuteCall();
                    command.success();

                }
                else if (action.equals("enableSpeaker")) {

                    LinphoneHelper.enableSpeaker();
                    command.success();

                }
                else if (action.equals("disableSpeaker")) {

                    LinphoneHelper.disableSpeaker();
                    command.success();

                }
                else if (action.equals("holdCall")) {

                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        LinphoneHelper.holdCall(call);
                        command.success();
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }

                }
                else if (action.equals("holdCallWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            LinphoneHelper.holdCall(call);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("unholdCall")) {

                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        LinphoneHelper.unholdCall(call);
                        command.success();
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }

                }
                else if (action.equals("unholdCallWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            LinphoneHelper.unholdCall(call);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setSpeakerVolumeGain")) {
        //            try {
        //                double volume = args.getDouble(0);

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setSpeakerVolumeGainWithCallId")) {
        //            try {
        //                String callId = args.get(0).toString();
        //                double volume = args.getDouble(1);

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setMicrophoneVolumeGain")) {
                    try {
                        double volume = args.getDouble(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setMicrophoneGain((float)volume);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setMicrophoneVolumeGainWithCallId")) {
        //            try {
        //                String callId = args.get(0).toString();
        //                double volume = args.getDouble(1);

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("getAudioStats")) {
                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        LinphoneCallStats callStats = call.getAudioStats();
                        if (callStats != null) {
                            JSONObject result = LinphonePlugin.getCallStatesJsonObject(callStats);
                            command.success(result);
                        } else {
                            command.error(CALL_STATS_NOT_FOUND);
                        }
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }
                }
                else if (action.equals("getAudioStatsWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            LinphoneCallStats callStats = call.getAudioStats();
                            if (callStats != null) {
                                JSONObject result = LinphonePlugin.getCallStatesJsonObject(call.getAudioStats());
                                command.success(result);
                            } else {
                                command.error(CALL_STATS_NOT_FOUND);
                            }
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getVideoStats")) {
                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        LinphoneCallStats callStats = call.getVideoStats();
                        if (callStats != null) {
                            JSONObject result = LinphonePlugin.getCallStatesJsonObject(call.getVideoStats());
                            command.success(result);
                        } else {
                            command.error(CALL_STATS_NOT_FOUND);
                        }
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }
                }
                else if (action.equals("getVideoStatsWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            LinphoneCallStats callStats = call.getVideoStats();
                            if (callStats != null) {
                                JSONObject result = LinphonePlugin.getCallStatesJsonObject(callStats);
                                command.success(result);
                            } else {
                                command.error(CALL_STATS_NOT_FOUND);
                            }
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getTextStats")) {
                    command.error(NO_SUPPORT_ON_ANDROID);
                }
                else if (action.equals("getTextStatsWithCallId")) {
        //            try {
        //                String callId = args.get(0).toString();

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("startRecording")) {
                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        call.startRecording();
                        command.success();
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }
                }
                else if (action.equals("startRecordingWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            call.startRecording();
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("stopRecording")) {
                    LinphoneCall call = LinphoneHelper.getCurrentCall();
                    if (call != null) {
                        call.stopRecording();
                        command.success();
                    } else {
                        command.error(NO_CURRENT_CALL);
                    }
                }
                else if (action.equals("stopRecordingWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            call.stopRecording();
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("linphoneCallEnableEchoCancellation")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCall call = LinphoneHelper.getCurrentCall();
                        if (call != null) {
                            call.enableEchoCancellation(enabled);
                            command.success();
                        } else {
                            command.error(NO_CURRENT_CALL);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("linphoneCallEnableEchoCancellationWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        boolean enabled = args.getBoolean(1);
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            call.enableEchoCancellation(enabled);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("linphoneCallEnableEchoLimiter")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCall call = LinphoneHelper.getCurrentCall();
                        if (call != null) {
                            call.enableEchoLimiter(enabled);
                            command.success();
                        } else {
                            command.error(NO_CURRENT_CALL);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("linphoneCallEnableEchoLimiterWithCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        boolean enabled = args.getBoolean(1);
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            call.enableEchoCancellation(enabled);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }



                /* Controlling network parameters (ports, mtu...) Functions */

                else if (action.equals("setAudioPort")) {
                    try {
                        int port = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setAudioPort(port);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setVideoPort")) {
                    try {
                        int port = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoPort(port);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setTextPort")) {
        //            try {
        //                int port = args.getInt(0);

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setSipPort")) {
        //            try {
        //                int port = args.getInt(0);

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setSipTransport")) {
                    try {
                        int udpPort = args.getInt(0);
                        int tcpPort = args.getInt(1);
        //                int dtlsPort = args.getInt(2);
                        int tlsPort = args.getInt(3);

                        LinphoneCore lc = LinphoneManager.getLc();
                        LinphoneCore.Transports transports = new LinphoneCore.Transports();
                        transports.udp = udpPort;
                        transports.tcp = tcpPort;
                        transports.tls = tlsPort;
                        lc.setSignalingTransportPorts(transports);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableIpv6")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableIpv6(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setSipDscp")) {
                    try {
                        int dscp = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setSipDscp(dscp);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setAudioDscp")) {
                    try {
                        int dscp = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setAudioDscp(dscp);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setVideoDscp")) {
                    try {
                        int dscp = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoDscp(dscp);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setStunServer")) {
                    try {
                        String stunServer = args.getString(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setStunServer(stunServer);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setNatAddress")) {
        //            try {
        //                String natAddress = args.get(0).toString();

                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setFirewallPolicy")) {
                    try {
                        String firewallPolicy = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setFirewallPolicy(LinphonePlugin.getFirewallPolicy(firewallPolicy));
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setNetworkReachable")) {
                    try {
                        boolean networkReachable = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setNetworkReachable(networkReachable);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableKeepAlive")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableKeepAlive(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableSdp200Ack")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableSdp200Ack(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNetworkParameters")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    JSONObject result = new JSONObject();

                    try {
                        result.put("audioPort", 0); // TODO don't know
                        result.put("videoPort", 0); // TODO don't know
                        result.put("textPort", 0); // TODO don't know
                        result.put("audioPortRange$min", 0); // TODO don't know
                        result.put("audioPortRange$max", 0); // TODO don't know
                        result.put("videoPortRange$min", 0); // TODO don't know
                        result.put("videoPortRange$max", 0); // TODO don't know
                        result.put("textPortRange$min", 0); // TODO don't know
                        result.put("textPortRange$max", 0); // TODO don't know
                        result.put("sipPort", 0); // TODO don't know
                        result.put("isIpv6Enabled", lc.isIpv6Enabled());
                        result.put("sipDscp", lc.getSipDscp());
                        result.put("audioDscp", lc.getAudioDscp());
                        result.put("videoDscp", lc.getVideoDscp());
                        result.put("stunServer", lc.getStunServer());
                        result.put("isUpnpAvailable", lc.upnpAvailable());
                        result.put("upnpState", LinphonePlugin.getUpnpStateString(lc.getUpnpState()));
                        result.put("upnpExternalIpAddress", lc.getUpnpExternalIpaddress());
                        result.put("natAddress", ""); // TODO don't know
                        result.put("firewallPolicy", LinphonePlugin.getFirewallPolicyString(lc.getFirewallPolicy()));
                        result.put("isNetworkReachable", lc.isNetworkReachable());
                        result.put("keepAliveEnabled", lc.isKeepAliveEnabled());
                        result.put("isSdp200AckEnabled", lc.isSdp200AckEnabled());
                        result.put("udpPort", lc.getSignalingTransportPorts().udp);
                        result.put("tcpPort", lc.getSignalingTransportPorts().tcp);
                        result.put("dtlsPort", 0); // TODO don't know
                        result.put("tlsPort", lc.getSignalingTransportPorts().tls);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    command.success(result);
                }


                /* Controlling media parameters Functions */

                else if (action.equals("setAudioCodecs")) {
                    try {
                        String codecListString = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setAudioCodecs(LinphonePlugin.getCodecList(codecListString));
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setVideoCodecs")) {
                    try {
                        String codecListString = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoCodecs(LinphonePlugin.getCodecList(codecListString));
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setAudioPortRange")) {
                    try {
                        int min = args.getInt(0);
                        int max = args.getInt(1);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setAudioPortRange(min, max);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setVideoPortRange")) {
                    try {
                        int min = args.getInt(0);
                        int max = args.getInt(1);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoPortRange(min, max);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setTextPortRange")) {
        //            try {
        //                int min = args.getInt(0);
        //                int max = args.getInt(1);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setNortpTimeout")) {
                    try {
                        int nortpTimeout = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setNortpTimeout(nortpTimeout);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setUseInfoForDtmf")) {
                    try {
                        boolean useInfo = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setUseSipInfoForDtmfs(useInfo);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setUseRfc2833ForDtmf")) {
                    try {
                        boolean useRfc2833 = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setUseRfc2833ForDtmfs(useRfc2833);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setRingLevel")) {
        //            try {
        //                int level = args.getInt(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setMicGainDb")) {
                    try {
                        double gainDb = args.getDouble(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setMicrophoneGain((float)gainDb);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setPlaybackGainDb")) {
                    try {
                        double gainDb = args.getDouble(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPlaybackGain((float)gainDb);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setPlayLevel")) {
                    try {
                        int level = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPlayLevel(level);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setRecLevel")) {
        //            try {
        //                String level = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("soundDeviceCanCapture")) {
        //            try {
        //                String devid = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("soundDeviceCanPlayback")) {
        //            try {
        //                String devid = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setRingerDevice")) {
        //            try {
        //                String devid = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setPlaybackDevice")) {
        //            try {
        //                String devid = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setCaptureDevice")) {
        //            try {
        //                String devid = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setRing")) {
                    try {
                        String path = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setRing(path);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setRingback")) {
                    try {
                        String path = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setRingback(path);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableEchoCancellation")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableEchoCancellation(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setVideoPolicy")) {
                    try {
                        boolean autoInitiate = args.getBoolean(0);
                        boolean autoAccept = args.getBoolean(1);

                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoPolicy(autoInitiate, autoAccept);
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableVideoPreview")) {
        //            try {
        //                boolean enabled = args.getBoolean(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("enableSelfView")) {
        //            try {
        //                boolean enabled = args.getBoolean(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setVideoDevice")) {
                    try {
                        int deviceId = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoDevice(deviceId);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setDeviceRotation")) {
                    try {
                        int rotation = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setDeviceRotation(rotation);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("playDtmf")) {
                    try {
                        String dtmf = args.get(0).toString();
                        int durationInMS = args.getInt(1);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.playDtmf(dtmf.charAt(0), durationInMS);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("stopDtmf")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.stopDtmf();
                    command.success();
                }
                else if (action.equals("setMtu")) {
                    try {
                        int mtu = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setMtu(mtu);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("stopRinging")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.stopRinging();
                    command.success();
                }
                else if (action.equals("setAvpfMode")) {
        //            try {
        //                String mode = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setAvpfRRInterval")) {
        //            try {
        //                String interval = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setDownloadBandwidth")) {
                    try {
                        int bandwidth = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setDownloadBandwidth(bandwidth);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setUploadBandwidth")) {
                    try {
                        int bandwidth = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setUploadBandwidth(bandwidth);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableAdaptiveRateControl")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableAdaptiveRateControl(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setAdaptiveRateAlgorithm")) {
                    try {
                        String algorithm = args.get(0).toString();
                        LinphoneCore.AdaptiveRateAlgorithm adaptiveRateAlgorithm = LinphonePlugin.getAdaptiveRateAlgorithm(algorithm);
                        if (adaptiveRateAlgorithm != null) {
                            LinphoneCore lc = LinphoneManager.getLc();
                            lc.setAdaptiveRateAlgorithm(adaptiveRateAlgorithm);
                            command.success();
                        } else {
                            command.error(WRONG_ARGUMENTS);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setDownloadPtime")) {
                    try {
                        int ptime = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setDownloadPtime(ptime);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setUploadPtime")) {
                    try {
                        int ptime = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setUploadPtime(ptime);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setSipTransportTimeout")) {
                    try {
                        int timeoutInMS = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setSipTransportTimeout(timeoutInMS);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableDnsSrv")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableDnsSrv(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getAudioCodecs")) {
                    JSONArray resultArray = new JSONArray();
                    LinphoneCore lc = LinphoneManager.getLc();
                    PayloadType[] payloadTypes = lc.getAudioCodecs();
                    for (PayloadType payloadType : payloadTypes) {
                        JSONObject payloadJson = LinphonePlugin.getPayloadJsonObject(payloadType);
                        resultArray.put(payloadJson);
                    }
                    command.success(resultArray);
                }
                else if (action.equals("getVideoCodecs")) {
                    JSONArray resultArray = new JSONArray();
                    LinphoneCore lc = LinphoneManager.getLc();
                    PayloadType[] payloadTypes = lc.getVideoCodecs();
                    for (PayloadType payloadType : payloadTypes) {
                        JSONObject payloadJson = LinphonePlugin.getPayloadJsonObject(payloadType);
                        resultArray.put(payloadJson);
                    }
                    command.success(resultArray);
                }
                else if (action.equals("getTextCodecs")) {
                    command.error(NO_SUPPORT_ON_ANDROID);
                }
                else if (action.equals("setPayloadTypeBitrate")) {
                    try {
                        String mimeType = args.getString(0);
                        int clockRate = args.getInt(1);
                        int bitrate = args.getInt(2);

                        PayloadType payloadType = LinphoneHelper.getPayloadType(mimeType, clockRate, -1);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPayloadTypeBitrate(payloadType, bitrate);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enablePayloadType")) {
                    try {
                        String mimeType = args.getString(0);
                        int clockRate = args.getInt(1);
                        boolean enabled = args.getBoolean(2);

                        PayloadType payloadType = LinphoneHelper.getPayloadType(mimeType, clockRate, -1);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enablePayloadType(payloadType, enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("findPayloadType")) {
                    try {
                        String mimeType = args.get(0).toString();
                        int clockRate = args.getInt(1);
                        int channels = args.getInt(2);

                        PayloadType payloadType = LinphoneHelper.getPayloadType(mimeType, clockRate, channels);
                        JSONObject resultJSON = LinphonePlugin.getPayloadJsonObject(payloadType);
                        command.success(resultJSON);
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setPayloadTypeNumber")) {
                    try {
                        String mimeType = args.getString(0);
                        int clockRate = args.getInt(1);
                        int number = args.getInt(2);

                        PayloadType payloadType = LinphoneHelper.getPayloadType(mimeType, clockRate, -1);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPayloadTypeNumber(payloadType, number);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableAudioAdaptiveJittcomp")) {
        //            try {
        //                boolean enabled = args.getBoolean(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setAudioJittcomp")) {
                    try {
                        int millisecond = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setAudioJittcomp(millisecond);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableVideoAdaptiveJittcomp")) {
        //            try {
        //                boolean enabled = args.getBoolean(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setVideoJittcomp")) {
                    try {
                        int milliseconds = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoJittcomp(milliseconds);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("reloadSoundDevices")) {
                    command.error(NO_SUPPORT_ON_ANDROID);
                }
                else if (action.equals("setRemoteRingbackTone")) {
                    try {
                        String ring = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setRemoteRingbackTone(ring);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setRingDuringIncomingEarlyMedia")) {
        //            try {
        //                boolean enabled = args.getBoolean(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("enableEchoLimiter")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableEchoLimiter(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableVideoCapture")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableVideo(enabled, false);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableVideoDisplay")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableVideo(true, enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableVideoSourceReuse")) {
        //            try {
        //                boolean enabled = args.getBoolean(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setPreferredVideoSize")) {
                    try {
                        int width = args.getInt(0);
                        int height = args.getInt(1);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPreferredVideoSize(new VideoSize(width, height));
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setPreviewVideoSize")) {
        //            try {
        //                int width = args.getInt(0);
        //                int height = args.getInt(1);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setPreviewVideoSizeByName")) {
        //            try {
        //                String name = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setPreferredVideoSizeByName")) {
                    try {
                        String name = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPreferredVideoSizeByName(name);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setPreferredFramerate")) {
                    try {
                        double fps = args.getDouble(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPreferredFramerate((float)fps);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("reloadVideoDevices")) {
                    command.error(NO_SUPPORT_ON_ANDROID);
                }
                else if (action.equals("setStaticPicture")) {
                    try {
                        String path = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setStaticPicture(path);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setStaticPictureFps")) {
        //            try {
        //                String fps = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("usePreviewWindow")) {
        //            try {
        //                boolean use = args.getBoolean(0);
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setUseFiles")) {
        //            try {
        //                String use = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setPlayFile")) {
                    try {
                        String file = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setPlayFile(file);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setRecordFile")) {
        //            try {
        //                String file = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("setMediaEncryption")) {
                    try {
                        String mediaEncryption = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setMediaEncryption(LinphonePlugin.getMediaEncryption(mediaEncryption));
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setMediaEncryptionMandatory")) {
                    try {
                        boolean mandatory = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setMediaEncryptionMandatory(mandatory);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setAudioMulticastAddress")) {
                    try {
                        String ip = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setAudioMulticastAddr(ip);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("setVideoMulticastAddress")) {
                    try {
                        String ip = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoMulticastAddr(ip);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("setAudioMulticastTtl")) {
                    try {
                        int ttl = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setAudioMulticastTtl(ttl);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("setVideoMulticastTtl")) {
                    try {
                        int ttl = args.getInt(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setVideoMulticastTtl(ttl);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("enableAudioMulticast")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableAudioMulticast(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableVideoMulticast")) {
                    try {
                        boolean enabled = args.getBoolean(0);
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.enableVideoMulticast(enabled);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setVideoDisplayFilter")) {
        //            try {
        //                String filterName = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
        //            } catch (JSONException e) {
        //                command.error(WRONG_ARGUMENTS);
        //            }
                }
                else if (action.equals("getMediaParameters")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    JSONObject result = new JSONObject();

                    try {
                        result.put("audioJittcomp", 0); // TODO
                        result.put("videoJittcomp", 0); // TODO
                        result.put("nortpTimeout", lc.getNortpTimeout());
                        result.put("useInfoForDtmf", lc.getUseSipInfoForDtmfs());
                        result.put("useRfc2833ForDtmf", lc.getUseRfc2833ForDtmfs());
                        result.put("playLevel", lc.getPlayLevel());
                        result.put("ringLevel", 0); // TODO
                        result.put("recLevel", 0); // TODO
                        result.put("micGainDb", 0L); // TODO
                        result.put("playbackGainDb", lc.getPlaybackGain());
                        result.put("ringerDevice", ""); // TODO
                        result.put("playbackDevice", 0); // TODO
                        result.put("captureDevice", ""); // TODO
                        result.put("soundDevices", ""); // TODO
                        result.put("videoDevices", ""); // TODO
                        result.put("videoDevice", lc.getVideoDevice());
                        result.put("ring", lc.getRing());
                        result.put("ringback", ""); // TODO
                        result.put("echoCancellationEnabled", lc.isEchoCancellationEnabled());
                        result.put("videoPreviewEnabled", false);
                        result.put("deviceRotation", 0); // TODO
                        result.put("avpfMode", ""); // TODO
                        result.put("avpfRRInterval", ""); // TODO
                        result.put("downloadBandwidth", lc.getDownloadBandwidth());
                        result.put("uploadBandwidth", lc.getUploadBandwidth());
                        result.put("adaptiveRateControlEnabled", lc.isAdaptiveRateControlEnabled());
                        result.put("adaptiveRateAlgorithm", LinphonePlugin.getAdaptiveRateAlgorithmString(lc.getAdaptiveRateAlgorithm()));
                        result.put("downloadTime", 0); // TODO
                        result.put("uploadPtime", 0); // TODO
                        result.put("sipTransportTimeout", lc.getSipTransportTimeout());
                        result.put("dnsSrvEnabled", lc.dnsSrvEnabled());
                        result.put("audioAdaptiveJittcompEnabled", false); // TODO
                        result.put("videoAdaptiveJittcompEnabled", false); // TODO
                        result.put("remoteRingbackTone", lc.getRemoteRingbackTone());
                        result.put("echoLimiterEnabled", lc.isEchoLimiterEnabled());
                        result.put("videoEnabled", lc.isVideoEnabled());
                        result.put("videoCaptureEnabled", false); // TODO
                        result.put("videoDisplayEnabled", false); // TODO
                        result.put("preferredFramerate", lc.getPreferredFramerate());
                        result.put("staticPicture", ""); // TODO
                        result.put("staticPictureFps", 0L); // TODO
                        result.put("playFile", ""); // TODO
                        result.put("recordFile", ""); // TODO
                        result.put("mediaEncryption", LinphonePlugin.getMediaEncryptionString(lc.getMediaEncryption()));
                        result.put("isMediaEncryptionMandatory", lc.isMediaEncryptionMandatory());
                        result.put("supportedFileFormats", ""); // TODO
                        result.put("audioMulticastAddress", lc.getAudioMulticastAddr());
                        result.put("videoMulticastAddress", lc.getVideoMulticastAddr());
                        result.put("audioMulticastTtl", lc.getAudioMulticastTtl());
                        result.put("videoMulticastTtl", lc.getVideoMulticastTtl());
                        result.put("audioMulticastEnabled", lc.audioMulticastEnabled());
                        result.put("videoMulticastEnabled", lc.videoMulticastEnabled());
                        result.put("videoDisplayFilter", ""); // TODO
                        result.put("selfViewEnabled", false); // TODO
                        result.put("micEnabled", !lc.isMicMuted());
                        result.put("preferredVideoSize.width", lc.getPreferredVideoSize().width);
                        result.put("preferredVideoSize.height", lc.getPreferredVideoSize().height);
                        result.put("currentPreviewVideoSize.width", 0); // TODO
                        result.put("currentPreviewVideoSize.height", 0); // TODO
                        result.put("previewVideoSize.width", 0); // TODO
                        result.put("previewVideoSize.height", 0); // TODO
                        result.put("automaticallyAccept", lc.getVideoAutoAcceptPolicy());
                        result.put("automaticallyInitiate", lc.getVideoAutoInitiatePolicy());
                        result.put("mtu", lc.getMtu());
                        result.put("ringDuringIncomingEarlyMedia", false); // TODO
                        result.put("useFiles", false); // TODO

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    command.success(result);
                }



                /* Managing call logs Functions */

                else if (action.equals("getCallLogs")) {
                    try {
                        String callStatus = args.get(0).toString();
                        String callDirection = args.get(1).toString();
                        List<LinphoneCallLog> allCallLogs = LinphoneHelper.getCallLogs(callStatus, callDirection);
                        JSONArray resultArray = new JSONArray();
                        for (LinphoneCallLog callLog : allCallLogs) {
                            JSONObject resultJSON = LinphonePlugin.getCallLogJsonObject(callLog);
                            resultArray.put(resultJSON);
                        }
                        command.success(resultArray);
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearCallLogs")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.clearCallLogs();
                    command.success();
                }
                else if (action.equals("getCallPeerHistoryForCallId")) {
                    try {
                        String callId = args.get(0).toString();

                        LinphoneCallLog callLog = LinphoneHelper.getCallLogFromCallId(callId);
                        if (callLog != null) {
                            List<LinphoneCallLog> callLogs = LinphoneHelper.getCallPeerHistory(callLog);
                            JSONArray resultArray = new JSONArray();
                            for (LinphoneCallLog linphoneCallLog : callLogs) {
                                JSONObject resultJSON = LinphonePlugin.getCallLogJsonObject(linphoneCallLog);
                                resultArray.put(resultJSON);
                            }
                            command.success(resultArray);
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("findCallLogFromCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCallLog callLog = LinphoneHelper.getCallLogFromCallId(callId);
                        if (callLog != null) {
                            JSONObject resultJSON = LinphonePlugin.getCallLogJsonObject(callLog);
                            command.success(resultJSON);
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }

                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("removeCallLogFromCallId")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCallLog callLog = LinphoneHelper.getCallLogFromCallId(callId);
                        if (callLog != null) {
                            LinphoneCore lc = LinphoneManager.getLc();
                            lc.removeCallLog(callLog);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getLastOutgoingCallLog")) {
                    LinphoneCallLog callLog = LinphoneHelper.getLastOutgoingCallLog();
                    if (callLog != null) {
                        JSONObject resultJSON = LinphonePlugin.getCallLogJsonObject(callLog);
                        command.success(resultJSON);
                    } else {
                        command.error("No last outgoing call log found.");
                    }
                }
                else if (action.equals("getMissedCallsCount")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    int count = lc.getMissedCallsCount();
                    command.success(count);
                }
                else if (action.equals("resetMissedCallsCount")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.resetMissedCallsCount();
                    command.success();
                }




                /* Making an audio conference Functions */

                else if (action.equals("getAudioConferenceInformation")) {
                    LinphoneCore lc = LinphoneManager.getLc();

                    LinphoneConference conference = lc.getConference();
                    JSONObject result = new JSONObject();

                    try {
                        result.put("localInputVolume", 0L); // TODO
                        result.put("size", lc.getConferenceSize());
                        result.put("isConference", lc.isInConference());


                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    command.success(result);
                }
                else if (action.equals("addToConference")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            LinphoneCore lc = LinphoneManager.getLc();
                            lc.addToConference(call);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("removeFromConference")) {
                    try {
                        String callId = args.get(0).toString();
                        LinphoneCall call = LinphoneHelper.getCallFromCallId(callId);
                        if (call != null) {
                            LinphoneCore lc = LinphoneManager.getLc();
                            lc.removeFromConference(call);
                            command.success();
                        } else {
                            command.error(CALL_ID_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("leaveConference")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.leaveConference();
                    command.success();
                }
                else if (action.equals("enterConference")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.enterConference();
                    command.success();
                }
                else if (action.equals("addAllToConference")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.addAllToConference();
                    command.success();
                }
                else if (action.equals("startConferenceRecording")) {
                    try {
                        String path = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.startConferenceRecording(path);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("stopConferenceRecording")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.stopConferenceRecording();
                    command.success();
                }





                /* Chat room and Messaging Functions */

                else if (action.equals("getAllChatRooms")) {
                    JSONArray resultArray = new JSONArray();
                    LinphoneChatRoom[] chatRooms = LinphoneHelper.getAllChatRooms();
                    for (LinphoneChatRoom chatRoom : chatRooms) {
                        JSONObject chatRoomJSON = LinphonePlugin.getChatRoomJsonObject(chatRoom);
                        resultArray.put(chatRoomJSON);
                    }
                    command.success(resultArray);
                }
                else if (action.equals("setChatDatabasePath")) {
                    try {
                        String path = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.setChatDatabasePath(path);
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getChatRoomWithUsername")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        LinphoneAddress address = LinphoneHelper.getAddress(username, domain);
                        LinphoneCore lc = LinphoneManager.getLc();
                        LinphoneChatRoom chatRoom = lc.getChatRoom(address);
                        if (chatRoom != null) {
                            JSONObject resultJSON = LinphonePlugin.getChatRoomJsonObject(chatRoom);
                            command.success(resultJSON);
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("getChatRoomFromUri")) {
                    try {
                        String toUri = args.get(0).toString();
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            JSONObject resultJSON = LinphonePlugin.getChatRoomJsonObject(chatRoom);
                            command.success(resultJSON);
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("deleteChatRoom")) {
//                    try {
//                        String toUri = args.get(0).toString();
                        command.error(NO_SUPPORT_ON_ANDROID);
//                    } catch (JSONException e) {
//                        command.error(WRONG_ARGUMENTS);
//                    }
                }
                else if (action.equals("disableChat")) {
                    try {
                        String reason = args.get(0).toString();
                        LinphoneCore lc = LinphoneManager.getLc();
                        lc.disableChat(LinphonePlugin.getReason(reason));
                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("enableChat")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    lc.enableChat();
                    command.success();
                }
                else if (action.equals("uploadFileMessage")) {
                    try {
                        String url = args.get(0).toString();
                        String toUri = args.get(1).toString();

                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneHelper.uploadFileMessage(chatRoom, url.replace("file://", ""));
                            command.success();
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("startFileDownload")) {
                    try {
                        String toUri = args.get(0).toString();
                        int messageStoreId = args.getInt(1);
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneChatMessage chatMessage = LinphoneHelper.findChatMessage(chatRoom, messageStoreId);
                            if (chatMessage != null) {
                                LinphoneHelper.startFileDownload(chatMessage);
                                command.success();
                            } else {
                                command.error(MESSAGE_STORE_ID_NOT_FOUND);
                            }
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("cancelFileDownload")) {

                    try {
                        String toUri = args.get(0).toString();
                        int messageStoreId = args.getInt(1);
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneChatMessage chatMessage = LinphoneHelper.findChatMessage(chatRoom, messageStoreId);
                            if (chatMessage != null) {
                                LinphoneHelper.cancelFileDownload(chatMessage);
                                command.success();
                            } else {
                                command.error(MESSAGE_STORE_ID_NOT_FOUND);
                            }
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("cancelFileUpload")) {

                    try {
                        String toUri = args.get(0).toString();
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                                LinphoneHelper.cancelFileUpload();
                                command.success();
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("sendMessageWithChatRoom")) {
                    try {
                        String toUri = args.get(0).toString();
                        String message = args.get(1).toString();

                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            chatRoom.sendMessage(message);
                            command.success();
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("markAsRead")) {
                    try {
                        String toUri = args.get(0).toString();
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            chatRoom.markAsRead();
                            command.success();
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("deleteMessage")) {
                    try {
                        String toUri = args.get(0).toString();
                        int messageStoreId = args.getInt(1);
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneChatMessage chatMessage = LinphoneHelper.findChatMessage(chatRoom, messageStoreId);
                            if (chatMessage != null) {
                                chatRoom.deleteMessage(chatMessage);
                                command.success();
                            } else {
                                command.error(MESSAGE_STORE_ID_NOT_FOUND);
                            }
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("deleteHistory")) {
                    try {
                        String toUri = args.get(0).toString();
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            chatRoom.deleteHistory();
                            command.success();
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getHistory")) {
                    try {
                        String toUri = args.get(0).toString();
                        int numberOfMessages = args.getInt(1);
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneChatMessage[] chatMessages = chatRoom.getHistory(numberOfMessages);
                            JSONArray resultArray = new JSONArray();
                            for (int index = 0; index < chatMessages.length; index++) {
                                LinphoneChatMessage chatMessage = chatMessages[index];
                                JSONObject chatMessageJSON = LinphonePlugin.getChatMessageJsonObject(chatMessage);
                                resultArray.put(chatMessageJSON);
                            }
                            command.success(resultArray);
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getHistoryRange")) {
                    try {
                        String toUri = args.get(0).toString();
                        int begin = args.getInt(1);
                        int end = args.getInt(2);

                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneChatMessage[] chatMessages = chatRoom.getHistoryRange(begin, end);
                            JSONArray resultArray = new JSONArray();
                            for (int index = 0; index < chatMessages.length; index++) {
                                LinphoneChatMessage chatMessage = chatMessages[index];
                                JSONObject chatMessageJSON = LinphonePlugin.getChatMessageJsonObject(chatMessage);
                                resultArray.put(chatMessageJSON);
                            }
                            command.success(resultArray);
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("compose")) {
                    try {
                        String toUri = args.get(0).toString();
                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            chatRoom.compose();
                            command.success();
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addCustomHeader")) {
                    try {
                        String toUri = args.get(0).toString();
                        int messageStoreId = args.getInt(1);
                        String headerName = args.get(2).toString();
                        String headerValue = args.get(3).toString();

                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneChatMessage chatMessage = LinphoneHelper.findChatMessage(chatRoom, messageStoreId);
                            if (chatMessage != null) {
                                chatMessage.addCustomHeader(headerName, headerValue);
                                command.success();
                            } else {
                                command.error(MESSAGE_STORE_ID_NOT_FOUND);
                            }
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getCustomHeader")) {
                    try {
                        String toUri = args.get(0).toString();
                        int messageStoreId = args.getInt(1);
                        String headerName = args.get(2).toString();

                        LinphoneChatRoom chatRoom = LinphoneHelper.getOrCreateChatRoomForContact(toUri);
                        if (chatRoom != null) {
                            LinphoneChatMessage chatMessage = LinphoneHelper.findChatMessage(chatRoom, messageStoreId);
                            if (chatMessage != null) {
                                String headerValue = chatMessage.getCustomHeader(headerName);
                                command.success(headerValue);
                            } else {
                                command.error(MESSAGE_STORE_ID_NOT_FOUND);
                            }
                        } else {
                            command.error(CHAT_ROOM_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }



                /* Managing Buddies and buddy list and presence Functions */

                else if (action.equals("getMyBuddy")) {
                    LinphoneCore lc = LinphoneManager.getLc();
                    JSONObject resultJSON = LinphonePlugin.getPresenceModelJsonObject(lc.getPresenceModel());
                    command.success(resultJSON);
                }
                else if (action.equals("findFriendByUsername")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            JSONObject resultJSON = LinphonePlugin.getFriendJsonObject(friend);
                            command.success(resultJSON);
                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getFriendList")) {
                    LinphoneFriend[] friends = LinphoneHelper.getFriendList();
                    JSONArray resultArray = new JSONArray();
                    for (LinphoneFriend friend : friends) {
                        JSONObject friendJSON = LinphonePlugin.getFriendJsonObject(friend);
                        resultArray.put(friendJSON);
                    }
                    command.success(resultArray);
                }
                else if (action.equals("notifyAllFriendList")) {
                    try {
                        String activityType = args.get(0).toString();
                        String description = args.get(1).toString();

                        PresenceActivityType presenceActivityType = LinphonePlugin.getPresenceActivityType(activityType);
                        LinphoneHelper.notifyALlFriendList(presenceActivityType, description);

                        command.success();
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addFriend")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend == null) {
                            LinphoneHelper.addFriend(username, domain);
                            command.success();
                        } else {
                            command.error(FRIEND_ALREADY_ADDED);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    } catch (LinphoneCoreException e) {
                        command.error(e.getMessage());
                    }
                }
                else if (action.equals("removeFriend")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            LinphoneCore lc = LinphoneManager.getLc();
                            lc.removeFriend(friend);
                            command.success();
                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("acceptSubscriber")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            LinphoneHelper.acceptSubscriber(friend);
                            command.success();
                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("rejectSubscriber")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            LinphoneHelper.rejectSubscriber(friend);
                            command.success();
                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("findPresenceModelByUsername")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                JSONObject resultJSON = LinphonePlugin.getPresenceModelJsonObject(presenceModel);
                                command.success(resultJSON);
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setBasicStatus")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String basicStatus = args.get(2).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.setBasicStatus(LinphonePlugin.getPresenceBasicStatus(basicStatus));
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setContact")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String contact = args.get(2).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.setContact(contact);
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setActivity")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String activityType = args.get(2).toString();
                        String description = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.setActivity(LinphonePlugin.getPresenceActivityType(activityType), description);
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNthActivity")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long index = args.getLong(2);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceActivity presenceActivity = presenceModel.getNthActivity(index);
                                if (presenceActivity != null) {
                                    JSONObject resultJSON = LinphonePlugin.getPresenceActivityJsonObject(presenceActivity);
                                    command.success(resultJSON);
                                } else {
                                    command.error(PRESENCE_ACTIVITY_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addActivity")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String presenceActivityType = args.get(2).toString();
                        String description = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceActivityType type = LinphonePlugin.getPresenceActivityType(presenceActivityType);
                                PresenceActivity presenceActivity = new TTPresenceActivity(type, description);
                                presenceModel.addActivity(presenceActivity);
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearActivities")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.clearActivities();
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNote")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String lang = args.get(2).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceNote presenceNote = presenceModel.getNote(lang);
                                if (presenceNote != null) {
                                    JSONObject resultJSON = LinphonePlugin.getPresenceNoteJsonObject(presenceNote);
                                    command.success(resultJSON);
                                } else {
                                    command.error(PRESENCE_NOTE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addNoteContent")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String noteContent = args.get(2).toString();
                        String lang = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.addNote(noteContent, lang);
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearNotes")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.clearNotes();
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNthService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long index = args.getLong(2);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = presenceModel.getNthService(index);
                                if (presenceService != null) {
                                    JSONObject resultJSON = LinphonePlugin.getPresenceServiceJsonObject(presenceService);
                                    command.success(resultJSON);
                                } else {
                                    command.error(PRESENCE_SERVICE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        String basicStatus = args.get(2).toString();
                        String contact = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = new TTPresenceService(null, LinphonePlugin.getPresenceBasicStatus(basicStatus), contact);
                                presenceModel.addService(presenceService);
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearServices")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.clearServices();
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNthPerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long index = args.getLong(2);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(index);
                                if (presencePerson != null) {
                                    JSONObject resultJSON = LinphonePlugin.getPresencePersonJsonObject(presencePerson);
                                    command.success(resultJSON);
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addPerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = new TTPresencePerson(null);
                                presenceModel.addPerson(presencePerson);
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearPerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                presenceModel.clearPersons();
                                command.success();
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setIdForLinphonePresenceService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long serviceIndex = args.getLong(2);
                        String ID = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = presenceModel.getNthService(serviceIndex);
                                if (presenceService != null) {
                                    presenceService.setId(ID);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_SERVICE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setBasicStatusForLinphonePresenceService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long serviceIndex = args.getLong(2);
                        String basicStatus = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = presenceModel.getNthService(serviceIndex);
                                if (presenceService != null) {
                                    PresenceBasicStatus presenceBasicStatus = LinphonePlugin.getPresenceBasicStatus(basicStatus);
                                    presenceService.setBasicStatus(presenceBasicStatus);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_SERVICE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setContactForLinphonePresenceService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long serviceIndex = args.getLong(2);
                        String contact = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = presenceModel.getNthService(serviceIndex);
                                if (presenceService != null) {
                                    presenceService.setContact(contact);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_SERVICE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNthNoteFromService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long serviceIndex = args.getLong(2);
                        long noteIndex = args.getLong(3);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = presenceModel.getNthService(serviceIndex);
                                if (presenceService != null) {
                                    PresenceNote presenceNote = presenceService.getNthNote(noteIndex);
                                    if (presenceNote != null) {
                                        JSONObject resultJSON = LinphonePlugin.getPresenceNoteJsonObject(presenceNote);
                                        command.success(resultJSON);
                                    } else {
                                        command.error(PRESENCE_NOTE_NOT_FOUND);
                                    }
                                } else {
                                    command.error(PRESENCE_SERVICE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addNoteForLinphonePresenceService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long serviceIndex = args.getLong(2);
                        String content = args.get(3).toString();
                        String lang = args.get(4).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = presenceModel.getNthService(serviceIndex);
                                if (presenceService != null) {
                                    PresenceNote presenceNote = new TTPresenceNote(content, lang);
                                    presenceService.addNote(presenceNote);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_SERVICE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearNotesForLinphonePresenceService")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long serviceIndex = args.getLong(2);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresenceService presenceService = presenceModel.getNthService(serviceIndex);
                                if (presenceService != null) {
                                    presenceService.clearNotes();
                                    command.success();
                                } else {
                                    command.error(PRESENCE_SERVICE_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("setIdForLinphonePresencePerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);
                        String ID = args.get(3).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    presencePerson.setId(ID);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNthActivityForLinphonePresencePerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);
                        long activityIndex = args.getLong(3);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    PresenceActivity presenceActivity = presencePerson.getNthActivity(activityIndex);
                                    if (presenceActivity != null) {
                                        JSONObject resultJSON = LinphonePlugin.getPresenceActivityJsonObject(presenceActivity);
                                        command.success(resultJSON);
                                    } else {
                                        command.error(PRESENCE_ACTIVITY_NOT_FOUND);
                                    }
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addActivityForLinphonePresencePerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);
                        String presenceActivityType = args.get(3).toString();
                        String description = args.get(4).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    PresenceActivityType type= LinphonePlugin.getPresenceActivityType(presenceActivityType);
                                    PresenceActivity presenceActivity = new TTPresenceActivity(type, description);
                                    presencePerson.addActivity(presenceActivity);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearActivitiesForLinphonePresencePerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    presencePerson.clearActivities();
                                    command.success();
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNthNoteFromPerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);
                        long noteIndex = args.getLong(3);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    PresenceNote presenceNote = presencePerson.getNthNote(noteIndex);
                                    if (presenceNote != null) {
                                        JSONObject resultJSON = LinphonePlugin.getPresenceNoteJsonObject(presenceNote);
                                        command.success(resultJSON);
                                    } else {
                                        command.error(PRESENCE_NOTE_NOT_FOUND);
                                    }
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addNoteForLinphonePresencePerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);
                        String content = args.get(3).toString();
                        String lang = args.get(4).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    PresenceNote presenceNote = new TTPresenceNote(content, lang);
                                    presencePerson.addNote(presenceNote);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearNotesForLinphonePresencePerson")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    presencePerson.clearNotes();
                                    command.success();
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("getNthActivitiesNote")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);
                        long noteIndex = args.getLong(3);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    PresenceNote presenceNote = presencePerson.getNthActivitiesNote(noteIndex);
                                    if (presenceNote != null) {
                                        JSONObject resultJSON = LinphonePlugin.getPresenceNoteJsonObject(presenceNote);
                                        command.success(resultJSON);
                                    } else {
                                        command.error(PRESENCE_NOTE_NOT_FOUND);
                                    }
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("addActivitiesNote")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);
                        String content = args.get(3).toString();
                        String lang = args.get(4).toString();

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    PresenceNote presenceNote = new TTPresenceNote(content, lang);
                                    presencePerson.addActivitiesNote(presenceNote);
                                    command.success();
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
                else if (action.equals("clearActivitiesNotes")) {
                    try {
                        String username = args.get(0).toString();
                        String domain = args.get(1).toString();
                        long personIndex = args.getLong(2);

                        LinphoneFriend friend = LinphoneHelper.findFriend(username, domain);
                        if (friend != null) {
                            PresenceModel presenceModel = friend.getPresenceModel();
                            if (presenceModel != null) {
                                PresencePerson presencePerson = presenceModel.getNthPerson(personIndex);
                                if (presencePerson != null) {
                                    presencePerson.clearActivitesNotes();
                                    command.success();
                                } else {
                                    command.error(PRESENCE_PERSON_NOT_FOUND);
                                }
                            } else {
                                command.error(PRESENCE_MODEL_NOT_FOUND);
                            }

                        } else {
                            command.error(FRIEND_NOT_FOUND);
                        }
                    } catch (JSONException e) {
                        command.error(WRONG_ARGUMENTS);
                    }
                }
            }
        });

        return true;
    }

    private static LinphoneCore.AdaptiveRateAlgorithm getAdaptiveRateAlgorithm(String algorithm) {
        if ("Simple".equals(algorithm)) {
            return LinphoneCore.AdaptiveRateAlgorithm.Simple;
        } else if ("Stateful".equals(algorithm)) {
            return LinphoneCore.AdaptiveRateAlgorithm.Stateful;
        }
        return null;
    }

    private static PayloadType[] getCodecList(String codecListString) {
        return new PayloadType[0];//TODO
    }

    private static String getAdaptiveRateAlgorithmString(LinphoneCore.AdaptiveRateAlgorithm algorithm) {
        if (algorithm == LinphoneCore.AdaptiveRateAlgorithm.Simple) {
            return "Simple";
        } else if (algorithm == LinphoneCore.AdaptiveRateAlgorithm.Stateful) {
            return "Stateful";
        }
        return null;
    }

    private static String getMediaEncryptionString(LinphoneCore.MediaEncryption mediaEncryption) {
        if (mediaEncryption == LinphoneCore.MediaEncryption.None) {
            return "MediaEncryptionNone";
        } else if (mediaEncryption == LinphoneCore.MediaEncryption.SRTP) {
            return "MediaEncryptionSRTP";
        } else if (mediaEncryption == LinphoneCore.MediaEncryption.ZRTP) {
            return "MediaEncryptionZRTP";
        } else if (mediaEncryption == LinphoneCore.MediaEncryption.DTLS) {
            return "MediaEncryptionDTLS";
        }
        return null;
    }

    private static Reason getReason(String reason) {
        if ("ReasonNone".equals(reason)) {
            return Reason.None;
        } else if ("ReasonNoResponse".equals(reason)) {
            return Reason.NoResponse;
//        } else if ("ReasonForbidden".equals(reason)) { TODO
//            return Reason.;
        } else if ("ReasonDeclined".equals(reason)) {
            return Reason.Declined;
        } else if ("ReasonNotFound".equals(reason)) {
            return Reason.NotFound;
        } else if ("ReasonNotAnswered".equals(reason)) {
            return Reason.NotAnswered;
        } else if ("ReasonBusy".equals(reason)) {
            return Reason.Busy;
//        } else if ("ReasonUnsupportedContent".equals(reason)) { TODO
//            return Reason.Un;
        } else if ("ReasonIOError".equals(reason)) {
            return Reason.IOError;
        } else if ("ReasonDoNotDisturb".equals(reason)) {
            return Reason.DoNotDisturb;
        } else if ("ReasonUnauthorized".equals(reason)) {
            return Reason.Unauthorized;
        } else if ("ReasonNotAcceptable".equals(reason)) {
            return Reason.NotAcceptable;
        } else if ("ReasonNoMatch".equals(reason)) {
            return Reason.NoMatch;
        } else if ("ReasonMovedPermanently".equals(reason)) {
            return Reason.MovedPermanently;
        } else if ("ReasonGone".equals(reason)) {
            return Reason.Gone;
        } else if ("ReasonTemporarilyUnavailable".equals(reason)) {
            return Reason.TemporarilyUnavailable;
        } else if ("ReasonAddressIncomplete".equals(reason)) {
            return Reason.AddressIncomplete;
        } else if ("ReasonNotImplemented".equals(reason)) {
            return Reason.NotImplemented;
        } else if ("ReasonBadGateway".equals(reason)) {
            return Reason.BadGateway;
        } else if ("ReasonServerTimeout".equals(reason)) {
            return Reason.ServerTimeout;
        } else if ("ReasonUnknown".equals(reason)) {
            return Reason.Unknown;
        }
        return null;
    }


    private static JSONObject getChatMessageJsonObject(LinphoneChatMessage chatMessage) {
        JSONObject result = new JSONObject();
        try {
            result.put("isRead", chatMessage.isRead());
            result.put("isOutgoing", chatMessage.isOutgoing());
            result.put("storageId", chatMessage.getStorageId());
            result.put("storage", ""); //TODO
            result.put("reason", LinphonePlugin.getReasonString(chatMessage.getReason()));
            result.put("fileTransferFilepath", ""); //TODO
            result.put("localAddress$username", "");//TODO
            result.put("localAddress$domain", "");//TODO
            result.put("peerAddress$username", chatMessage.getPeerAddress().getUserName());
            result.put("peerAddress$domain", chatMessage.getPeerAddress().getDomain());
            result.put("text", chatMessage.getText());
            result.put("appdata", chatMessage.getAppData());
            result.put("time", chatMessage.getTime());
            result.put("chatMessageState", LinphonePlugin.getLinphoneChatMessageStateString(chatMessage.getStatus()));
            result.put("fromAddress$username", chatMessage.getFrom().getUserName());
            result.put("fromAddress$domain", chatMessage.getFrom().getDomain());
            result.put("toAddress.username", chatMessage.getTo().getUserName());
            result.put("toAddress.domain", chatMessage.getTo().getDomain());
            result.put("externalBodyUrl", chatMessage.getExternalBodyUrl());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static String getLinphoneChatMessageStateString(LinphoneChatMessage.State status) {
        if (status == LinphoneChatMessage.State.Idle) {
            return "ChatMessageStateIdle";
        } else if (status == LinphoneChatMessage.State.InProgress) {
            return "ChatMessageStateInProgress";
        } else if (status == LinphoneChatMessage.State.Delivered) {
            return "ChatMessageStateDelivered";
        } else if (status == LinphoneChatMessage.State.NotDelivered) {
            return "ChatMessageStateNotDelivered";
        } else if (status == LinphoneChatMessage.State.FileTransferError) {
            return "ChatMessageStateFileTransferError";
        } else if (status == LinphoneChatMessage.State.FileTransferDone) {
            return "ChatMessageStateFileTransferDone";
        }
        return null;
    }

    private static String getReasonString(Reason reason) {
        if (reason == Reason.None) {
            return "ReasonNone";
        } else if (reason == Reason.NoResponse) {
            return "ReasonNoResponse";
//        } else if (reason == Reason.) { TODO
//            return "ReasonForbidden";
        } else if (reason == Reason.Declined) {
            return "ReasonDeclined";
        } else if (reason == Reason.NotFound) {
            return "ReasonNotFound";
        } else if (reason == Reason.NotAnswered) {
            return "ReasonNotAnswered";
        } else if (reason == Reason.Busy) {
            return "ReasonBusy";
//        } else if (reason == Reason.U) { //TODO
//            return "ReasonUnsupportedContent";
        } else if (reason == Reason.IOError) {
            return "ReasonIOError";
        } else if (reason == Reason.DoNotDisturb) {
            return "ReasonDoNotDisturb";
        } else if (reason == Reason.Unauthorized) {
            return "ReasonUnauthorized";
        } else if (reason == Reason.NotAcceptable) {
            return "ReasonNotAcceptable";
        } else if (reason == Reason.NoMatch) {
            return "ReasonNoMatch";
        } else if (reason == Reason.MovedPermanently) {
            return "ReasonMovedPermanently";
        } else if (reason == Reason.Gone) {
            return "ReasonGone";
        } else if (reason == Reason.TemporarilyUnavailable) {
            return "ReasonTemporarilyUnavailable";
        } else if (reason == Reason.AddressIncomplete) {
            return "ReasonAddressIncomplete";
        } else if (reason == Reason.NotImplemented) {
            return "ReasonNotImplemented";
        } else if (reason == Reason.BadGateway) {
            return "ReasonBadGateway";
        } else if (reason == Reason.ServerTimeout) {
            return "ReasonServerTimeout";
        } else if (reason == Reason.Unknown) {
            return "ReasonUnknown";
        }
        return null;
    }

    private static JSONObject getFriendJsonObject(LinphoneFriend friend) {
        LinphoneCore lc = LinphoneManager.getLc();
        JSONObject result = new JSONObject();
        try {
            result.put("name", friend.getName());
            result.put("subscribesEnable", friend.isSubscribesEnabled());
            result.put("isInList", false); //TODO
            result.put("username", friend.getAddress().getUserName());
            result.put("domain", friend.getAddress().getDomain());
            result.put("subscribePolicy", LinphonePlugin.getSubscribePolicyString(friend.getIncSubscribePolicy()));
            result.put("onlineStatus", ""); //TODO
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static String getSubscribePolicyString(LinphoneFriend.SubscribePolicy incSubscribePolicy) {
        if (incSubscribePolicy == LinphoneFriend.SubscribePolicy.SPAccept) {
            return "SPAccept";
        } else if (incSubscribePolicy == LinphoneFriend.SubscribePolicy.SPDeny) {
            return "SPDeny";
        } else if (incSubscribePolicy == LinphoneFriend.SubscribePolicy.SPWait) {
            return "SPWait";
        }
        return null;
    }

    private static JSONObject getPresenceModelJsonObject(PresenceModel model) {
        JSONObject result = new JSONObject();
        try {
            result.put("timestamp", model.getTimestamp());
            result.put("contact", LinphonePlugin.applyString(model.getContact()));
            result.put("presenceActivityType", LinphonePlugin.getPresenceActivityTypeString(model.getActivity().getType()));
            result.put("activityDescription", LinphonePlugin.applyString(model.getActivity().getDescription()));
            result.put("basicStatus", LinphonePlugin.getPresenceBasicStatusString(model.getBasicStatus()));
            result.put("numberOfServices", model.getNbServices());
            result.put("numberOfPersons", model.getNbPersons());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static String applyString(String string) {
        return string != null ? string : "";
    }

    private static JSONObject getPresenceServiceJsonObject(PresenceService service) {
        JSONObject result = new JSONObject();
        try {
            result.put("basicStatus", LinphonePlugin.getPresenceBasicStatusString(service.getBasicStatus()));
            result.put("contact", LinphonePlugin.applyString(service.getContact()));
            result.put("numberOfNotes", service.getNbNotes());
            result.put("serviceId", service.getId());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static String getPresenceBasicStatusString(PresenceBasicStatus basicStatus) {
        if (basicStatus == PresenceBasicStatus.Open) {
            return "PresenceBasicStatusOpen";
        } else if (basicStatus == PresenceBasicStatus.Closed) {
            return "PresenceBasicStatusClosed";
        }
        return null;
    }

    private static JSONObject getPresencePersonJsonObject(PresencePerson person) {
        JSONObject result = new JSONObject();
        try {
            result.put("personId", person.getId());
            result.put("numberOfActivities", person.getNbActivities());
            result.put("numberOfNotes", person.getNbNotes());
            result.put("numberOfActivitiesNotes", person.getNbActivitiesNotes());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static PresenceBasicStatus getPresenceBasicStatus(String basicStatus) {
        if ("PresenceBasicStatusOpen".equals(basicStatus)) {
            return PresenceBasicStatus.Open;
        } else if ("PresenceBasicStatusClosed".equals(basicStatus)) {
            return PresenceBasicStatus.Closed;
        }
        return null;
    }

    private static JSONObject getPresenceNoteJsonObject(PresenceNote note) {
        JSONObject result = new JSONObject();
        try {
            result.put("lang", note.getLang());
            result.put("content", note.getContent());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static PresenceActivityType getPresenceActivityType(String type) {
        if ("PresenceActivityOffline".equals(type)) {
            return PresenceActivityType.Offline;
        } else if ("PresenceActivityOnline".equals(type)) {
            return PresenceActivityType.Online;
        } else if ("PresenceActivityAppointment".equals(type)) {
            return PresenceActivityType.Appointment;
        } else if ("PresenceActivityAway".equals(type)) {
            return PresenceActivityType.Away;
        } else if ("PresenceActivityBreakfast".equals(type)) {
            return PresenceActivityType.Breakfast;
        } else if ("PresenceActivityBusy".equals(type)) {
            return PresenceActivityType.Busy;
        } else if ("PresenceActivityDinner".equals(type)) {
            return PresenceActivityType.Dinner;
        } else if ("PresenceActivityHoliday".equals(type)) {
            return PresenceActivityType.Holiday;
        } else if ("PresenceActivityInTransit".equals(type)) {
            return PresenceActivityType.InTransit;
        } else if ("PresenceActivityLookingForWork".equals(type)) {
            return PresenceActivityType.LookingForWork;
        } else if ("PresenceActivityLunch".equals(type)) {
            return PresenceActivityType.Lunch;
        } else if ("PresenceActivityMeal".equals(type)) {
            return PresenceActivityType.Meal;
        } else if ("PresenceActivityMeeting".equals(type)) {
            return PresenceActivityType.Meeting;
        } else if ("PresenceActivityOnThePhone".equals(type)) {
            return PresenceActivityType.OnThePhone;
        } else if ("PresenceActivityOther".equals(type)) {
            return PresenceActivityType.Other;
        } else if ("PresenceActivityPerformance".equals(type)) {
            return PresenceActivityType.Performance;
        } else if ("PresenceActivityPermanentAbsence".equals(type)) {
            return PresenceActivityType.PermanentAbsence;
        } else if ("PresenceActivityPlaying".equals(type)) {
            return PresenceActivityType.Playing;
        } else if ("PresenceActivityPresentation".equals(type)) {
            return PresenceActivityType.Presentation;
        } else if ("PresenceActivityShopping".equals(type)) {
            return PresenceActivityType.Shopping;
        } else if ("PresenceActivitySleeping".equals(type)) {
            return PresenceActivityType.Sleeping;
        } else if ("PresenceActivitySpectator".equals(type)) {
            return PresenceActivityType.Spectator;
        } else if ("PresenceActivitySteering".equals(type)) {
            return PresenceActivityType.Steering;
        } else if ("PresenceActivityTravel".equals(type)) {
            return PresenceActivityType.Travel;
        } else if ("PresenceActivityTV".equals(type)) {
            return PresenceActivityType.TV;
        } else if ("PresenceActivityUnknown".equals(type)) {
            return PresenceActivityType.Unknown;
        } else if ("PresenceActivityVacation".equals(type)) {
            return PresenceActivityType.Vacation;
        } else if ("PresenceActivityWorking".equals(type)) {
            return PresenceActivityType.Working;
        } else if ("PresenceActivityWorship".equals(type)) {
            return PresenceActivityType.Worship;
        }
        return null;
    }


    public static JSONObject getCallJsonObject(LinphoneCall call) {
        JSONObject result = new JSONObject();
        try {
            result.put("playVolume", call.getPlayVolume());
            result.put("recordVolume", 0L); // TODO don't know
            result.put("speakerVolumeGain", 0L); // TODO don't know
            result.put("microphoneVolumeGain", 0L); // TODO don't know
            result.put("currentQuality", call.getCurrentQuality());
            result.put("averageQuality", call.getAverageQuality());
            result.put("mediaInProgress", call.mediaInProgress());
            result.put("audioMulticastEnabled", call.getCurrentParamsCopy().audioMulticastEnabled());
            result.put("videoMulticastEnabled", call.getCurrentParamsCopy().videoMulticastEnabled());
            result.put("realtimeTextEnabled", call.getCurrentParamsCopy().realTimeTextEnabled());
            result.put("callId", call.getCallLog().getCallId());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static JSONObject getCallLogJsonObject(LinphoneCallLog callLog) {
        JSONObject result = new JSONObject();
        try {
            LinphoneAddress remoteAddress = LinphoneHelper.getPeerAddress(callLog);
            LinphoneCore lc = LinphoneManager.getLc();

            result.put("fromAddress$username", callLog.getFrom().getUserName());
            result.put("fromAddress$domain", callLog.getFrom().getDomain());
            result.put("toAddress$username", callLog.getTo().getUserName());
            result.put("toAddress$domain", callLog.getTo().getDomain());
            result.put("duration", callLog.getCallDuration());
            result.put("callDir", LinphonePlugin.getCallDirectionString(callLog.getDirection()));
            result.put("callId", callLog.getCallId());
            result.put("quality", 0L); // TODO
            result.put("remoteAddress$username", remoteAddress.getUserName());
            result.put("remoteAddress$domain", remoteAddress.getDomain());
            result.put("startDate", callLog.getStartDate());
            result.put("videoEnabled", lc.isVideoEnabled());
            result.put("wasConference", callLog.wasConference());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static String getCallDirectionString(CallDirection direction) {
        if (direction == CallDirection.Incoming) {
            return "CallIncoming";
        } else if (direction == CallDirection.Outgoing) {
            return "CallOutgoing";
        }
        return null;
    }

    public static JSONObject getCallStatesJsonObject(LinphoneCallStats callStats) {
        JSONObject result = new JSONObject();
        try {
            LinphoneCore lc = LinphoneManager.getLc();
            result.put("senderLossRate", callStats.getSenderLossRate());
            result.put("receiverLossRate", callStats.getReceiverLossRate());
            result.put("downloadBandwidth", callStats.getDownloadBandwidth());
            result.put("uploadBandwidth", callStats.getUploadBandwidth());
            result.put("senderInterarrivalJitter", callStats.getSenderInterarrivalJitter());
            result.put("receiverInterarrivalJitter", callStats.getReceiverInterarrivalJitter());
            result.put("latePacketsCumulativeNumber", callStats.getLatePacketsCumulativeNumber());
            result.put("iceState", LinphonePlugin.getIceStateString(callStats.getIceState()));
            result.put("upnpState", LinphonePlugin.getUpnpStateString(lc.getUpnpState()));
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static JSONObject getPayloadJsonObject(PayloadType payloadType) {
        JSONObject result = new JSONObject();
        try {
            result.put("mimeType", payloadType.getMime());
            result.put("clockRate", payloadType.getRate());
            result.put("channels", 0); // TODO don't know
            result.put("payloadTypeEnabled", LinphoneHelper.getPayloadTypeEnabled(payloadType.getMime(), payloadType.getRate()));
            result.put("isVbr", LinphoneHelper.getPayloadTypeIsVbr(payloadType.getMime(), payloadType.getRate()));
            result.put("bitrate", LinphoneHelper.getPayloadTypeBitrate(payloadType.getMime(), payloadType.getRate()));
            result.put("number", LinphoneHelper.getPayloadTypeNumber(payloadType.getMime(), payloadType.getRate()));
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static JSONObject getChatRoomJsonObject(LinphoneChatRoom chatRoom) {
        JSONObject result = new JSONObject();
        try {
            result.put("isRemoteComposing", chatRoom.isRemoteComposing());
            result.put("unreadMessagesCount", chatRoom.getUnreadMessagesCount());
            result.put("peerUsername", chatRoom.getPeerAddress().getUserName());
            result.put("peerDomain", chatRoom.getPeerAddress().getDomain());
            result.put("callId", LinphonePlugin.getCallIdFromChatRoom(chatRoom));
//            result.put("call", LinphonePlugin.getCallJsonObject(chatRoom.getCall()));
            result.put("historySize", chatRoom.getHistorySize());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    public static String getCallIdFromChatRoom(LinphoneChatRoom chatRoom) {
        if (chatRoom.getCall() != null
                && chatRoom.getCall().getCallLog() != null) {
            return chatRoom.getCall().getCallLog().getCallId();
        }
        return "";
    }

    public static JSONObject getPresenceActivityJsonObject(PresenceActivity activity) {
        JSONObject result = new JSONObject();
        try {
            result.put("presenceActivityType", LinphonePlugin.getPresenceActivityTypeString(activity.getType()));
            result.put("description", activity.getDescription());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return result;
    }

    private static String getPresenceActivityTypeString(PresenceActivityType type) {
        if (type == PresenceActivityType.Offline) {
            return "PresenceActivityOffline";
        } else if (type == PresenceActivityType.Online) {
            return "PresenceActivityOnline";
        } else if (type == PresenceActivityType.Appointment) {
            return "PresenceActivityAppointment";
        } else if (type == PresenceActivityType.Away) {
            return "PresenceActivityAway";
        } else if (type == PresenceActivityType.Breakfast) {
            return "PresenceActivityBreakfast";
        } else if (type == PresenceActivityType.Busy) {
            return "PresenceActivityBusy";
        } else if (type == PresenceActivityType.Dinner) {
            return "PresenceActivityDinner";
        } else if (type == PresenceActivityType.Holiday) {
            return "PresenceActivityHoliday";
        } else if (type == PresenceActivityType.InTransit) {
            return "PresenceActivityInTransit";
        } else if (type == PresenceActivityType.LookingForWork) {
            return "PresenceActivityLookingForWork";
        } else if (type == PresenceActivityType.Lunch) {
            return "PresenceActivityLunch";
        } else if (type == PresenceActivityType.Meal) {
            return "PresenceActivityMeal";
        } else if (type == PresenceActivityType.Meeting) {
            return "PresenceActivityMeeting";
        } else if (type == PresenceActivityType.OnThePhone) {
            return "PresenceActivityOnThePhone";
        } else if (type == PresenceActivityType.Other) {
            return "PresenceActivityOther";
        } else if (type == PresenceActivityType.Performance) {
            return "PresenceActivityPerformance";
        } else if (type == PresenceActivityType.PermanentAbsence) {
            return "PresenceActivityPermanentAbsence";
        } else if (type == PresenceActivityType.Playing) {
            return "PresenceActivityPlaying";
        } else if (type == PresenceActivityType.Presentation) {
            return "PresenceActivityPresentation";
        } else if (type == PresenceActivityType.Shopping) {
            return "PresenceActivityShopping";
        } else if (type == PresenceActivityType.Sleeping) {
            return "PresenceActivitySleeping";
        } else if (type == PresenceActivityType.Spectator) {
            return "PresenceActivitySpectator";
        } else if (type == PresenceActivityType.Steering) {
            return "PresenceActivitySteering";
        } else if (type == PresenceActivityType.Travel) {
            return "PresenceActivityTravel";
        } else if (type == PresenceActivityType.TV) {
            return "PresenceActivityTV";
        } else if (type == PresenceActivityType.Unknown) {
            return "PresenceActivityUnknown";
        } else if (type == PresenceActivityType.Vacation) {
            return "PresenceActivityVacation";
        } else if (type == PresenceActivityType.Working) {
            return "PresenceActivityWorking";
        } else if (type == PresenceActivityType.Worship) {
            return "PresenceActivityWorship";
        }
        return null;
    }

    public static LinphoneCore.FirewallPolicy getFirewallPolicy(String policy) {
        if ("PolicyNoFirewall".equals(policy)) {
            return LinphoneCore.FirewallPolicy.NoFirewall;
        } else if ("PolicyUseNatAddress".equals(policy)) {
            return LinphoneCore.FirewallPolicy.UseNatAddress;
        } else if ("PolicyUseStun".equals(policy)) {
            return LinphoneCore.FirewallPolicy.UseStun;
        } else if ("PolicyUseIce".equals(policy)) {
            return LinphoneCore.FirewallPolicy.UseIce;
        } else if ("PolicyUseUpnp".equals(policy)) {
            return LinphoneCore.FirewallPolicy.UseUpnp;
        }
        return null;
    }

    public static String getIceStateString(LinphoneCallStats.IceState iceState) {
        if (iceState != LinphoneCallStats.IceState.NotActivated) {
            return "IceStateNotActivated";
        } else if (iceState == LinphoneCallStats.IceState.Failed) {
            return "IceStateFailed";
        } else if (iceState == LinphoneCallStats.IceState.InProgress) {
            return "IceStateInProgress";
        } else if (iceState == LinphoneCallStats.IceState.HostConnection) {
            return "IceStateHostConnection";
        } else if (iceState == LinphoneCallStats.IceState.ReflexiveConnection) {
            return "IceStateReflexiveConnection";
        } else if (iceState == LinphoneCallStats.IceState.RelayConnection) {
            return "IceStateRelayConnection";
        }
        return null;
    }

    public static String getUpnpStateString(LinphoneCore.UpnpState upnpState) {
        if (upnpState == LinphoneCore.UpnpState.Idle) {
            return "UpnpStateIdle";
        } else if (upnpState == LinphoneCore.UpnpState.Pending) {
            return "UpnpStatePending";
        } else if (upnpState == LinphoneCore.UpnpState.Adding) {
            return "UpnpStateAdding";
        } else if (upnpState == LinphoneCore.UpnpState.Removing) {
            return "UpnpStateRemoving";
        } else if (upnpState == LinphoneCore.UpnpState.NotAvailable) {
            return "UpnpStateNotAvailable";
        } else if (upnpState == LinphoneCore.UpnpState.Ok) {
            return "UpnpStateOk";
        } else if (upnpState == LinphoneCore.UpnpState.Ko) {
            return "UpnpStateKo";
        } else if (upnpState == LinphoneCore.UpnpState.Blacklisted) {
            return "UpnpStateBlacklisted";
        }
        return null;
    }

    public static String getFirewallPolicyString(LinphoneCore.FirewallPolicy firewallPolicy) {
        if (firewallPolicy == LinphoneCore.FirewallPolicy.NoFirewall) {
            return "PolicyNoFirewall";
        } else if (firewallPolicy == LinphoneCore.FirewallPolicy.UseNatAddress) {
            return "PolicyUseNatAddress";
        } else if (firewallPolicy == LinphoneCore.FirewallPolicy.UseStun) {
            return "PolicyUseStun";
        } else if (firewallPolicy == LinphoneCore.FirewallPolicy.UseIce) {
            return "PolicyUseIce";
        } else if (firewallPolicy == LinphoneCore.FirewallPolicy.UseUpnp) {
            return "PolicyUseUpnp";
        }
        return null;
    }

    public static LinphoneCore.MediaEncryption getMediaEncryption(String mediaEncryption) {
        if ("MediaEncryptionNone".equals(mediaEncryption)) {
            return LinphoneCore.MediaEncryption.None;
        } else if ("MediaEncryptionSRTP".equals(mediaEncryption)) {
            return LinphoneCore.MediaEncryption.SRTP;
        } else if ("MediaEncryptionZRTP".equals(mediaEncryption)) {
            return LinphoneCore.MediaEncryption.ZRTP;
        } else if ("MediaEncryptionDTLS".equals(mediaEncryption)) {
            return LinphoneCore.MediaEncryption.DTLS;
        }
        return null;
    }

    public static String getCallStatusString(LinphoneCallLog.CallStatus status) {
        if (status == LinphoneCallLog.CallStatus.Success) {
            return "CallSuccess";
        } else if (status == LinphoneCallLog.CallStatus.Aborted) {
            return "CallAborted";
        } else if (status == LinphoneCallLog.CallStatus.Missed) {
            return "CallMissed";
        } else if (status == LinphoneCallLog.CallStatus.Declined) {
            return "CallDeclined";
        }
        return null;
    }


}
