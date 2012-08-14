//
//  ContactsProcessToolbar.h
//  IMeeting
//
//  Created by  on 12-6-28.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommonToolkit/CommonToolkit.h"

#import "ContactsProcessSoftKeyboard.h"

// contacts search toolbar height
#define CONTACTSSEARCH_TOOLBAR_HEIGHT  44.0

// softKeyboard type
typedef enum{
    custom,
    iosSystem
} SoftKeyboardType;


@interface ContactsProcessToolbar : UIView <UITextFieldDelegate, UISoftKeyboardDelegate> {
    // softKeyboard show or hide indicate button
    UIButton *_mSoftKeyboardIndicateBtn;
    // softKeyboard type switch button
    UIButton *_mSoftKeyboardTypeSwitchBtn;
    
    // user input textField
    UITextField *_mUserInputTextField;
    // user input diaplay label
    UITextField *_mInputDiaplayLabel;
    
    // contacts process softKeyboard
    ContactsProcessSoftKeyboard *_mContactsProcessSoftKeyboard;
    
    // softKeyboard type
    SoftKeyboardType _mSoftKeyboardType;
    
    // contacts process softKeyboard show or hide flag
    BOOL _mSoftKeyboardHidden;
    
    // user previous input text dictionary
    // key is softKeyboard type(NSNumber)
    // value is user previous input text(NSString)
    NSMutableDictionary *_mPreviousInputTextDic;
}

@property (nonatomic, readonly) SoftKeyboardType softKeyboardType;

@property (nonatomic, readonly) BOOL softKeyboardHidden;

// get contacts searching parameter
- (NSString *)contactsSearchingParameter;

@end
