//
//  ContactsListTableViewCell.h
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonToolkit/CommonToolkit.h"

// contact default photo
#define CONTACT_DEFAULT_PHOTO [UIImage imageNamed:@"ContactDefault.png"]
// contact selected photo
#define CONTACT_SELECTED_PHOTO [UIImage imageNamed:@"ContactSelected.png"]
// contact prein meeting photo
#define CONTACT_PREINMEETING_PHOTO [UIImage imageNamed:@"ContactPreinMeeting.png"]

@interface ContactsListTableViewCell : UITableViewCell {
    // contact photo imageView photo image
    UIImage *_mPhotoImg;
    // contact display name label text
    NSString *_mDisplayName;
    // contact full name array
    NSArray *_mFullNames;
    // contact phone numbers array
    NSArray *_mPhoneNumbersArray;
    
    // phone number matching index array
    NSArray *_mPhoneNumberMatchingIndexs;
    // name matching index array
    NSArray *_mNameMatchingIndexs;
    
    // contact photo imageButton
    UIButton *_mPhotoImgButton;
    // contact display name label
    UIAttributedLabel *_mDisplayNameLabel;
    // contact phone numbers display label
    UILabel *_mPhoneNumbersLabel;
    // contact phone numbers display attributed label parent view
    UIView *_mPhoneNumbersAttributedLabelParentView;
}

@property (nonatomic, retain) UIImage *photoImg;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSArray *fullNames;
@property (nonatomic, retain) NSArray *phoneNumbersArray;

@property (nonatomic, retain) NSArray *phoneNumberMatchingIndexs;
@property (nonatomic, retain) NSArray *nameMatchingIndexs;

// add target/action for UIControlEventTouchDown event
- (void)addImgButtonTarget:(id)pTarget andActionSelector:(SEL)pSelector;

// get the height of the contacts list tableViewCell with contactBean object
+ (CGFloat)cellHeightWithContact:(ContactBean *)pContact;

@end
