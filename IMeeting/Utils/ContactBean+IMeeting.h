//
//  ContactBean+IMeeting.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <CommonToolkit/CommonToolkit.h>

// ContactBean IMeeting category
@interface ContactBean (IMeeting)

// contacts list table view conatct select status image
@property (nonatomic, retain) UIImage *selectStatusImg;
// contacts list table view selected contact selected phone number
@property (nonatomic, retain) NSString *selectedPhoneNumber;

@end
