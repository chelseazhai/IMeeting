//
//  MeetingVideoView.m
//  IMeeting
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingVideoView.h"

#import "MeetingDetailInfoContainerView.h"

@implementation MeetingVideoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        
        // set gesture recognizer delegate
        self.viewGestureRecognizerDelegate = self;
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

- (UISwipeGestureRecognizerDirection)swipeDirectionInView:(UIView *)pView{
    return UISwipeGestureRecognizerDirectionUp;
}

- (void)view:(UIView *)pView swipeAtPoint:(CGPoint)pPoint andDirection:(UISwipeGestureRecognizerDirection)pDirection{
    // check swipe direction
    if (UISwipeGestureRecognizerDirectionUp == pDirection) {
        // show meeting attendees list table view
        [(MeetingDetailInfoContainerView *)self.superview IndicateMeetingAttendeesListView];
    }
}

@end
