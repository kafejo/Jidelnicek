//
//  LoginViewController.m
//  Jidelnicek
//
//  Created by student on 4/16/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.bg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.bg.backgroundColor = [UIColor colorWithRed:16.0f/255.0f green:168.0f/255.0f blue:174.0f/255.0f alpha:0.4f];
    [self.view addSubview:self.bg];
    [self.bg setHidden:YES];
    [self.bg setUserInteractionEnabled:NO];
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    self.indicator.layer.cornerRadius = 10.0f;
    
    [self.indicator setFrame:CGRectMake(0, 0, 100, 100)];
    self.indicator.center = CGPointMake(self.view.frame.size.width / 2, (self.view.frame.size.height / 2) - 44);
    
    [self.view addSubview:self.indicator];
    [self.indicator setHidesWhenStopped:YES];
    
    
}

-(void) viewDidAppear:(BOOL)animated{
    // nactu jmeno a heslo
    _usernameText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    _passwordText.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.usernameText) || (textField == self.passwordText)) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (IBAction)saveData:(id)sender {
    // ulozim jmeno a heslo
    [self.passwordText resignFirstResponder];
    [self.usernameText resignFirstResponder];
    [self.bg setHidden:NO];
    
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    
    
    if (self.usernameText.text != nil && self.passwordText.text != nil) {
        [udf setObject:self.usernameText.text forKey:@"username"];
        [udf setObject:self.passwordText.text forKey:@"password"];
        [udf synchronize];
        
        [[MenuManager sharedManager] accountBalanceWithLoginSuccess:^(NSString *amount) {
            ViewController *prevVC = [self.navigationController.viewControllers firstObject];
            prevVC.navigationItem.leftBarButtonItem.title = amount;
            [self.navigationController popToViewController:prevVC animated:YES];
        } failure:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nelze se přihlásit" message:@"Zkontrolujte přihlašovací údaje a připojení k internetu." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
            [self.indicator stopAnimating];
        }];
       
    } else {
        //NSLog(@"Neukladam: Nic si nezadal.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Špatné údaje" message:@"Byly zadány nesprávné údaje k přihlášení" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    
    
}

- (IBAction)logout:(id)sender {
    self.usernameText.text = @"";
    self.passwordText.text = @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
}
@end
