package org.linphone;

/*
PreferencesMigrator.java
Copyright (C) 2013  Belledonne Communications, Grenoble, France

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.Resources;
import android.preference.PreferenceManager;

import com.techstorm.Constants;

import org.linphone.LinphonePreferences.AccountBuilder;
import org.linphone.core.LinphoneCore;
import org.linphone.core.LinphoneCoreException;

/**
 * @author Sylvain Berfini
 */
public class PreferencesMigrator {
	private LinphonePreferences mNewPrefs;
	private SharedPreferences mOldPrefs;
	private Resources mResources;
	
	public PreferencesMigrator(Context context) {
		mNewPrefs = LinphonePreferences.instance();
		mResources = context.getResources();
		mOldPrefs = PreferenceManager.getDefaultSharedPreferences(context);
	}
	
	public boolean isEchoMigratioNeeded() {
		LinphoneCore lc = LinphoneManager.getLcIfManagerNotDestroyedOrNull();
		if (lc == null) {
			return false;
		}
		
		if (mNewPrefs.isEchoConfigurationUpdated()) {
			return false;
		}
		
		return (!lc.needsEchoCalibration() && mNewPrefs.isEchoCancellationEnabled());
	}
	
	public void doEchoMigration() {
		LinphoneCore lc = LinphoneManager.getLcIfManagerNotDestroyedOrNull();
		if (lc == null) {
			return;
		}
		
		if (!lc.needsEchoCalibration()) {
			mNewPrefs.setEchoCancellation(false);
		}
	}
	
	public boolean isMigrationNeeded() {
		int accountNumber = mOldPrefs.getInt(Constants.PREF_EXTRA_ACCOUNTS, -1);
		return accountNumber != -1;
	}
	
	public void doMigration() {
		mNewPrefs.firstLaunchSuccessful(); // If migration is needed, it is safe to assume Linphone has already been started once.
		mNewPrefs.removePreviousVersionAuthInfoRemoval(); // Remove flag in linphonerc asking core not to store auths infos
		
		mNewPrefs.setFrontCamAsDefault(getPrefBoolean(Constants.PREF_VIDEO_USE_FRONT_CAMERA_KEY, true));
		mNewPrefs.setWifiOnlyEnabled(getPrefBoolean(Constants.PREF_WIFI_ONLY_KEY, false));
		mNewPrefs.useRandomPort(getPrefBoolean(Constants.PREF_TRANSPORT_USE_RANDOM_PORTS_KEY, true), false);
		mNewPrefs.setPushNotificationEnabled(getPrefBoolean(Constants.PREF_PUSH_NOTIFICATION_KEY, false));
		mNewPrefs.setPushNotificationRegistrationID(getPrefString(Constants.PUSH_REG_ID_KEY, null));
		mNewPrefs.setDebugEnabled(getPrefBoolean(Constants.PREF_DEBUG_KEY, false));
		mNewPrefs.setBackgroundModeEnabled(getPrefBoolean(Constants.PREF_BACKGROUND_MODE_KEY, true));
		mNewPrefs.setAnimationsEnabled(getPrefBoolean(Constants.PREF_ANIMATION_ENABLE_KEY, false));
		mNewPrefs.setAutoStart(getPrefBoolean(Constants.PREF_AUTOSTART_KEY, false));
		mNewPrefs.setSharingPictureServerUrl(getPrefString(Constants.PREF_IMAGE_SHARING_SERVER_KEY, null));
		mNewPrefs.setRemoteProvisioningUrl(getPrefString(Constants.PREF_REMOTE_PROVISIONING_KEY, null));
		
		doAccountsMigration();
		deleteAllOldPreferences();
	}

	public void migrateRemoteProvisioningUriIfNeeded() {
		String oldUri = mNewPrefs.getConfig().getString("app", "remote_provisioning", null);
		String currentUri = mNewPrefs.getRemoteProvisioningUrl();
		if (oldUri != null && oldUri.length() > 0 && currentUri == null) {
			mNewPrefs.setRemoteProvisioningUrl(oldUri);
			mNewPrefs.getConfig().setString("app", "remote_provisioning", null);
			mNewPrefs.getConfig().sync();
		}
	}

	public void migrateSharingServerUrlIfNeeded() {
		String currentUrl = mNewPrefs.getConfig().getString("app", "sharing_server", null);
		if (currentUrl == null || currentUrl.equals("https://www.linphone.org:444/upload.php")) {
			mNewPrefs.setSharingPictureServerUrl("https://www.linphone.org:444/lft.php");
			mNewPrefs.getConfig().sync();
		}
	}
	
	private void doAccountsMigration() {
		LinphoneCore lc = LinphoneManager.getLcIfManagerNotDestroyedOrNull();
		lc.clearAuthInfos();
		lc.clearProxyConfigs();
		
		for (int i = 0; i < mOldPrefs.getInt(Constants.PREF_EXTRA_ACCOUNTS, 1); i++) {
			doAccountMigration(i, i == getPrefInt(Constants.PREF_DEFAULT_ACCOUNT_KEY, 0));
		}
	}

	private void doAccountMigration(int index, boolean isDefaultAccount) {
		String key = index == 0 ? "" : String.valueOf(index);
		
		String username = getPrefString(Constants.PREF_USERNAME_KEY + key, null);
		String userid = getPrefString(Constants.PREF_AUTH_USERID_KEY + key, null);
		String password = getPrefString(Constants.PREF_PASSWD_KEY + key, null);
		String domain = getPrefString(Constants.PREF_DOMAIN_KEY + key, null);
		if (username != null && username.length() > 0 && password != null) {
			String proxy = getPrefString(Constants.PREF_PROXY_KEY + key, null);
			String expire = getPrefString(Constants.PREF_EXPIRE_KEY, null);

			AccountBuilder builder = new AccountBuilder(LinphoneManager.getLc())
			.setUsername(username)
			.setUserId(userid)
			.setDomain(domain)
			.setPassword(password)
			.setProxy(proxy)
			.setExpires(expire);
			
			if (getPrefBoolean(Constants.PREF_ENABLE_OUTBOUND_PROXY_KEY + key, false)) {
				builder.setOutboundProxyEnabled(true);
			}
			if (Constants.ENABLE_PUSH_ID) {
				String regId = mNewPrefs.getPushNotificationRegistrationID();
				String appId = Constants.PUSH_SENDER_ID;
				if (regId != null && mNewPrefs.isPushNotificationEnabled()) {
					String contactInfos = "app-id=" + appId + ";pn-type=google;pn-tok=" + regId;
					builder.setContactParameters(contactInfos);
				}
			}
			
			try {
				builder.saveNewAccount();
			} catch (LinphoneCoreException e) {
				e.printStackTrace();
			}
			
			if (isDefaultAccount) {
				mNewPrefs.setDefaultAccount(index);
			}
		}
	}

	private void deleteAllOldPreferences() {
		Editor editor = mOldPrefs.edit();
		editor.clear();
		editor.commit();
	}
	
	private String getString(int key) {
		return mResources.getString(key);
	}
	private boolean getPrefBoolean(String key, boolean defaultValue) {
		return mOldPrefs.getBoolean(key, defaultValue);
	}
	private String getPrefString(int key, String defaultValue) {
		return mOldPrefs.getString(mResources.getString(key), defaultValue);
	}
	private int getPrefInt(String key, int defaultValue) {
		return mOldPrefs.getInt(key, defaultValue);
	}
	private String getPrefString(String key, String defaultValue) {
		return mOldPrefs.getString(key, defaultValue);
	}
}
