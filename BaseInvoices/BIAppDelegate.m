//
//  BIAppDelegate.m
//  BaseInvoices
//
//  Created by ThomasTran on 11/7/14.
//  Copyright (c) 2014 mtoanmy. All rights reserved.
//

#import "BIAppDelegate.h"
#import "BILogin.h"
#import "BIDashBoard.h"
#import "NSUserDefaults+RMSaveCustomObject.h"
#import "BLLeftSideVC.h"
#import "GAI.h"
#import "CountryRepository.h"
#import "CountryListDataSource.h"
#import "WelcomeViewController.h"

@implementation BIAppDelegate

@synthesize navController;
/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-42741504-2";
static NSString *const kAllowTracking = @"allowTracking";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *appDefaults = @{kAllowTracking: @(YES)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
    // Initialize Google Analytics with a 120-second dispatch interval. There is a
    // tradeoff between battery usage and timely dispatch.
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithName:@"BaseTax"
                                              trackingId:kTrackingId];
    
    CountryListDataSource *dataSource = [[CountryListDataSource alloc] init];
    _dataRows = [dataSource countries];
    
    _countries = [[NSMutableArray alloc] init];
    
    for (NSDictionary* dict in _dataRows)
    {
        CountryRepository* country = [[CountryRepository alloc] initWithCountryName: [dict valueForKey:@"name"] countryCode: [dict valueForKey:@"code"] dialCode: [dict valueForKey:@"id"]];        
        
        [_countries addObject:country];
    }

    
    self.invoicesForUser = [[NSMutableArray alloc] init];
    self.customerForUser = [[NSMutableArray alloc] init];
    self.businessForUser = [[NSMutableArray alloc] init];
    
    self.productsForUser = [[NSMutableArray alloc] init];
    self.productsFroAddInvoices = [[NSMutableArray alloc] init];
    self.currencies = [[NSMutableArray alloc] init];
    self.currentUser = [[BIUser alloc] init];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    
//    NSMutableArray* productsForUser = [[NSMutableArray alloc] init];
//    productsForUser = [defaults rm_customObjectForKey:@"productsForUser"];
//    
//    NSMutableArray* businessForUser = [[NSMutableArray alloc] init];
//    businessForUser =  [defaults rm_customObjectForKey:@"bussinessesForUser"];
//    
//    self.businessForUser = businessForUser;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.result = [[UIScreen mainScreen] bounds].size;
    }
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"LOGIN"] == YES)
    {
        WelcomeViewController* welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        navController = [[UINavigationController alloc]initWithRootViewController:welcomeViewController];
    }
    else
    {
        // Override point for customization after application launch.
        BILogin *centerSideVC = [[BILogin alloc] initWithNibName:@"BILogin" bundle:nil];
        navController = [[UINavigationController alloc]initWithRootViewController:centerSideVC];
    }
    
    navController.navigationBarHidden = YES;
    
    self.window.rootViewController = navController;
    
    [self.window makeKeyAndVisible];

    
    return YES;
}

+ (BIAppDelegate*)shareAppdelegate
{
    return (BIAppDelegate*) [[UIApplication sharedApplication] delegate];
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"LOGIN"] == YES)
    {
        WelcomeViewController* welcomeViewController = [[WelcomeViewController alloc] initWithNibName:@"WelcomeViewController" bundle:nil];
        
        [self.navController pushViewController:welcomeViewController animated:YES];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
