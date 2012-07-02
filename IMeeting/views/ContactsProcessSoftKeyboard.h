//
//  ContactsProcessSoftKeyboard.h
//  IMeeting
//
//  Created by  on 12-6-28.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <CommonToolkit/CommonToolkit.h>

// contacts process softKeyboard height
#define CONTACTSPROCESS_SOFTKEYBOARD_HEIGHT 215.0

// contacts process softKeyboard background color
#define CONTACTSPROCESS_SOFTKEYBOARD_BACKGROUND_COLOR   [UIColor colorWithIntegerRed:45 integerGreen:54 integerBlue:66 alpha:1.0]
// contacts process softKeyboard front color
#define CONTACTSPROCESS_SOFTKEYBOARD_FRONT_COLOR    [UIColor colorWithIntegerRed:136 integerGreen:155 integerBlue:179 alpha:1.0]

@interface ContactsProcessSoftKeyboard : UISoftKeyboard <UISoftKeyboardDataSource>

@end
