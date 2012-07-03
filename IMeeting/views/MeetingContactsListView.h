//
//  MeetingContactsListView.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingContactsListView : UITableView <UITableViewDataSource, UITableViewDelegate>

// in meeting contacts info array reference
@property (nonatomic, readonly) NSArray *inMeetingContactsInfoArrayRef;
// prein meeting contacts info array reference
@property (nonatomic, retain) NSMutableArray *preinMeetingContactsInfoArrayRef;

// in meeting addtendees phone number array(set once, mustn't modify)
@property (nonatomic, retain) NSMutableArray *inMeetingAttendeesPhoneNumberArray;

// prepared for joining meeting contacts phone number array
- (NSArray *)preparedForJoiningMeetingContactsPhoneNumberArray;

@end
