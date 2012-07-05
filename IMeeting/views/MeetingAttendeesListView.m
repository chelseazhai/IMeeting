//
//  MeetingAttendeesListView.m
//  IMeeting
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingAttendeesListView.h"

#import "MeetingDetailInfoContainerView.h"

@implementation MeetingAttendeesListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = [UIColor whiteColor];
        
        // set table view delegate
        self.delegate = self;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // check if view scroll to top
    if (scrollView.scrollsToTop && !_mScrollingToTop && scrollView.contentOffset.y < _mDraggingBeginContentOffset.y) {
        // update scrolling to top flag
        _mScrollingToTop = YES;
        
        // hide meeting attendees list table view
        [(MeetingDetailInfoContainerView *)self.superview IndicateMeetingAttendeesListView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // set gragging begin content offset
    _mDraggingBeginContentOffset = scrollView.contentOffset;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // update scrolling to top flag
    _mScrollingToTop = NO;
}

@end
