//
//  ContactsProcessToolbar.m
//  IMeeting
//
//  Created by  on 12-6-28.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsProcessToolbar.h"

#import "ContactsSelectContainerView.h"

// user input text diaplay max font size
#define MAX_CUSTOMBOARD_DISPLAYFONTSIZE    48.0
#define MAX_SYSTEMBOARD_DISPLAYFONTSIZE    32.0

// softKeyboard indicate button and type switch button width
#define INDICATE_TYPESWITCH_BUTTON_WIDTH  40.0

// margin and padding
#define MARGIN  1.0
#define PADDING 1.0

// softKeyboard indicate button title array
#define INDICATEBUTTON_TITLE    [NSArray arrayWithObjects:@"down", @"up", nil]
// softKeyboard type switch button title array
#define TYPESWITCHBUTTON_TITLE  [NSArray arrayWithObjects:@"abc", @"123", nil]

// ContactsSearchToolbar extension
@interface ContactsProcessToolbar ()

// user input text changed
- (void)userInputTextDidChanged:(UITextField *)pTextField;

// show or hide softKeyboard
- (void)indicateSoftKeyboard;

// change softKeyboard type
- (void)changeSoftkeyboardType;

@end




@implementation ContactsProcessToolbar

@synthesize softKeyboardType = _mSoftKeyboardType;

