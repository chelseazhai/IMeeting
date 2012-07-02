//
//  ContactsSelectViewController.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsSelectViewController : UIViewController

// get all in meeting addendees phone number array from server
+ (NSArray *)allInMeetingAttendeesPhoneNumberArrayFromServer;

@end
