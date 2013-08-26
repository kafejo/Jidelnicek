//
//  CCPicker.h
//  CCPicker
//
//  Created by Aleš Kocur on 12.05.13.
//  Copyright (c) 2013 Aleš Kocur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCScrollViewPicker.h"
@class CCPicker;


@protocol CCPickerDelegate <NSObject>

@optional
-(id)CCPicker:(CCPicker*)picker labelForRow:(NSInteger)row;
-(void)CCPicker:(CCPicker*)picker didChangePage:(NSInteger)page;
-(NSInteger)actualPageForCCPicker:(CCPicker*)picker;

@required
-(NSInteger)numberOfRowForPicker:(CCPicker*)picker;

@end

@interface CCPicker : UIView<UIScrollViewDelegate>

@property __weak id <CCPickerDelegate> pickerDelegate;
@property NSInteger actualPage;
@property NSInteger numberOfRows;
@property CCScrollViewPicker *scrollPicker;


-(id)initWithFrame:(CGRect)frame delegate:(id<CCPickerDelegate>)delegate;
-(void)reloadData;
@end
