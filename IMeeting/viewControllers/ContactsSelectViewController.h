//
//  ContactsSelectViewController.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsSelectViewController : UIViewController

// init in meeting contacts list table view in meeting contacts info array
- (void)initInMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers;

@end
