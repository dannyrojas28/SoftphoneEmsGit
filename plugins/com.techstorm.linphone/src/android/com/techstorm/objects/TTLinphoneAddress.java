package com.techstorm.objects;

import org.linphone.core.LinphoneAddressImpl;
import org.linphone.core.LinphoneCoreException;

/**
 * Created by thien on 5/29/16.
 */
public class TTLinphoneAddress extends LinphoneAddressImpl {

    public TTLinphoneAddress(String identity) throws LinphoneCoreException {
        super(identity);
    }

    public TTLinphoneAddress(String username, String domain, String displayName) throws LinphoneCoreException {
        super(username, domain, displayName);
    }

}
