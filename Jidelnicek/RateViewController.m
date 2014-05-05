//
//  RateViewController.m
//  Jidelnicek
//
//  Created by mik on 13.04.13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "RateViewController.h"

@interface RateViewController ()
{
    Reachability *internetReachableFoo;

}
@end

@implementation RateViewController

-(void) viewDidDisappear:(BOOL)animated{
    
     if (_rate.rating != _ratingData) {
         
         [[MenuManager sharedManager] rateFood:[self.foodId integerValue] rate:self.rate.rating];
         
    }
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
    {
        [super viewDidLoad];

        self.rate.notSelectedImage = [UIImage imageNamed:@"hvezdy_empty.png"];
        self.rate.halfSelectedImage = [UIImage imageNamed:@"hvezdy_half.png"];
        self.rate.fullSelectedImage = [UIImage imageNamed:@"hvezdy_full.png"];
    
  //      self.rate.rating = 3;
        self.rate.rating = self.ratingData;
        #if DEBUG
            NSLog(@"Rating je %f a RatingDate je %f",self.rate.rating,self.ratingData);
        #endif
        self.rate.editable = YES;
        
        self.rate.maxRating = 5;
        self.rate.delegate = (id) self;
        [self rateView:_rate ratingDidChange:self.ratingData];
        
        self.foodLabel.text = self.foodLabelData;
        
        
        
    }
    
-(void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
        self.label.text = [NSString stringWithFormat:@"Hodnocení: %@", [NSString stringWithFormat:@"%0.0f",rating]];
}

-(void)didReceiveMemoryWarning
                                                                                                                                                                           
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
