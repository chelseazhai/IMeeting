//
//  ContactsListTableViewCell.m
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsListTableViewCell.h"

// tableViewCell margin
#define MARGIN  2.0
// tableViewCell photo image view margin
#define PHOTOIMAGEVIEW_MARGIN    5.0
// tableViewCell padding
#define PADDING 2.0

// photo image view height
#define PHOTOIMGVIEW_HEIGHT  30.0
// full name label height
#define DISPLAYNAMELABEL_HEIGHT 20.0
// phone numbers label default height
#define PHONENUMBERSLABEL_DEFAULTHEIGHT   18.0

@implementation ContactsListTableViewCell

@synthesize photoImg = _photoImg;
@synthesize displayName = _displayName;
@synthesize phoneNumbersArray = _phoneNumbersArray;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // init contentView subViews
        // contact photo image view
        _mPhotoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN + PHOTOIMAGEVIEW_MARGIN, MARGIN + PHOTOIMAGEVIEW_MARGIN, PHOTOIMGVIEW_HEIGHT, PHOTOIMGVIEW_HEIGHT)];
        // add to content view
        [self.contentView addSubview:_mPhotoImgView];
        
        // contact display name label
        _mDisplayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mPhotoImgView.frame.origin.x + _mPhotoImgView.frame.size.width + PADDING + PHOTOIMAGEVIEW_MARGIN, MARGIN, self.frame.size.width / 2 - MARGIN - (_mPhotoImgView.frame.size.width + PADDING), DISPLAYNAMELABEL_HEIGHT)];
        // set text font
        _mDisplayNameLabel.font = [UIFont boldSystemFontOfSize:18.0];
        // add to content view
        [self.contentView addSubview:_mDisplayNameLabel];
        
        // contact phone numbers label
        _mPhoneNumbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mDisplayNameLabel.frame.origin.x, _mDisplayNameLabel.frame.origin.y + _mDisplayNameLabel.frame.size.height + PADDING, _mDisplayNameLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT)];
        // set text color and font
        _mPhoneNumbersLabel.textColor = [UIColor lightGrayColor];
        _mPhoneNumbersLabel.font = [UIFont systemFontOfSize:14.0];
        // add to content view
        [self.contentView addSubview:_mPhoneNumbersLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhotoImg:(UIImage *)photoImg{
    // set photo image
    _photoImg = photoImg;
    
    // check photo image
    if (photoImg) {
        // set photo image view image
        _mPhotoImgView.image = photoImg;
    }
    else {
        // recover photo image view default photo image
        //_mPhotoImgView.image = CONTACT_DEFAULT_PHOTO;
        
        /*
        NSLog(@"nil photo image");
        
        // remove from content view
        [_mPhotoImgView removeFromSuperview];
        
        // update contact display name label and contact phone numbers label frame
        _mDisplayNameLabel.frame = CGRectMake(_mPhotoImgView.frame.origin.x, _mDisplayNameLabel.frame.origin.y, self.frame.size.width / 2 - MARGIN - PADDING, DISPLAYNAMELABEL_HEIGHT);
        _mPhoneNumbersLabel.frame = CGRectMake(_mDisplayNameLabel.frame.origin.x, _mPhoneNumbersLabel.frame.origin.y, _mDisplayNameLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT);
         */
    }
}

- (void)setDisplayName:(NSString *)displayName{
    // set display name text
    _displayName = displayName;
    
    // set full name label text
    _mDisplayNameLabel.text = displayName;
}

- (void)setPhoneNumbersArray:(NSArray *)phoneNumbersArray{
    // set phone number array
    _phoneNumbersArray = phoneNumbersArray;
    
    // set phone number label number of lines
    _mPhoneNumbersLabel.numberOfLines = ([phoneNumbersArray count] == 0) ? 1 : [phoneNumbersArray count];
    
    // update phone number label frame
    _mPhoneNumbersLabel.frame = CGRectMake(_mDisplayNameLabel.frame.origin.x, _mDisplayNameLabel.frame.origin.y + _mDisplayNameLabel.frame.size.height + PADDING, _mDisplayNameLabel.frame.size.width, PHONENUMBERSLABEL_DEFAULTHEIGHT * _mPhoneNumbersLabel.numberOfLines);
    
    // set phone number label text
    _mPhoneNumbersLabel.text = [phoneNumbersArray getContactPhoneNumbersDisplayTextWithStyle:vertical];
}

+ (CGFloat)cellHeightWithContact:(ContactBean *)pContact{
    // set contacts list TableViewCell default height
    CGFloat _ret = 2 * /*top margin*/MARGIN + 4.0 / 3 * /*photo image view height*/PHOTOIMGVIEW_HEIGHT;
    
    // check phone numbers
    if (pContact.phoneNumbers && [pContact.phoneNumbers count] > 1) {
        _ret += ([pContact.phoneNumbers count] - 1) * PHONENUMBERSLABEL_DEFAULTHEIGHT;
    }
    
    return _ret;
}

@end
