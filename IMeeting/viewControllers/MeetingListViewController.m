//
//  MeetingListViewController.m
//  IMeeting
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "MeetingListViewController.h"

#import "MeetingListView.h"

#import "CommonToolkit/CommonToolkit.h"

#import "MeetingDetailInfoViewController.h"
#import "ContactsSelectViewController.h"

// MeetingListViewController extension
@interface MeetingListViewController ()

// show contacts select view controller
- (void)showContactsSelectViewController;

@end




@implementation MeetingListViewController

- (id)init{
    return [self initWithCompatibleView:[[MeetingListView alloc] init]];
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
    // create and init meeting detailInfo list table view controller
    MeetingDetailInfoViewController *_meetingDetailInfoViewController = [[MeetingDetailInfoViewController alloc] init];
    
    // push meeting detailInfo list table view controller to navigation view controller
    [self.navigationController pushViewController:_meetingDetailInfoViewController animated:NO];
    
    // push contacts select view controller to meeting detailInfo list table view controller navigation view controller
    [_meetingDetailInfoViewController.navigationController pushViewController:[[ContactsSelectViewController alloc] init] animated:YES];
}

@end
