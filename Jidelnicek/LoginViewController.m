//
//  LoginViewController.m
//  Jidelnicek
//
//  Created by student on 4/16/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.bg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.bg.backgroundColor = [UIColor colorWithRed:16.0f/255.0f green:168.0f/255.0f blue:174.0f/255.0f alpha:0.4f];
    [self.view addSubview:self.bg];
    [self.bg setHidden:YES];
    [self.bg setUserInteractionEnabled:NO];
    self.indicator = [[UIActivityIndicatorView alloc] init];
    self.indicator.backgroundColor = [UIColor blackColor];
    self.indicator.color = [UIColor whiteColor];
    int x = self.view.frame.size.width/2;
    int y = self.view.frame.size.height/2 - 40;
    [self.indicator setFrame:CGRectMake(x, y, self.indicator.frame.size.width, self.indicator.frame.size.height)];
    [self.view addSubview:self.indicator];
    [self.indicator setHidden:YES];
    
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
    
    if (_usernameText.text != nil && _passwordText.text != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:_usernameText.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordText.text forKey:@"password"];
        
        [self performSelectorInBackground:@selector(tryLoginToIS) withObject:nil];
        //[self tryLoginToIS];
        //NSLog(@"Ukladam: Jmeno je: %@ a heslo je: %@",_usernameText.text,_passwordText.text);
        
       
    }
    else {
        //NSLog(@"Neukladam: Nic si nezadal.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Špatné údaje" message:@"Byly zadány nesprávné údaje k přihlášení" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
    
    
}

-(void) tryLoginToIS {
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://is.mendelu.cz/auth/uskm/jidelnicek.pl"]];
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"username"], [[NSUserDefaults standardUserDefaults] objectForKey:@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    [urlRequest addValue:@"en-US" forHTTPHeaderField:@"Content-Language"];
    [urlRequest addValue:@"en-US" forHTTPHeaderField:@"Accept-Language"];
    
    // poslu data
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    
    int status = [response statusCode];
    NSLog(@"Status code je: %i",status);
    [self.indicator stopAnimating];
    [self.bg setHidden:YES];
    
    if (status != 200) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Přihlášení" message:@"Špatné jméno nebo heslo" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"correctUserNameAndPassword"];
        
    }
    else {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"correctUserNameAndPassword"];
        [self performSelectorOnMainThread:@selector(goBack) withObject:nil waitUntilDone:YES];
    }
   
    
}

- (void)goBack{
    NSArray *VCs = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[VCs objectAtIndex:([VCs count] - 2)] animated:YES];

}
- (IBAction)logout:(id)sender {
    self.usernameText.text = @"";
    self.passwordText.text = @"";
    
    [[NSUserDefaults standardUserDefaults] setObject:_usernameText.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:_passwordText.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"correctUserNameAndPassword"];
    
   
}
@end
