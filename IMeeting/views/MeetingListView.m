//
//  MeetingListView.m
//  IMeeting
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingListView.h"

#import "CommonToolkit/CommonToolkit.h"

// MeetingListView extension
@interface MeetingListView ()

// create an new meeting
- (void)createNewMeeting;

@end




@implementation MeetingListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"meeting list view title", nil);
        
        // set right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(createNewMeeting)];
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

- (void)createNewMeeting{
    if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(showContactsSelectViewController)]) {
        [self.viewControllerRef performSelector:@selector(showContactsSelectViewController)];
    }
}

@end
