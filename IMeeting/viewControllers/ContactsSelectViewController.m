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

- (void)initInMeetingAttendeesPhoneNumbers:(NSArray *)pPhoneNumbers{
    [((ContactsSelectContainerView *)self.view) initInMeetingAttendeesPhoneNumbers:pPhoneNumbers];
}

- (void)inviteNewAddedContactsToMeeting:(NSArray *)pPhoneNumbers{
    NSLog(@"invite new added contacts to meeting - phone number array = %@", pPhoneNumbers);
    
    // show toast, test by ares
    iToast *_iToast = [iToast makeText:[NSString stringWithFormat:@"将加入会议的号码为：%@", [pPhoneNumbers getContactPhoneNumbersDisplayTextWithStyle:horizontal]]];
    [_iToast setDuration:iToastDurationLongLong];
    [_iToast show];
}

@end
