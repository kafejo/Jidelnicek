//
//  CCPicker.m
//  CCPicker
//
//  Created by Aleš Kocur on 12.05.13.
//  Copyright (c) 2013 Aleš Kocur. All rights reserved.
//

#import "CCPicker.h"


@implementation CCPicker


- (id)initWithFrame:(CGRect)frame delegate:(id<CCPickerDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.pickerDelegate = delegate;
        
        // Centering picker frame
        //int x = (frame.size.width - (frame.size.width-20)) / 3;
        int y = (frame.size.height - (frame.size.height - 10)) / 2;

        _scrollPicker = [[CCScrollViewPicker alloc] initWithFrame:CGRectMake(self.frame.size.width/3, y, frame.size.width/2, frame.size.height-10)];
        [self addSubview:_scrollPicker];
        
        
        
        [self loadItems];
        
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.pickerDelegate = nil;
        
        // Centering picker frame
        int x = (self.frame.size.width / 4) ;
        int y = (self.frame.size.height - (self.frame.size.height - 10)) / 2;
        
        _scrollPicker = [[CCScrollViewPicker alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width/2, self.frame.size.height-10)];
        
        [self addSubview:_scrollPicker];
    }
    return self;
}


-(void)reloadData{
    // If delegate isn't set break loading
    if (_pickerDelegate == nil) {
        NSLog(@"You didn't set delegate");
        return;
    }
    [_scrollPicker.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_scrollPicker.labels removeAllObjects];
    [self loadItems];
}

-(void)loadItems{
    
    _scrollPicker.delegate = self;
    
    // Loading data into the picker through delegate methods
    if([_pickerDelegate respondsToSelector:@selector(numberOfRowForPicker:)]){
        _numberOfRows = [_pickerDelegate numberOfRowForPicker:self];
    }else{
        _numberOfRows = 0;
    }
    
    // setting the content size
    [_scrollPicker setContentSizeForNumberOfItems:_numberOfRows];
    for (int i = 0; i < _numberOfRows; i++) {
        UILabel *label = nil;
        label = [_pickerDelegate CCPicker:self labelForRow:i];
        [_scrollPicker addLabel:label];
    }
    
    // Setting actual the page
    if([_pickerDelegate respondsToSelector:@selector(actualPageForCCPicker:)]){
        _actualPage = [_pickerDelegate actualPageForCCPicker:self];
    }else{
        _actualPage = 0;
    }
    // do change for the actual page
    if (_numberOfRows > 0) {
        if([_pickerDelegate respondsToSelector:@selector(CCPicker:didChangePage:)]){
            [_pickerDelegate CCPicker:self didChangePage:_actualPage];
        }
    }
    // scroll on the actual page
    [_scrollPicker setActualPage:_actualPage];

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // calculate actual page
    NSInteger w = scrollView.frame.size.width;
    NSInteger xAct = scrollView.contentOffset.x;
    NSInteger page = xAct/w;
    if(xAct == page*w && page != _actualPage){
        _actualPage = page;
        if(_pickerDelegate != nil){
            if([_pickerDelegate respondsToSelector:@selector(CCPicker:didChangePage:)]){
                [_pickerDelegate CCPicker:self didChangePage:page];
            }
        }
    }
    
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _scrollPicker;
    }
    return view;
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
