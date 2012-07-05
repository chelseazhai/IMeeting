//
//  ContactsProcessSoftKeyboard.m
//  IMeeting
//
//  Created by  on 12-6-28.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactsProcessSoftKeyboard.h"

// contacts process softKeyboard contents
#define CONTACTSPROCESS_SOFTKEYBOARD_CONTENTS    [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"1", @"2", @"3", nil], [NSNumber numberWithInteger:0], [NSArray arrayWithObjects:@"4", @"5", @"6", nil], [NSNumber numberWithInteger:1], [NSArray arrayWithObjects:@"7", @"8", @"9", nil], [NSNumber numberWithInteger:2], [NSArray arrayWithObjects:@"add", @"0", @"del", nil], [NSNumber numberWithInteger:3], nil]

@implementation ContactsProcessSoftKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // set background color
        self.backgroundColor = CONTACTSPROCESS_SOFTKEYBOARD_BACKGROUND_COLOR;
        
        // set margin size
        self.padding = 2.0;
        
        // set dataSource
        self.dataSource = self;
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

- (NSInteger)numberOfRowsInSoftKeyboard:(UISoftKeyboard *)pSoftKeyboard{
    // return the number of rows
    return 4;
}

- (NSInteger)softKeyboard:(UISoftKeyboard *)pSoftKeyboard numberOfCellsInRow:(NSInteger)pRow{
    // return the number of cell in the row    
    return 3;
}

- (UISoftKeyboardCell *)softKeyboard:(UISoftKeyboard *)pSoftKeyboard cellForRowAtIndexPath:(NSIndexPath *)pIndexPath{
    UISoftKeyboardCell *_cell = [[UISoftKeyboardCell alloc] init];
    
    // Configure the cell...
    _cell.backgroundColor = CONTACTSPROCESS_SOFTKEYBOARD_FRONT_COLOR;
    _cell.pressedBackgroundColor = [UIColor blueColor];
    
    @autoreleasepool {
        // create and init softKeyboard front view
        UILabel *_label = [[UILabel alloc] init];
        _label.text = [[CONTACTSPROCESS_SOFTKEYBOARD_CONTENTS objectForKey:[NSNumber numberWithInteger:pIndexPath.skb_row]] objectAtIndex:pIndexPath.skb_cell];
        _label.textAlignment = UITextAlignmentCenter;
        
        _cell.frontView = _label;
    }
    
    return _cell;
}

@end
