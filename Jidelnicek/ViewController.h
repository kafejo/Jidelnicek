//
//  ViewController.h
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayManager.h"
#import "Reachability.h"
#import "Cell.h"
#import "RateView.h"
#import "RateViewController.h"
#import "NSData+Additions.h"
#import "CCPicker.h"



@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, CCPickerDelegate>

@property (nonatomic, retain) DayManager* manager;
@property (nonatomic,strong) IBOutlet UITableView * table;
@property (nonatomic,strong) IBOutlet UILabel* noDataWarn;

@property (nonatomic, strong) IBOutlet CCPicker *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *moneyLabel;
//@property (nonatomic) BOOL loggedIn;

@end
