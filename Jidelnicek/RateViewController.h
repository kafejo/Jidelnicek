//
//  RateViewController.h
//  Jidelnicek
//
//  Created by mik on 13.04.13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "Reachability.h"

@interface RateViewController : UIViewController

@property(strong,nonatomic) IBOutlet RateView* rate;
@property(strong,nonatomic) IBOutlet UILabel* label;
@property(strong,nonatomic) IBOutlet UILabel* foodLabel;
@property (assign, nonatomic) float ratingData;
@property (strong,nonatomic) NSString* foodLabelData;
@property (strong,nonatomic) NSNumber* foodId;
@property (strong,nonatomic) NSMutableData* receivedData;

@end
