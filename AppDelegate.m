//
//  AppDelegate.m
//  medAlbum
//
//  Created by Jeremy Wiygul on 2/24/14.
//  Copyright (c) 2014 Jeremy Wiygul. All rights reserved.
//

#import "AppDelegate.h"
#import "dataWithImageStore.h"
#import "PatientTableViewController.h"
#import "PWScreenViewController.h"
#import "KeychainItemWrapper.h"
#import <Dropbox/Dropbox.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if ([[dataWithImageStore sharedStore]passwordOn]) {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"password" accessGroup:nil];
        PWScreenViewController *pwvc = [[PWScreenViewController alloc]init];
        pwvc.passwordWrapper = wrapper;
        UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:pwvc];
        [[UINavigationBar appearance]setBarTintColor:[UIColor blueColor]];
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        [[self window]setRootViewController:navControl];
        [self.window makeKeyAndVisible];
    }
    else{
        PatientTableViewController *ptvc = [[PatientTableViewController alloc]init];
        UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:ptvc];
        [[UINavigationBar appearance]setBarTintColor:[UIColor blueColor]];
        [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIColor whiteColor],NSForegroundColorAttributeName, nil]];
        [[self window]setRootViewController:navControl];
        [self.window makeKeyAndVisible];
    }
   
    DBAccountManager *accountMgr = [[DBAccountManager alloc]initWithAppKey:@"w5x0k5efjwhv30j" secret:@"q1oruu61qo6y6of"];
    [DBAccountManager setSharedManager:accountMgr];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[dataWithImageStore sharedStore]saveChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  
    if ([[dataWithImageStore sharedStore]passwordOn]) {
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc]initWithIdentifier:@"password" accessGroup:nil];
    PWScreenViewController *pwvc = [[PWScreenViewController alloc]init];
    pwvc.passwordWrapper = wrapper;
    UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:pwvc];
    [[UINavigationBar appearance]setBarTintColor:[UIColor blueColor]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[self window]setRootViewController:navControl];
    [self.window makeKeyAndVisible];
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DBAccount *account = [[DBAccountManager sharedManager]handleOpenURL:url];
    if (account) {
        return YES;
    }
    return NO;
}
-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    return UIInterfaceOrientationMaskPortrait;
}
@end