@synthesize softKeyboardHidden = _mSoftKeyboardHidden;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // init user previous input text dictionary
        _mPreviousInputTextDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        // hide softKeyboard first
        _mSoftKeyboardHidden = YES;
        // set softKeyboard default type
        _mSoftKeyboardType = iosSystem;
        
        // save origin frame height and update its frame
        CGFloat _originFrameHeight = frame.size.height;
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _originFrameHeight + CONTACTSPROCESS_SOFTKEYBOARD_HEIGHT);
        
        // set background color
        self.backgroundColor = CONTACTSPROCESS_SOFTKEYBOARD_BACKGROUND_COLOR;
        
        // init subviews and set their attributes
        // iit softKeyboard show or hide indicate button
        _mSoftKeyboardIndicateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // set frame
        _mSoftKeyboardIndicateBtn.frame = CGRectMake(self.bounds.origin.x + MARGIN, self.bounds.origin.y + MARGIN, INDICATE_TYPESWITCH_BUTTON_WIDTH, _originFrameHeight - 2 * MARGIN);
        // set background color
        _mSoftKeyboardIndicateBtn.backgroundColor = CONTACTSPROCESS_SOFTKEYBOARD_FRONT_COLOR;
        // set touch highlighted
        _mSoftKeyboardIndicateBtn.showsTouchWhenHighlighted = YES;
        // set title
        [_mSoftKeyboardIndicateBtn setTitle:[INDICATEBUTTON_TITLE objectAtIndex:_mSoftKeyboardHidden] forState:UIControlStateNormal];
        // add target
        [_mSoftKeyboardIndicateBtn addTarget:self action:@selector(indicateSoftKeyboard) forControlEvents:UIControlEventTouchUpInside];
        
        // init softKeyboard type switch button
        _mSoftKeyboardTypeSwitchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // set frame
        _mSoftKeyboardTypeSwitchBtn.frame = CGRectMake(self.frame.size.width - _mSoftKeyboardIndicateBtn.frame.size.width - MARGIN, _mSoftKeyboardIndicateBtn.frame.origin.y, _mSoftKeyboardIndicateBtn.frame.size.width, _mSoftKeyboardIndicateBtn.frame.size.height);
        // set background color
        _mSoftKeyboardTypeSwitchBtn.backgroundColor = _mSoftKeyboardIndicateBtn.backgroundColor;
        // set touch highlight
        _mSoftKeyboardTypeSwitchBtn.showsTouchWhenHighlighted = YES;
        // set title
        [_mSoftKeyboardTypeSwitchBtn setTitle:[TYPESWITCHBUTTON_TITLE objectAtIndex:_mSoftKeyboardType] forState:UIControlStateNormal];
        // add target
        [_mSoftKeyboardTypeSwitchBtn addTarget:self action:@selector(changeSoftkeyboardType) forControlEvents:UIControlEventTouchUpInside];
        
        // init user input textField
        _mUserInputTextField = [[UITextField alloc] init];
        // set frame
        _mUserInputTextField.frame = CGRectMake(_mSoftKeyboardIndicateBtn.frame.origin.x + _mSoftKeyboardIndicateBtn.frame.size.width + PADDING, _mSoftKeyboardIndicateBtn.frame.origin.y, self.frame.size.width - _mSoftKeyboardIndicateBtn.frame.size.width - _mSoftKeyboardTypeSwitchBtn.frame.size.width - 2 * (MARGIN + PADDING), _mSoftKeyboardIndicateBtn.frame.size.height);
        // set autocorrectionType and autocapitalizationType
        _mUserInputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _mUserInputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        // set text security
        _mUserInputTextField.secureTextEntry = YES;
        // add target
        [_mUserInputTextField addTarget:self action:@selector(userInputTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
        // hide always
        _mUserInputTextField.hidden = YES;
        
        // init user input diaplay view
        _mInputDiaplayLabel = [[UITextField alloc] init];
        // set frame
        _mInputDiaplayLabel.frame = _mUserInputTextField.frame;
        // set background color
        _mInputDiaplayLabel.backgroundColor = CONTACTSPROCESS_SOFTKEYBOARD_FRONT_COLOR;
        // set content verticalAlignment
        _mInputDiaplayLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        // set text properties and font
        _mInputDiaplayLabel.textAlignment = UITextAlignmentCenter;
        _mInputDiaplayLabel.textColor = [UIColor whiteColor];
        _mInputDiaplayLabel.adjustsFontSizeToFitWidth = YES;
        _mInputDiaplayLabel.font = [UIFont boldSystemFontOfSize:MAX_CUSTOMBOARD_DISPLAYFONTSIZE];
        // set delegate
        _mInputDiaplayLabel.delegate = self;
        
        // init contacts process softKeyboard
        _mContactsProcessSoftKeyboard = [[ContactsProcessSoftKeyboard alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.bounds.origin.y + _originFrameHeight - 1.0, self.frame.size.width, CONTACTSPROCESS_SOFTKEYBOARD_HEIGHT + 1.0)];
        // set delegate
        _mContactsProcessSoftKeyboard.delegate = self;
        
        // add softKeyboard indicate button, softKeyboard type switch button, user input text field, user input text diaplay label and contacts process softKeyboard to toolbar
        [self addSubview:_mSoftKeyboardIndicateBtn];
        [self addSubview:_mSoftKeyboardTypeSwitchBtn];
        [self addSubview:_mUserInputTextField];
        [self addSubview:_mInputDiaplayLabel];
        [self addSubview:_mContactsProcessSoftKeyboard];
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

// UITextFieldDelegate methods implemetation
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

// UISoftKeyboardDelegate methods implemetation
- (void)softKeyboard:(UISoftKeyboard *)pSoftKeyboard didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    // get selected cell text
    NSString *_selectedCellFrontViewText = ((UILabel *)[[pSoftKeyboard cellForRowAtIndexPath:indexPath] frontView]).text;
    
    // check softKeyboard cell function according to cell indexPath
    // numeric
    if (indexPath.skb_row < 3 || (indexPath.skb_row == 3 && indexPath.skb_cell == 1)) {
        // set inputDiaplayLabel text for user input with custom softKeyboard
        _mUserInputTextField.text = [NSString stringWithFormat:@"%@%@", nil == _mUserInputTextField.text ? @"" : _mUserInputTextField.text, _selectedCellFrontViewText];
        // manual call method:(void)userInputTextDidChanged:
        [self userInputTextDidChanged:_mUserInputTextField];
    }
    // functionality
    else {
        if (indexPath.skb_row == 3 && indexPath.skb_cell == 0) {
            // add new contact with user input phone number to prein meeting section
            // call parent view method:(void)addContactToMeetingWithPhoneNumber:
            [((ContactsSelectContainerView *)self.superview) addContactToMeetingWithPhoneNumber:_mUserInputTextField.text];
        }
        else if (indexPath.skb_row == 3 && indexPath.skb_cell == 2) {
            // delete
            if (_mUserInputTextField.text && ![[_mUserInputTextField.text trimWhitespaceAndNewline] isEqualToString:@""]) {
                // set inputDiaplayLabel text for user input with custom softKeyboard
                _mUserInputTextField.text = [_mUserInputTextField.text substringToIndex:_mUserInputTextField.text.length - 1];
                // manual call method:(void)userInputTextDidChanged:
                [self userInputTextDidChanged:_mUserInputTextField];
            }
        }
    }
}

- (void)userInputTextDidChanged:(UITextField *)pTextField{
    // update user input diaplay view label text
    _mInputDiaplayLabel.text = pTextField.text;
    
    // call parent view method:(void)searchContactWithParameter:
    [((ContactsSelectContainerView *)self.superview) searchContactWithParameter:nil == pTextField.text ? @"" : pTextField.text];
}

- (void)indicateSoftKeyboard{
    // check softKeyboard show or hide
    if (_mSoftKeyboardHidden) {
        // softKeyboard hidden currently, show it
        // judge soft keyboard type, if soft keyboard type is ios system, show it
        if(iosSystem == _mSoftKeyboardType){
            // show ios system soft keyboard
            [_mUserInputTextField becomeFirstResponder];
        }
        
        // UIView animation
        [UIView beginAnimations:@"show softKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        // update toolbar center
        self.center = CGPointMake(self.center.x, self.center.y - CONTACTSPROCESS_SOFTKEYBOARD_HEIGHT);
        
        // UIView animation commit
        [UIView commitAnimations];
        
        // update softKeyboard show or hide flag
        _mSoftKeyboardHidden = NO;
        
        // update softKeyboard indicate button title
        [_mSoftKeyboardIndicateBtn setTitle:[INDICATEBUTTON_TITLE objectAtIndex:_mSoftKeyboardHidden] forState:UIControlStateNormal];
    }
    else {
        // softKeyboard shown currently, hide it
        // judge soft keyboard type, if soft keyboard type is ios system, hide it
        if(_mSoftKeyboardType == iosSystem){
            // hide ios system soft keyboard
            [_mUserInputTextField resignFirstResponder];
        }
        
        // UIView animation
        [UIView beginAnimations:@"hide softKeyboard" context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        // update soft keyboard toolbar center
        self.center = CGPointMake(self.center.x, self.center.y + CONTACTSPROCESS_SOFTKEYBOARD_HEIGHT);
        
        // UIView animation commit
        [UIView commitAnimations];
        
        // update softKeyboard show or hide flag
        _mSoftKeyboardHidden = YES;
        
        // update softKeyboard indicate button title
        [_mSoftKeyboardIndicateBtn setTitle:[INDICATEBUTTON_TITLE objectAtIndex:_mSoftKeyboardHidden] forState:UIControlStateNormal];
    }
}

- (void)changeSoftkeyboardType{
    // if softKeyboard is hidden now, show it
    if(_mSoftKeyboardHidden){
        [self indicateSoftKeyboard];
    }
    // if softKeyboard is shown now, change its type
    else {
        // check current softKeyboard type
        switch (_mSoftKeyboardType) {
            case custom:
                // save previous input text
                [_mPreviousInputTextDic setObject:nil == _mUserInputTextField.text ? @"" : _mUserInputTextField.text forKey:[NSNumber numberWithInt:custom]];
                
                // update softKeyboard type
                _mSoftKeyboardType = iosSystem;
                
                // show ios system softKeyboard, and set user input display label font
                [_mUserInputTextField becomeFirstResponder];
                _mInputDiaplayLabel.font = [UIFont boldSystemFontOfSize:MAX_SYSTEMBOARD_DISPLAYFONTSIZE];
                
                // set inputDiaplayLabel text for user input with ios system softKeyboard
                _mUserInputTextField.text = [_mPreviousInputTextDic objectForKey:[NSNumber numberWithInt:iosSystem]];
                
                break;
                
            case iosSystem:
                // save previous input text
                [_mPreviousInputTextDic setObject:nil == _mUserInputTextField.text ? @"" : _mUserInputTextField.text forKey:[NSNumber numberWithInt:iosSystem]];
                
                // update softKeyboard type
                _mSoftKeyboardType = custom;
                
                // hide ios system softKeyboard, and set user input display label font
                [_mUserInputTextField resignFirstResponder];
                _mInputDiaplayLabel.font = [UIFont boldSystemFontOfSize:MAX_CUSTOMBOARD_DISPLAYFONTSIZE];
                
                // set inputDiaplayLabel text for user input with custom softKeyboard
                _mUserInputTextField.text = [_mPreviousInputTextDic objectForKey:[NSNumber numberWithInt:custom]];
                // manual call method:(void)userInputTextDidChanged:
                [self userInputTextDidChanged:_mUserInputTextField];
                
                break;
        }
    }
    
    // update softKeyboard type switch button title
    [_mSoftKeyboardTypeSwitchBtn setTitle:[TYPESWITCHBUTTON_TITLE objectAtIndex:_mSoftKeyboardType] forState:UIControlStateNormal];
}

@end
