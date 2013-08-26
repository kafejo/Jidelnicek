//
//  CCScrollViewPicker.h
//  CCPicker
//
//  Created by Aleš Kocur on 12.05.13.
//  Copyright (c) 2013 Aleš Kocur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCScrollViewPicker : UIScrollView<UIScrollViewDelegate>

@property NSMutableArray *labels;


-(void)addLabel:(UILabel*)label;
-(void)setContentSizeForNumberOfItems:(NSInteger)number;
-(void)setActualPage:(NSInteger)page;

@end
