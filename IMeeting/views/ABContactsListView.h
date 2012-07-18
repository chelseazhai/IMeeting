//
//  ABContactsListView.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonToolkit/CommonToolkit.h"

@interface ABContactsListView : UITableView <UITableViewDataSource, UITableViewDelegate, AddressBookChangedDelegate> {
    // all contacts info array in addressBook reference
    NSMutableArray *_mAllContactsInfoArrayInABRef;
    
    // present contacts info array reference
    NSMutableArray *_mPresentContactsInfoArrayRef;
    
    // selected cell indexPath
    NSIndexPath *_mSelectedCellIndexPath;
}

@property (nonatomic, readonly) NSMutableArray *allContactsInfoArrayInABRef;

@property (nonatomic, retain) NSMutableArray *presentContactsInfoArrayRef;

@end
