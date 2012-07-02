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

+ (NSArray *)allInMeetingAttendeePhoneNumberArrayFromServer{
    return [NSArray arrayWithObjects:@"13770662051", @"13382794516", @"18652096792", @"13813005146", @"14751802319", nil];
}

@end
