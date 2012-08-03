//
//  ABContactsListView.m
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ABContactsListView.h"

#import "ContactsListTableViewCell.h"

#import "ContactsSelectContainerView.h"

#import "ContactBean+IMeeting.h"

// ContactsListTableView extension
@interface ABContactsListView ()

// add contact for joining meeting action
- (void)addContactForJoiningMeetingAction:(UIButton *)pSender;

// phone numbers select action sheet button clicked event selector
- (void)phoneNumbersSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex;

@end




@implementation ABContactsListView

@synthesize allContactsInfoArrayInABRef = _mAllContactsInfoArrayInABRef;

@synthesize presentContactsInfoArrayRef = _mPresentContactsInfoArrayRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // get all contacts info array from addressBook
        _mAllContactsInfoArrayInABRef = _mPresentContactsInfoArrayRef = [AddressBookManager shareAddressBookManager].allContactsInfoArray;
        
        // set table view dataSource and delegate
        self.dataSource = self;
        self.delegate = self;
        
        // add addressBook changed observer
        [[AddressBookManager shareAddressBookManager] addABChangedObserver:self];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [_mPresentContactsInfoArrayRef count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ContactsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ContactsListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    // get contact bean 
    ContactBean *_contactBean = [_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row];
    
    cell.photoImg = _contactBean.selectStatusImg ? _contactBean.selectStatusImg : CONTACT_DEFAULT_PHOTO;
    cell.displayName = _contactBean.displayName;
    cell.phoneNumbersArray = _contactBean.phoneNumbers;
    cell.phoneNumberMatchingIndexs = [_contactBean.extensionDic objectForKey:PHONENUMBER_MATCHING_INDEXS];
    cell.nameMatchingIndexs = [_contactBean.extensionDic objectForKey:NAME_MATCHING_INDEXS];
    // add photo image button touchedDown event action
    [cell addImgButtonTarget:self andActionSelector:@selector(addContactForJoiningMeetingAction:)];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // Return the header title in the section.
    return NSLocalizedString(@"contacts list table view section header title", nil);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the height for row at the indexPath.
    return [ContactsListTableViewCell cellHeightWithContact:[_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // set selected cell indexPath
    _mSelectedCellIndexPath = indexPath;
    // set selected row at indexPath select style
    [self selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    // get parent view: contacts select container view
    ContactsSelectContainerView *_contactsSelectContainerView = (ContactsSelectContainerView *)self.superview;
    
    // get the select contact contactBean
    ContactBean *_selectContactBean = [_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row];
    
    // if the select contact not existed in meeting contacts list table view pre in meeting section
    if (![_contactsSelectContainerView.preinMeetingContactsInfoArray containsObject:[_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row]]) {
        // check select contact phone number array
        if (!_selectContactBean.phoneNumbers || 0 == [_selectContactBean.phoneNumbers count]) {
            // show contact has no phone number alertView
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"contact has no phone number alertView title", nil) message:((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row]).displayName delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"contact has no phone number alertView button title", nil), nil] show];
        }
        else if (_selectContactBean.phoneNumbers && 1 == [_selectContactBean.phoneNumbers count]) {
            // add the selected contact with selected phone number to meeting contacts list table view prein meeting section
            [(ContactsSelectContainerView *)self.superview addSelectedContactToMeetingWithIndexPath:indexPath andSelectedPhoneNumber:[_selectContactBean.phoneNumbers objectAtIndex:[_selectContactBean.phoneNumbers count] - 1]];
        }
        else {
            // select the selected contact phone number in his phone number array
            UIActionSheet *_phoneNumbersSelectActionSheet = [[UIActionSheet alloc] initWithContent:_selectContactBean.phoneNumbers andTitleFormat:NSLocalizedString(@"contact phone number select actionSheet title", nil), _selectContactBean.displayName];
            // set actionSheet processor and button clicked event selector
            _phoneNumbersSelectActionSheet.processor = self;
            _phoneNumbersSelectActionSheet.buttonClickedEventSelector = @selector(phoneNumbersSelectActionSheet:clickedButtonAtIndex:);
            // show actionSheet
            [_phoneNumbersSelectActionSheet showInView:tableView];
            
            // return immediately
            return;
        }
    }
    // the select contact existed in meeting contacts list table view prein meeting section, remove it
    else {
        // traverse prein meeting section all contacts
        for (NSInteger _index = 0; _index < [_contactsSelectContainerView.preinMeetingContactsInfoArray count]; _index++) {
            // compare contact id in present contacts info array with each contact which in meeting contacts list table view prein meeting contacts info array
            if (((ContactBean *)[_contactsSelectContainerView.preinMeetingContactsInfoArray objectAtIndex:_index]).id == ((ContactBean *)[_mPresentContactsInfoArrayRef objectAtIndex:indexPath.row]).id) {
                // remove the selected contact from meeting contacts list table view prein meeting sextion
                [(ContactsSelectContainerView *)self.superview removeSelectedContactFromMeetingWithIndexPath:[NSIndexPath indexPathForRow:_index inSection:1]];
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // call parent view method:(void)hideSoftKeyboardWhenBeginScroll
    [((ContactsSelectContainerView *)self.superview) hideSoftKeyboardWhenBeginScroll];
}

- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(NSDictionary *)pInfo context:(void *)pContext{
    if (pInfo && 0 != [pInfo count]) {
        // get changed contact id array
        NSArray *_changedContactIdArr = [pInfo allKeys];
        
        for (NSNumber *_contactId in _changedContactIdArr) {
            // get action
            switch (((NSNumber *)[[pInfo objectForKey:_contactId] objectForKey:CONTACT_ACTION]).intValue) {
                case contactAdd:
                    [self insertRowAtIndexPath:[NSIndexPath indexPathForRow:[_mPresentContactsInfoArrayRef count] - 1 inSection:0] withRowAnimation:UITableViewRowAnimationLeft];
                    break;
                    
                case contactModify:
                    [self reloadRowAtIndexPath:[NSIndexPath indexPathForRow:[_mPresentContactsInfoArrayRef indexOfObject:[[AddressBookManager shareAddressBookManager] getContactInfoById:_contactId.intValue]] inSection:0] withRowAnimation:UITableViewRowAnimationMiddle];
                    break;
                    
                case contactDelete:
                    [self reloadData];
                    break;
            }
        }
    }
}

- (void)addContactForJoiningMeetingAction:(UIButton *)pSender{
    // call self tableView method:(void)tableView: didSelectRowAtIndexPath:
    [self tableView:self didSelectRowAtIndexPath:[self indexPathForCell:(ContactsListTableViewCell *)pSender./*UITableViewCellContentView*/superview./*ContactsListTableViewCell*/superview]];
}

- (void)phoneNumbersSelectActionSheet:(UIActionSheet *)pActionSheet clickedButtonAtIndex:(NSInteger)pButtonIndex{
    // add the selected contact with selected phone number to meeting contacts list table view prein meeting section
    [(ContactsSelectContainerView *)self.superview addSelectedContactToMeetingWithIndexPath:_mSelectedCellIndexPath andSelectedPhoneNumber:[pActionSheet buttonTitleAtIndex:pButtonIndex]];
}

@end
