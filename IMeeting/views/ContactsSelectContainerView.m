//
//  ContactsSelectContainerView.m
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsSelectContainerView.h"

#import "CommonToolkit/CommonToolkit.h"

#import "ContactsListTableViewCell.h"

#import "ContactBean+IMeeting.h"

// middle seperate padding
#define MIDDLE_SEPERATE_PADDING   1.0
// middle seperate color
#define MIDDLE_SEPERATE_COLOR [UIColor colorWithIntegerRed:152 integerGreen:158 integerBlue:164 alpha:1.0]

// ContactsSelectContainerView extension
@interface ContactsSelectContainerView ()

// subview meeting contacts list table view in meeting contacts phone number array
@property (nonatomic, readonly) NSArray *inMeetingContactsPhoneNumberArray;

// add new contact with user input phone number to meeting contacts list table view prein meeting section
- (void)addNewContactToMeetingWithPhoneNumber:(NSString *)pPhoneNumber;

// invite new added contacts to meeting
- (void)inviteNewAddedContactsToMeeting;

@end




@implementation ContactsSelectContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = MIDDLE_SEPERATE_COLOR;
        
        // set title
        self.title = NSLocalizedString(@"contacts select view title", nil);
        
        // set right bar button item
        self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"invite new added contacts to meeting", nil) style:UIBarButtonItemStyleDone target:self action:@selector(inviteNewAddedContactsToMeeting)];
        
        // get UIScreen bounds
        CGRect _screenBounds = [[UIScreen mainScreen] bounds];
        
        // update contacts select container view frame
        self.frame = CGRectMake(_screenBounds.origin.x, _screenBounds.origin.y, _screenBounds.size.width, _screenBounds.size.height - /*statusBar height*/[CommonUtils appStatusBarHeight] - /*navigationBar height*/[CommonUtils appNavigationBarHeight]);
        
        // create and init subviews
        // init addressBook contacts list table view
        _mABContactsListView = [[ABContactsListView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width / 2 - MIDDLE_SEPERATE_PADDING, self.frame.size.height - CONTACTSSEARCH_TOOLBAR_HEIGHT)];
        // init meeting contacts list table view
        _mMeetingContactsListView = [[MeetingContactsListView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 + MIDDLE_SEPERATE_PADDING, _mABContactsListView.frame.origin.y, _mABContactsListView.frame.size.width, _mABContactsListView.frame.size.height)];
        // init contacts process toolbar
        _mContactsProcessToolbar = [[ContactsProcessToolbar alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height - CONTACTSSEARCH_TOOLBAR_HEIGHT, self.frame.size.width, CONTACTSSEARCH_TOOLBAR_HEIGHT)];
        
        // add addressBook contacts list table view, meeting contacts list table view and contacts process toolbar to contacts select view
        [self addSubview:_mABContactsListView];
        [self addSubview:_mMeetingContactsListView];
        [self addSubview:_mContactsProcessToolbar];
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

- (NSMutableArray *)preinMeetingContactsInfoArray{
    return _mMeetingContactsListView.preinMeetingContactsInfoArrayRef;
}

- (void)initInMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers{
    // set meeting contacts list table view in meeting attedees phone number array
    _mMeetingContactsListView.inMeetingAttendeesPhoneNumberArray = [NSMutableArray arrayWithArray:pPhoneNumbers];
}

- (void)initPreinMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers{
    // set meeting contacts list table view prein meeting attedees phone number array
    for (NSString *_phoneNumber in pPhoneNumbers) {
        // generate contact prein meeting attendees(get from server) phone number and add to meeting contacts list table view prein meeting section
        ContactBean *_contact = nil;
        
        // get contacts from addressBook by phone number
        NSArray *_contacts = [[AddressBookManager shareAddressBookManager] getContactByPhoneNumber:_phoneNumber];        
        if ([_contacts count] > 0) {
            // get first
            _contact = [_contacts objectAtIndex:0];
            
            // set contact selected phone number
            _contact.selectedPhoneNumber = _phoneNumber;
            
            // set contact select status image
            _contact.selectStatusImg = CONTACT_SELECTED_PHOTO;
        }
        else {
            // create and init an new contact bean object
            _contact = [[ContactBean alloc] init];
            // set his display name, selected phone number and phone number array
            _contact.displayName = _phoneNumber;
            _contact.selectedPhoneNumber = _phoneNumber;
            _contact.phoneNumbers = [NSArray arrayWithObject:_phoneNumber];
        }
        
        // add contact in meeting contacts list table view prein meeting section
        [_mMeetingContactsListView.preinMeetingContactsInfoArrayRef addObject:_contact];
    }
    
    // meeting contacts list table view reload data
    [_mMeetingContactsListView reloadData];
}

