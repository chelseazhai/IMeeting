//
//  MeetingDetailInfoContainerView.h
//  IMeeting
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MeetingVideoView.h"
#import "MeetingAttendeesListView.h"

@interface MeetingDetailInfoContainerView : UIView {
    // subview meeting video view
    MeetingVideoView *_mMeetingVideoView;
    // subview meeting attendees list table view
    MeetingAttendeesListView *_mMeetingAttendeesListView;
}

// indicate meeting attendees list table view
- (void)IndicateMeetingAttendeesListView;

@end
