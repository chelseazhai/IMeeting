//
//  ABContactsListView.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABContactsListView : UITableView <UITableViewDataSource, UITableViewDelegate> {
    // all contacts info array in addressBook reference
    NSArray *_mAllContactsInfoArrayInABRef;
    
    // present contacts info array reference
    NSMutableArray *_mPresentContactsInfoArrayRef;
    
    // selected cell indexPath
    NSIndexPath *_mSelectedCellIndexPath;
}

@property (nonatomic, readonly) NSArray *allContactsInfoArrayInABRef;

@property (nonatomic, retain) NSMutableArray *presentContactsInfoArrayRef;

@end