- (void)addSelectedContactToMeetingWithIndexPath:(NSIndexPath *)pIndexPath andSelectedPhoneNumber:(NSString *)pSelectedPhoneNumber{
    // if the select contact not existed in meeting contacts list table view in meeting section
    if (![self.inMeetingContactsPhoneNumberArray containsObject:pSelectedPhoneNumber]) {
        // update selected cell photo image
        ((ContactsListTableViewCell *)[_mABContactsListView cellForRowAtIndexPath:pIndexPath]).photoImg = CONTACT_SELECTED_PHOTO;
        
        // update selected contact select status image
        ((ContactBean *)[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:pIndexPath.row]).selectStatusImg = CONTACT_SELECTED_PHOTO;
        
        // set selected contact selected phone number
        ((ContactBean *)[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:pIndexPath.row]).selectedPhoneNumber = pSelectedPhoneNumber;
        
        // add selected contact to meeting contacts list table view prein meeting section
        [_mMeetingContactsListView.preinMeetingContactsInfoArrayRef addObject:[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:pIndexPath.row]];
        [_mMeetingContactsListView insertRowAtIndexPath:[NSIndexPath indexPathForRow:[_mMeetingContactsListView.preinMeetingContactsInfoArrayRef count] - 1 inSection:_mMeetingContactsListView.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else {
        NSLog(@"Error: the contact had been in the meeting, mustn't add twice");
        
        // show toast
        [[iToast makeText:[NSString stringWithFormat:@"%@ %@", ((ContactBean *)[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:pIndexPath.row]).displayName, NSLocalizedString(@"contact has been in meeting", nil)]] show];
    }
}

- (void)removeSelectedContactFromMeetingWithIndexPath:(NSIndexPath *)pIndexPath{
    // get selected contact indexPath which in addressBook contacts list table view all contacts info array  and present contacts info array
    NSIndexPath *_indexPathOfWhichInAllContactsInfoArray = nil;
    NSIndexPath *_indexPathOfWhichInPresentContactsInfoArray = nil;
    for (NSInteger _index = 0; _index < [_mABContactsListView.allContactsInfoArrayInABRef count]; _index++) {
        // compare contact id which in addressBook contacts list table view all contacts info array with selected contact id
        if (((ContactBean *)[_mABContactsListView.allContactsInfoArrayInABRef objectAtIndex:_index]).id == ((ContactBean *)[_mMeetingContactsListView.preinMeetingContactsInfoArrayRef objectAtIndex:pIndexPath.row]).id) {
            _indexPathOfWhichInAllContactsInfoArray = [NSIndexPath indexPathForRow:_index inSection:0];
            
            // set contact indexPath which in addressBook contacts list table view present contacts info array
            if ([_mABContactsListView.presentContactsInfoArrayRef containsObject:[_mABContactsListView.allContactsInfoArrayInABRef objectAtIndex:_index]]) {
                _indexPathOfWhichInPresentContactsInfoArray= [NSIndexPath indexPathForRow:[_mABContactsListView.presentContactsInfoArrayRef indexOfObject:[_mABContactsListView.allContactsInfoArrayInABRef objectAtIndex:_index]] inSection:0];
            }
            
            break;
        }
    }
    
    // if indexPath not nil, recover image for cell and contact
    // nil is the selected for removing contact is adding provisionally
    if (_indexPathOfWhichInAllContactsInfoArray) {
        // if selected contacts present in addressBook contacts list present contacts info array
        if (_indexPathOfWhichInPresentContactsInfoArray) {
            // recover selected cell photo image
            ((ContactsListTableViewCell *)[_mABContactsListView cellForRowAtIndexPath:_indexPathOfWhichInPresentContactsInfoArray]).photoImg = CONTACT_DEFAULT_PHOTO;
        }
        
        // recover remove contact select status image
        ((ContactBean *)[_mABContactsListView.allContactsInfoArrayInABRef objectAtIndex:_indexPathOfWhichInAllContactsInfoArray.row]).selectStatusImg = CONTACT_DEFAULT_PHOTO;
    }
    else {
        NSLog(@"Info: provisional contact, needn't to recover original contact attributes");
    }
    
    // remove the selected contact from meeting contacts list table view prein meeting section
    [_mMeetingContactsListView.preinMeetingContactsInfoArrayRef removeObjectAtIndex:pIndexPath.row];
    [_mMeetingContactsListView deleteRowAtIndexPath:pIndexPath withRowAnimation:UITableViewRowAnimationTop];
}

- (void)addContactToMeetingWithPhoneNumber:(NSString *)pPhoneNumber{
    // check new added contact phone number
    if (nil == pPhoneNumber || [pPhoneNumber isNil]) {
        NSLog(@"Error: %@ - addContactToMeetingWithPhoneNumber - phone number is nil", NSStringFromClass(self.class));
        
        // show toast
        [[iToast makeText:NSLocalizedString(@"new added phone number is nil", nil)] show];
    }
    else {
        // has searched result
        if ([_mABContactsListView.presentContactsInfoArrayRef count] > 0) {
            // process each result
            for (NSInteger _index = 0; _index < [_mABContactsListView.presentContactsInfoArrayRef count]; _index++) {
                // add searched contact to meeting contacts list table view prein meeting section
                if ([((ContactBean *)[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:_index]).phoneNumbers containsObject:pPhoneNumber] && ![_mMeetingContactsListView.preinMeetingContactsInfoArrayRef containsObject:[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:_index]]) {
                    [self addSelectedContactToMeetingWithIndexPath:[NSIndexPath indexPathForRow:_index inSection:0] andSelectedPhoneNumber:pPhoneNumber];
                }
                // the searched contact has been existed in meeting contacts list table view prein meeting section with another phone number
                else if ([((ContactBean *)[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:_index]).phoneNumbers containsObject:pPhoneNumber]) {
                    NSLog(@"Error: has a contact with user input phone number has been existed in prein meeting");
                    
                    // show toast
                    [[iToast makeText:[NSString stringWithFormat:@"%@ %@", ((ContactBean *)[_mABContactsListView.presentContactsInfoArrayRef objectAtIndex:_index]).displayName, NSLocalizedString(@"contact with user input phone number has been existed in prein meeting", nil)]] show];
                }
                // add the user input phone number to meeting contacts list table view prein meeting section
                else {
                    // generate contact with user input phone number and add to meeting contacts list table view prein meeting section
                    [self addNewContactToMeetingWithPhoneNumber:pPhoneNumber];
                    
                    // add new contact to meeting once, then return immediately
                    break;
                }
            }
        }
        // no result
        else {
            // add the user input phone number to meeting contacts list table view prein meeting section
            // generate contact with user input phone number and add to meeting contacts list table view prein meeting section
            [self addNewContactToMeetingWithPhoneNumber:pPhoneNumber];
        }
    }
}

- (void)searchContactWithParameter:(NSString *)pParameter{
    // check search parameter
    if ([pParameter isEqualToString:@""]) {
        // show all contacts in addressBook
        _mABContactsListView.presentContactsInfoArrayRef = [NSMutableArray arrayWithArray:_mABContactsListView.allContactsInfoArrayInABRef];
    }
    else {
        // define temp array
        NSArray *_tmpArray = nil;
        
        // check softKeyboard type
        switch (_mContactsProcessToolbar.softKeyboardType) {
            case custom:
                // search by phone number
                _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByPhoneNumber:pParameter];
                break;
                
            case iosSystem:
                // search by name
                _tmpArray = [[AddressBookManager shareAddressBookManager] getContactByName:pParameter];
                break;
        }
        
        // define searched contacts array
        NSMutableArray *_searchedContactsArray = [[NSMutableArray alloc] initWithCapacity:[_tmpArray count]];
        
        // compare seached contacts temp array contact with all contacts info array in addressBook contact  
        for (ContactBean *_searchedContact in _tmpArray) {
            for (ContactBean *_contact in _mABContactsListView.allContactsInfoArrayInABRef) {
                // if the two contacts id is equal, add it to searched contacts array
                if (_contact.id == _searchedContact.id) {
                    [_searchedContactsArray addObject:_searchedContact];
                    
                    break;
                }
            }
        }
        
        // set addressBook contacts list view present contacts info array
        _mABContactsListView.presentContactsInfoArrayRef = _searchedContactsArray;
    }
    
    // reload addressBook contacts list table view data
    [_mABContactsListView reloadData];
}

- (void)hideSoftKeyboardWhenBeginScroll{
    // check softKeyboard it is hidden
    if (!_mContactsProcessToolbar.softKeyboardHidden) {
        [_mContactsProcessToolbar performSelector:@selector(indicateSoftKeyboard)];
    }
}

- (NSArray *)inMeetingContactsPhoneNumberArray{
    NSMutableArray *_ret = [[NSMutableArray alloc] initWithCapacity:[_mMeetingContactsListView.inMeetingContactsInfoArrayRef count]];
    
    // generate in meeting contacts phone number array
    for (NSInteger _index = 0; _index < [_mMeetingContactsListView.inMeetingContactsInfoArrayRef count]; _index++) {
        // add contact phone number to return result which in meeting contacts list table view in meeting section
        [_ret addObject:[((ContactBean *)[_mMeetingContactsListView.inMeetingContactsInfoArrayRef objectAtIndex:_index]).phoneNumbers objectAtIndex:0]];
    }
    
    return _ret;
}

- (void)addNewContactToMeetingWithPhoneNumber:(NSString *)pPhoneNumber{
    // compare with all tempelate contacts phone number which in meeting contacts list table in meeting section
    for (ContactBean *_tempContact in _mMeetingContactsListView.preinMeetingContactsInfoArrayRef) {
        if (-1 == _tempContact.id && [pPhoneNumber isEqualToString:[_tempContact.phoneNumbers objectAtIndex:0]]) {
            NSLog(@"new added contact with the phone number has added in meeting contacts list table view in meeting section");
            
            // show toast
            [[iToast makeText:NSLocalizedString(@"new added contact with user input phone number has been existed in prein meeting", nil)] show];
            
            // return immediately
            return;
        }
    }
    
    // generate contact with user input phone number and add to meeting contacts list table view prein meeting section
    ContactBean *_newAddedContact = [[ContactBean alloc] init];
    // set his id, display name, selected phone number and phone number array
    _newAddedContact.id = -1/*tempelate contact*/;
    _newAddedContact.displayName = pPhoneNumber;
    _newAddedContact.selectedPhoneNumber = pPhoneNumber;
    _newAddedContact.phoneNumbers = [NSArray arrayWithObject:pPhoneNumber];
    
    [_mMeetingContactsListView.preinMeetingContactsInfoArrayRef addObject:_newAddedContact];
    [_mMeetingContactsListView insertRowAtIndexPath:[NSIndexPath indexPathForRow:[_mMeetingContactsListView.preinMeetingContactsInfoArrayRef count] - 1 inSection:_mMeetingContactsListView.numberOfSections - 1] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)inviteNewAddedContactsToMeeting{
    // check meeting contacts list table view prepared for joining meeting contacts phone number array
    if (_mMeetingContactsListView.preparedForJoiningMeetingContactsPhoneNumberArray && [_mMeetingContactsListView.preparedForJoiningMeetingContactsPhoneNumberArray count] > 0) {
        // validate view controller and selector implemetation
        if ([self validateViewControllerRef:self.viewControllerRef andSelector:@selector(inviteNewAddedContactsToMeeting:)]) {
            [self.viewControllerRef performSelector:@selector(inviteNewAddedContactsToMeeting:) withObject:_mMeetingContactsListView.preparedForJoiningMeetingContactsPhoneNumberArray];
        }
    }
    else {
        // show no contacts for joining meeting toast
        [[iToast makeText:NSLocalizedString(@"no contacts for joining meeting", nil)] show];
    }
}

@end
