//
//  ViewController.h
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Cell.h"
#import "RateView.h"
#import "RateViewController.h"
#import "NSData+Additions.h"
#import "CCPicker.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>


@interface ViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate, CCPickerDelegate>


@property (nonatomic,strong) IBOutlet UITableView * table;
@property (nonatomic,strong) IBOutlet UILabel* noDataWarn;

@property (nonatomic, strong) IBOutlet CCPicker *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *moneyLabel;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end
