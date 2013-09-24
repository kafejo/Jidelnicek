//
//  AppDelegate.m
//  Jidelnicek
//
//  Created by student on 3/18/13.
//  Copyright (c) 2013 student. All rights reserved.
//

#import "AppDelegate.h"
#import "Flurry.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry startSession:@"Z6WMPGM5CDG6BV74MNWS"];
    
    UIColor *greenColor = [UIColor colorWithRed:16.0f/255.0f green:168.0f/255.0f blue:174.0f/255.0f alpha:1.0f];
    
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (ver <= 6.1) {
        [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1.0f]];
        [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor : greenColor,
                                                               UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0, 0.0)],
                                                               UITextAttributeFont : [UIFont systemFontOfSize:16.0f]} forState:UIControlStateNormal
         ];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                               UITextAttributeTextColor : [UIColor colorWithRed:30.0f/255.0f green:30.0f/255.0f blue:30.0f/255.0f alpha:1.0f],
                                                               UITextAttributeFont : [UIFont systemFontOfSize:18.0f],
                                                               UITextAttributeTextShadowColor : [UIColor clearColor],
                                                               UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                               }];
          }    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // DEBUG KOD PRO SMAZANI ULOZENYCH DAT
    /*
    NSLog(@"Mazu ulozena data");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"correctUserNameAndPassword"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"jidelnicek"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"money"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   
}

@end
