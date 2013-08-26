//
//  LoginViewController.h
//  Jidelnicek
//
//  Created by student on 4/16/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSData+Additions.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (strong, nonatomic) UILabel *bg;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

- (IBAction)logout:(id)sender;


@end
