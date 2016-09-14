package com.techstorm.objects;

import org.linphone.core.PresenceActivityImpl;
import org.linphone.core.PresenceActivityType;

/**
 * Created by thien on 5/29/16.
 */
public class TTPresenceActivity extends PresenceActivityImpl {

    public TTPresenceActivity(PresenceActivityType type, String description) {
        super(type, description);
    }

}
