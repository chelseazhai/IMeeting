//
//  MeetingContactsListView.m
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingContactsListView.h"

#import "ContactsListTableViewCell.h"

#import "ContactsSelectContainerView.h"
#import "ContactsSelectViewController.h"

#import "ContactBean+IMeeting.h"

// selction rows number array in meeting contacts list table view
#define SECTION_ROWSNUMBERARRAY_INVIEW    [NSArray arrayWithObjects:[NSNumber numberWithInteger:[_inMeetingContactsInfoArrayRef count]], [NSNumber numberWithInteger:[_preinMeetingContactsInfoArrayRef count]], nil]

// section header title array in meeting contacts list table view
#define SECTION_HEADTITLEARRAY_INVIEW [NSArray arrayWithObjects:NSLocalizedString(@"meeting contacts table view in meeting section header title", nil), NSLocalizedString(@"meeting contacts table view prein meeting section header title", nil), nil]
// contacts info array in meeting contacts list table view
#define CONTACTSINFOARRAY_INVIEW [NSArray arrayWithObjects:_inMeetingContactsInfoArrayRef, _preinMeetingContactsInfoArrayRef, nil]

// MeetingContactsListView extension
@interface MeetingContactsListView ()

// remove prein meeting attendee action
- (void)removePreinMeetingAttendeeAction:(UIButton *)pSender;

@end




@implementation MeetingContactsListView

@synthesize inMeetingContactsInfoArrayRef = _inMeetingContactsInfoArrayRef;
@synthesize preinMeetingContactsInfoArrayRef = _preinMeetingContactsInfoArrayRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // create in meeting contacts info array
        NSMutableArray *_inMeetingContactsInfoArray = [[NSMutableArray alloc] init];
        
        // get all in meeting attendees phone number array from server
        NSArray *_allInMeetingAttendeePhoneNumberArrayFromServer = [ContactsSelectViewController allInMeetingAttendeesPhoneNumberArrayFromServer];
        
        // init in meeting contacts info array
        for (NSInteger _index = 0; _index < [_allInMeetingAttendeePhoneNumberArrayFromServer count]; _index++) {
            ContactBean *_contactBean = [[ContactBean alloc] init];
            _contactBean.displayName = [[[AddressBookManager shareAddressBookManager] contactsDisplayNameArrayWithPhoneNumber:[_allInMeetingAttendeePhoneNumberArrayFromServer objectAtIndex:_index]] objectAtIndex:0];
            _contactBean.phoneNumbers = [NSArray arrayWithObject:[_allInMeetingAttendeePhoneNumberArrayFromServer objectAtIndex:_index]];
            
            [_inMeetingContactsInfoArray addObject:_contactBean];
        }
        
        // init in meeting contacts info array from server and prein meeting contacts info array
        _inMeetingContactsInfoArrayRef = _inMeetingContactsInfoArray;
        _preinMeetingContactsInfoArrayRef = [[NSMutableArray alloc] init];
        
        // set table view dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
        // set editing
        //self.editing = YES;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return ((NSNumber *)[SECTION_ROWSNUMBERARRAY_INVIEW objectAtIndex:section]).integerValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ContactsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ContactsListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // get contact bean
    ContactBean *_contactBean = [[CONTACTSINFOARRAY_INVIEW objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.photoImg = (0 == indexPath.section) ? CONTACT_SELECTED_PHOTO : /*nil*/CONTACT_PREINMEETING_PHOTO;
    cell.displayName = _contactBean.displayName;
    cell.phoneNumbersArray = [NSArray arrayWithObject:_contactBean.selectedPhoneNumber ? _contactBean.selectedPhoneNumber : [_contactBean.phoneNumbers getContactPhoneNumbersDisplayTextWithStyle:horizontal]];
    // add photo image button touchedDown event action
    [cell addImgButtonTarget:self andActionSelector:@selector(removePreinMeetingAttendeeAction:)];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // Return the header title in the section.
    return [SECTION_HEADTITLEARRAY_INVIEW objectAtIndex:section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL _ret = NO;
    
    // in meeting section can editing, in meeting section mustn't editing
    if (1 == indexPath.section) {
        _ret = YES;
    }
    
    return _ret;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // remove the select contact from prein meeting contacts info array if it is in prein meeting section
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [(ContactsSelectContainerView *)self.superview removeSelectedContactFromMeetingWithIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle _ret = UITableViewCellEditingStyleDelete;
    
    // in meeting contact cann't be deleted
    if (0 == indexPath.section) {
        _ret =  UITableViewCellEditingStyleNone;
    }
    
    return _ret;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // call parent view method:(void)hideSoftKeyboardWhenBeginScroll
    [((ContactsSelectContainerView *)self.superview) hideSoftKeyboardWhenBeginScroll];
}

- (void)removePreinMeetingAttendeeAction:(UIButton *)pSender{
    // get select cell indexPath
    NSIndexPath *_indexPath = [self indexPathForCell:(ContactsListTableViewCell *)pSender./*UITableViewCellContentView*/superview./*ContactsListTableViewCell*/superview];
    
    // check attendee is in prein meeting section
    if (0 != _indexPath.section) {
        [(ContactsSelectContainerView *)self.superview removeSelectedContactFromMeetingWithIndexPath:_indexPath];
    }
}

@end
