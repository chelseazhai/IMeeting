//
//  ContactsSelectContainerView.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ABContactsListView.h"
#import "MeetingContactsListView.h"
#import "ContactsProcessToolbar.h"

@interface ContactsSelectContainerView : UIView {
    // subview addressBook contacts list table view
    ABContactsListView *_mABContactsListView;
    // subview meeting contacts list table view
    MeetingContactsListView *_mMeetingContactsListView;
    // subview contacts process toolbar
    ContactsProcessToolbar *_mContactsProcessToolbar;
    
    // subview meeting contacts list table view prein meeting contacts info array
    NSMutableArray *_mPreinMeetingContactsInfoArray;
}

@property (nonatomic, readonly) NSMutableArray *preinMeetingContactsInfoArray;

// add the selected contact with indexPath and selected phone number to meeting contacts list table view prein meeting section
- (void)addSelectedContactToMeetingWithIndexPath:(NSIndexPath *)pIndexPath andSelectedPhoneNumber:(NSString *)pSelectedPhoneNumber;

// remove the select contact from meeting contacts list view prein meeting secton if it is in
- (void)removeSelectedContactFromMeetingWithIndexPath:(NSIndexPath *)pIndexPath;

// add contact with user input phone number to meeting contacts list table view prein meeting section
- (void)addContactToMeetingWithPhoneNumber:(NSString *)pPhoneNumber;

// search contact with parameters
- (void)searchContactWithParameter:(NSString *)pParameter;

// hide softKeyboard when contacts list table view will begin dragging
- (void)hideSoftKeyboardWhenBeginScroll;

@end
