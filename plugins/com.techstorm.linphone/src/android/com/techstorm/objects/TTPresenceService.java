package com.techstorm.objects;

import org.linphone.core.PresenceBasicStatus;
import org.linphone.core.PresenceServiceImpl;

/**
 * Created by thien on 5/29/16.
 */
public class TTPresenceService extends PresenceServiceImpl {

    public TTPresenceService(String id, PresenceBasicStatus status, String contact) {
        super(id, status, contact);
    }

}
