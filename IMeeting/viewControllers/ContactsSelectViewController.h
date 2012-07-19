//
//  ContactsSelectViewController.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface ContactsSelectViewController : UIViewController <MFMessageComposeViewControllerDelegate>

// init in meeting contacts list table view in meeting contacts info array
- (void)initInMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers;

// init in meeting contacts list table view prein meeting contacts info array
- (void)initPreinMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers;

@end
