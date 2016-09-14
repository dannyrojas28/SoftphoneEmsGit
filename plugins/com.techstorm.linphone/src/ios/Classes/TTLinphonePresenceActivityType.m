//
//  TTLinphonePresenceActivityType.m
//  HelloCordova
//
//  Created by Thien on 5/19/16.
//
//

#import "TTLinphonePresenceActivityType.h"

@implementation TTLinphonePresenceActivityType

-(void) parseLinphonePresenceActivityType:(LinphonePresenceActivityType)linphonePresenceActivityType {
    if (linphonePresenceActivityType == LinphonePresenceActivityOffline) {
        self.presenceActivityType = @"PresenceActivityOffline";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityOnline) {
        self.presenceActivityType = @"PresenceActivityOnline";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityAppointment) {
        self.presenceActivityType = @"PresenceActivityAppointment";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityAway) {
        self.presenceActivityType = @"PresenceActivityAway";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityBreakfast) {
        self.presenceActivityType = @"PresenceActivityBreakfast";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityBusy) {
        self.presenceActivityType = @"PresenceActivityBusy";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityDinner) {
        self.presenceActivityType = @"PresenceActivityDinner";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityHoliday) {
        self.presenceActivityType = @"PresenceActivityHoliday";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityInTransit) {
        self.presenceActivityType = @"PresenceActivityInTransit";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityLookingForWork) {
        self.presenceActivityType = @"PresenceActivityLookingForWork";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityLunch) {
        self.presenceActivityType = @"PresenceActivityLunch";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityMeal) {
        self.presenceActivityType = @"PresenceActivityMeal";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityMeeting) {
        self.presenceActivityType = @"PresenceActivityMeeting";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityOnThePhone) {
        self.presenceActivityType = @"PresenceActivityOnThePhone";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityOther) {
        self.presenceActivityType = @"PresenceActivityOther";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityPerformance) {
        self.presenceActivityType = @"PresenceActivityPerformance";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityPermanentAbsence) {
        self.presenceActivityType = @"PresenceActivityPermanentAbsence";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityPlaying) {
        self.presenceActivityType = @"PresenceActivityPlaying";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityPresentation) {
        self.presenceActivityType = @"PresenceActivityPresentation";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityShopping) {
        self.presenceActivityType = @"PresenceActivityShopping";
    } else if (linphonePresenceActivityType == LinphonePresenceActivitySleeping) {
        self.presenceActivityType = @"PresenceActivitySleeping";
    } else if (linphonePresenceActivityType == LinphonePresenceActivitySpectator) {
        self.presenceActivityType = @"PresenceActivitySpectator";
    } else if (linphonePresenceActivityType == LinphonePresenceActivitySteering) {
        self.presenceActivityType = @"PresenceActivitySteering";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityTravel) {
        self.presenceActivityType = @"PresenceActivityTravel";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityTV) {
        self.presenceActivityType = @"PresenceActivityTV";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityUnknown) {
        self.presenceActivityType = @"PresenceActivityUnknown";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityVacation) {
        self.presenceActivityType = @"PresenceActivityVacation";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityWorking) {
        self.presenceActivityType = @"PresenceActivityWorking";
    } else if (linphonePresenceActivityType == LinphonePresenceActivityWorship) {
        self.presenceActivityType = @"PresenceActivityWorship";
    }
    
}

+(LinphonePresenceActivityType)getLinphonePresenceActivityTypeWithString:(NSString*)linphonePresenceActivityTypeString {
    if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityOffline"]) {
        return LinphonePresenceActivityOffline;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityOnline"]) {
        return LinphonePresenceActivityOnline;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityAppointment"]) {
        return LinphonePresenceActivityAppointment;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityAway"]) {
        return LinphonePresenceActivityAway;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityBreakfast"]) {
        return LinphonePresenceActivityBreakfast;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityBusy"]) {
        return LinphonePresenceActivityBusy;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityDinner"]) {
        return LinphonePresenceActivityDinner;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityHoliday"]) {
        return LinphonePresenceActivityHoliday;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityInTransit"]) {
        return LinphonePresenceActivityInTransit;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityLookingForWork"]) {
        return LinphonePresenceActivityLookingForWork;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityLunch"]) {
        return LinphonePresenceActivityLunch;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityMeal"]) {
        return LinphonePresenceActivityMeal;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityMeeting"]) {
        return LinphonePresenceActivityMeeting;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityOnThePhone"]) {
        return LinphonePresenceActivityOnThePhone;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityOther"]) {
        return LinphonePresenceActivityOther;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityPerformance"]) {
        return LinphonePresenceActivityPerformance;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityPermanentAbsence"]) {
        return LinphonePresenceActivityPermanentAbsence;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityPlaying"]) {
        return LinphonePresenceActivityPlaying;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityPresentation"]) {
        return LinphonePresenceActivityPresentation;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityShopping"]) {
        return LinphonePresenceActivityShopping;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivitySleeping"]) {
        return LinphonePresenceActivitySleeping;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivitySpectator"]) {
        return LinphonePresenceActivitySpectator;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivitySteering"]) {
        return LinphonePresenceActivitySteering;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityTravel"]) {
        return LinphonePresenceActivityTravel;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityTV"]) {
        return LinphonePresenceActivityTV;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityUnknown"]) {
        return LinphonePresenceActivityUnknown;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityVacation"]) {
        return LinphonePresenceActivityVacation;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityWorking"]) {
        return LinphonePresenceActivityWorking;
    } else if ([linphonePresenceActivityTypeString isEqualToString:@"PresenceActivityWorship"]) {
        return LinphonePresenceActivityWorship;
    }
    return NULL;
}

@end
