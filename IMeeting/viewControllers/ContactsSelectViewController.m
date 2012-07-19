//
//  ContactsSelectViewController.m
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsSelectViewController.h"

#import "CommonToolkit/CommonToolkit.h"

#import "ContactsSelectContainerView.h"

// ContactsSelectViewController extension
@interface ContactsSelectViewController ()

// invite new added contacts to meeting with phone number array
- (void) inviteNewAddedContactsToMeeting:(NSArray *)pPhoneNumbers;

@end




@implementation ContactsSelectViewController

- (id)init{
    return [super initWithCompatibleView:[[ContactsSelectContainerView alloc] init]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

// MFMessageComposeViewControllerDelegate methods implemetation
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    // check message compose result
    switch (result) {
        case MessageComposeResultSent:
            // dismiss message compose view controller
            [self dismissModalViewControllerAnimated:YES];
            
            // popup contacts select view controller to meeting detailInfo view controller
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case MessageComposeResultFailed:
            // show send short message failed toast
            [[iToast makeText:NSLocalizedString(@"send short message failed", nil)] show];
            break;
        
        case MessageComposeResultCancelled:
        default:
            // dismiss message compose view controller
            [self dismissModalViewControllerAnimated:YES];
            break;
    }
}

- (void)initInMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers{
    [((ContactsSelectContainerView *)self.view) initInMeetingAttendeesPhoneNumbers:pPhoneNumbers];
}

- (void)initPreinMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers{
    [((ContactsSelectContainerView *)self.view) initPreinMeetingAttendeesPhoneNumbers:pPhoneNumbers];
}

- (void)inviteNewAddedContactsToMeeting:(NSArray *)pPhoneNumbers{
    // check device short sessage service
    if([MFMessageComposeViewController canSendText]){        
        // init message compose view controller
        MFMessageComposeViewController *_smsViewController = [[MFMessageComposeViewController alloc] init];
        
        // set recipients, body and message compose delegate
        _smsViewController.recipients = pPhoneNumbers;
        _smsViewController.body = [NSString stringWithFormat:NSLocalizedString(@"invite contacts message body", nil), /*meeting moderator name*/@"Ares", /*meeting number*/rand()];
        _smsViewController.messageComposeDelegate = self;
        
        // show message compose view controller
        [self presentModalViewController:_smsViewController animated:YES];
    }
    else{
        // show the device can't send message toast
        [[iToast makeText:NSLocalizedString(@"the device can't send short message", nil)] show];
    }
}

@end
