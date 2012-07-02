//
//  ContactBean+IMeeting.m
//  IMeeting
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactBean+IMeeting.h"

// selectStatusImg key of extension dictionary
#define SELECTSTATUSIMG_KEY   @"selectStatusImg"
// selectedPhoneNumber key of extension dictionary
#define SELECTEDPHONENUMBER_KEY  @"selectedPhoneNumber"

@implementation ContactBean (IMeeting)

- (void)setSelectStatusImg:(UIImage *)selectStatusImg{
    [[self extensionDic] setObject:selectStatusImg forKey:SELECTSTATUSIMG_KEY];
}

- (UIImage *)selectStatusImg{
    return [[self extensionDic] objectForKey:SELECTSTATUSIMG_KEY];
}

- (void)setSelectedPhoneNumber:(NSString *)selectedPhoneNumber{
    [[self extensionDic] setObject:selectedPhoneNumber forKey:SELECTEDPHONENUMBER_KEY];
}

- (NSString *)selectedPhoneNumber{
    return [[self extensionDic] objectForKey:SELECTEDPHONENUMBER_KEY];
}

@end
