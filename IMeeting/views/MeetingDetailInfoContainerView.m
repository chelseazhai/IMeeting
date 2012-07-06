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
#define VIDEOLISTVIEWTITLEBUTTON_WIDTH  120.0

// meeting detailInfo view right bar button item array
#define RIGHTBARBUTTONITEMSARRAY    [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewMeetingAttendee)], [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"meeting detail info attendees list view right bar button item title", nil) style:UIBarButtonItemStyleDone target:self action:@selector(backToAttendeesListView)], nil]

// MeetingDetailInfoContainerView extension
@interface MeetingDetailInfoContainerView ()

// add new meeting attendee from addressBook or user input
- (void)addNewMeetingAttendee;

// back to meeting attendees list view
- (void)backToAttendeesListView;

// change meeting attendee for watching his video
- (void)changeAttendeeForWatchingVideo;

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
        
        // create and init video list view title view
        _mVideoListViewTitleView = [UIButton buttonWithType:UIButtonTypeCustom];
        // set frame
        _mVideoListViewTitleView.frame = CGRectMake(0.0, 0.0, VIDEOLISTVIEWTITLEBUTTON_WIDTH, [CommonUtils appNavigationBarHeight]);
        // set title
        [_mVideoListViewTitleView setTitle:NSLocalizedString(@"meeting detail info video view title", nil) forState:UIControlStateNormal];
        // set title font
        _mVideoListViewTitleView.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
        // set show touch when hightlighted
        _mVideoListViewTitleView.showsTouchWhenHighlighted = YES;
        // add target
        [_mVideoListViewTitleView addTarget:self action:@selector(changeAttendeeForWatchingVideo) forControlEvents:UIControlEventTouchUpInside];
        
        // set title view
        self.titleView = _mVideoListViewTitleView;
        
        // set right bar button item: back to meeting attendees list view
        self.rightBarButtonItem = [RIGHTBARBUTTONITEMSARRAY objectAtIndex:1];
        
        // get UIScreen bounds
        CGRect _screenBounds = [[UIScreen mainScreen] bounds];
        
        // update meeting detailInfo list container view frame
        self.frame = CGRectMake(_screenBounds.origin.x, _screenBounds.origin.y, _screenBounds.size.width, _screenBounds.size.height - /*statusBar height*/[CommonUtils appStatusBarHeight] - /*navigationBar height*/[CommonUtils appNavigationBarHeight]);
        
        // create and init subviews
        // init meeting video view
        _mMeetingVideoView = [[MeetingVideoView alloc] initWithFrame:self.frame];
        
        // init meeting attendees list table view
        _mMeetingAttendeesListView = [[MeetingAttendeesListView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height)];
        // hide first
        _mMeetingAttendeesListViewHidden = YES;
        
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
    // create and init meeting attendees list view animation
    CATransition *_animationMALV = [CATransition animation];
    // create and init meeting video view animation
    CATransition *_animationMVV = [CATransition animation];
    // set delegate
    _animationMALV.delegate = _animationMVV.delegate = self;
    // set duration
    _animationMALV.duration = _animationMVV.duration = 1.5;
    // set timing
    _animationMALV.timingFunction = _animationMVV.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    // set type
    _animationMALV.type = kCATransitionPush;
    _animationMVV.type = kCATransitionReveal;
    
    if (_mMeetingAttendeesListViewHidden) {
        // set sub type
        _animationMALV.subtype = _animationMVV.subtype = kCATransitionFromTop;
        
        // show meeting attendees list table view
        _mMeetingAttendeesListViewHidden = NO;
        _mMeetingVideoView.center = CGPointMake(_mMeetingVideoView.center.x, _mMeetingVideoView.center.y - self.frame.size.height);
        _mMeetingAttendeesListView.center = self.center;
        
        // update right bar button item
        self.rightBarButtonItem = [RIGHTBARBUTTONITEMSARRAY objectAtIndex:_mMeetingAttendeesListView.hidden];
        // clear title view
        self.titleView = nil;
    }
    else {
        // set sub type
        _animationMALV.subtype = _animationMVV.subtype = kCATransitionFromBottom;
        
        // hide meeting attendees list table view
        _mMeetingAttendeesListViewHidden = YES;
        _mMeetingVideoView.center = self.center;
        _mMeetingAttendeesListView.center = CGPointMake(_mMeetingAttendeesListView.center.x, _mMeetingAttendeesListView.center.y + self.frame.size.height);
        
        // update right bar button item
        self.rightBarButtonItem = [RIGHTBARBUTTONITEMSARRAY objectAtIndex:_mMeetingAttendeesListView.hidden];
        // reset title view
        self.titleView = _mVideoListViewTitleView;
    }
    
    // add meeting attendees list table view animation
    [_mMeetingAttendeesListView.layer addAnimation:_animationMALV forKey:@"meetingAttendeesListViewAnimation"];
    // add meeting video view animation
    [_mMeetingVideoView.layer addAnimation:_animationMVV forKey:@"meetingVideoViewAnimation"];
}

- (void)addNewMeetingAttendee{
    if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(showContactsSelectViewController)]) {
        [self.viewControllerRef performSelector:@selector(showContactsSelectViewController)];
    }
}

- (void)backToAttendeesListView{
    [self IndicateMeetingAttendeesListView]; 
}

- (void)changeAttendeeForWatchingVideo{
    NSLog(@"changeAttendeeForWatchingVideo");
}

@end
