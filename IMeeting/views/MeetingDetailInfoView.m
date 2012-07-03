//
//  MeetingDetailInfoView.m
//  IMeeting
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingDetailInfoView.h"

#import "CommonToolkit/CommonToolkit.h"

// MeetingDetailInfoView extension
@interface MeetingDetailInfoView ()

// add new meeting attendee from addressBook or user input
- (void)addNewMeetingAttendee;

@end




@implementation MeetingDetailInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"meeting detail info view title", nil);
        
        // set right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"add new meeting attendee", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(addNewMeetingAttendee)];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)addNewMeetingAttendee{
    if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(showContactsSelectViewController)]) {
        [self.viewControllerRef performSelector:@selector(showContactsSelectViewController) withObject:nil];
    }
}

@end
