//
//  CCScrollViewPicker.m
//  CCPicker
//
//  Created by Aleš Kocur on 12.05.13.
//  Copyright (c) 2013 Aleš Kocur. All rights reserved.
//

#import "CCScrollViewPicker.h"

#define SPACE_SIZE 40

@implementation CCScrollViewPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //NSLog(@"Inicializuju ScrollView");
        _labels = [[NSMutableArray alloc] init];
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        self.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        // if you want to see previous and next item in list
        self.clipsToBounds = NO;
        
    }
    return self;
}


-(void)addLabel:(id)label{
    
    // subview position
    int posX = self.frame.size.width * _labels.count;
    int posY = 0;
    // create subview for item
    UIView *subview = [[UIView alloc] initWithFrame:CGRectMake(posX, posY, self.frame.size.width, self.frame.size.height)];
    //subview.backgroundColor = [UIColor blackColor];
    
    // put label into subview
    [label setFrame:CGRectMake(0, 0, self.frame.size.width-1, self.frame.size.height)];
    [subview addSubview:label];
    
    [self addSubview:subview];
    // add object into labels array
    [_labels addObject:subview];
    
}

-(void)setContentSizeForNumberOfItems:(NSInteger)number{
    NSInteger w = self.frame.size.width;
    NSInteger h = self.frame.size.height;
    // increasing content size
    self.contentSize = CGSizeMake(w*number, h);
}

-(void)setActualPage:(NSInteger)page{
    CGRect frame = self.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self scrollRectToVisible:frame animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
