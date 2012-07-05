//
//  MeetingAttendeesListView.h
//  IMeeting
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingAttendeesListView : UITableView <UITableViewDelegate> {
    // meeting attendees list table view scrolling to top
    BOOL _mScrollingToTop;
    
    // gragging begin content offset
    CGPoint _mDraggingBeginContentOffset;
}

@end
