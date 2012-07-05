//
//  MeetingDetailInfoContainerView.m
//  IMeeting
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingDetailInfoContainerView.h"

#import "CommonToolkit/CommonToolkit.h"

#import "QuartzCore/QuartzCore.h"

// video list view title button frame width
#define VIDEOLISTVIEWTITLEBUTTON_WIDTH  100.0

// MeetingDetailInfoContainerView extension
@interface MeetingDetailInfoContainerView ()

// add new meeting attendee from addressBook or user input
- (void)addNewMeetingAttendee;

@end




@implementation MeetingDetailInfoContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set title
        self.title = NSLocalizedString(@"meeting detail info attendees list view title", nil);
        
        // set title view
        // create and init video list view title button
        UIButton *_videoListViewTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // set frame
        _videoListViewTitleBtn.frame = CGRectMake(0.0, 0.0, VIDEOLISTVIEWTITLEBUTTON_WIDTH, [CommonUtils appNavigationBarHeight]);
        // set title
        [_videoListViewTitleBtn setTitle:NSLocalizedString(@"meeting detail info video view title", nil) forState:UIControlStateNormal];
        // add target
        [_videoListViewTitleBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        // set title view: button
        //self.titleView = _videoListViewTitleBtn;
        
        // set right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMeetingAttendee)];
        
        // get UIScreen bounds
        CGRect _screenBounds = [[UIScreen mainScreen] bounds];
        
        // update meeting detailInfo list container view frame
        self.frame = CGRectMake(_screenBounds.origin.x, _screenBounds.origin.y, _screenBounds.size.width, _screenBounds.size.height - /*statusBar height*/[CommonUtils appStatusBarHeight] - /*navigationBar height*/[CommonUtils appNavigationBarHeight]);
        
        // create and init subviews
        // init meeting video view
        _mMeetingVideoView = [[MeetingVideoView alloc] initWithFrame:self.frame];
        
        // init meeting attendees list table view
        _mMeetingAttendeesListView = [[MeetingAttendeesListView alloc] initWithFrame:/*CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height)*/_mMeetingVideoView.frame];
        // hide first
        _mMeetingAttendeesListView.hidden = YES;
        
        // add meeting video view and meeting attendees list table view to meeting detailInfo view
        [self addSubview:_mMeetingVideoView];
        [self addSubview:_mMeetingAttendeesListView];
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

- (void)IndicateMeetingAttendeesListView{
    // create and init animation
    CATransition *_animation = [CATransition animation];
    // set delegate
    _animation.delegate = self;
    // set duration
    _animation.duration = 0.35;
    // set timing
    _animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    // set type
    _animation.type = kCATransitionPush;
    
    if (_mMeetingAttendeesListView.hidden) {
        // show meeting attendees list table view
        _mMeetingAttendeesListView.hidden = NO;
        // hide title view
        self.titleView.hidden = YES;
        
        // set sub type
        _animation.subtype = kCATransitionFromTop;
    }
    else {
        // hide meeting attendees list table view
        _mMeetingAttendeesListView.hidden = YES;
        // show title view
        self.titleView.hidden = NO;
        
        // set sub type
        _animation.subtype = kCATransitionFromBottom;
    }
    
    // add meeting attendees list table view animation
    [_mMeetingAttendeesListView.layer addAnimation:_animation forKey:@"meetingAttendeesListViewAnimation"]; 
}

- (void)addNewMeetingAttendee{
    if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(showContactsSelectViewController)]) {
        [self.viewControllerRef performSelector:@selector(showContactsSelectViewController)];
    }
}

@end
