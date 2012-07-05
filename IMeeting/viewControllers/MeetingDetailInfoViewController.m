//
//  MeetingDetailInfoViewController.m
//  IMeeting
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingDetailInfoViewController.h"

#import "MeetingDetailInfoContainerView.h"

#import "CommonToolkit/CommonToolkit.h"

#import "ContactsSelectViewController.h"

// MeetingDetailInfoViewController extension
@interface MeetingDetailInfoViewController ()

// show contacts select view controller
- (void)showContactsSelectViewController;

@end




@implementation MeetingDetailInfoViewController

- (id)init{
    return [super initWithCompatibleView:[[MeetingDetailInfoContainerView alloc] init]];
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

- (void)showContactsSelectViewController{
    // create and init contacts select view controller
    ContactsSelectViewController *_contactsSelectViewController = [[ContactsSelectViewController alloc] init];
    
    // set in meeting attendee phone number array
    [_contactsSelectViewController initInMeetingAttendeesPhoneNumbers:[NSArray arrayWithObjects:@"13770662051", @"14751802319", @"13382794516", @"13312345432", nil]];
    
    // push contacts select view controller to navigation view controller
    [self.navigationController pushViewController:_contactsSelectViewController animated:YES];
}

@end
