//
//  TabBarControllerDemoAppDelegate.m
//  TabBarControllerDemo
//
//  Created by Sergey Gavrilyuk on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabBarControllerDemoAppDelegate.h"
#import "TestViewController1.h"
#import "TestViewController2.h"
#import "TestViewController3.h"
#import "TestViewController4.h"
#import "TestViewController5.h"

@implementation TabBarControllerDemoAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{    
	
	TestViewController1* viewCtrl1 = [[TestViewController1 alloc] initWithNibName:nil bundle:nil];
	TestViewController2* viewCtrl2 = [[TestViewController2 alloc] initWithNibName:nil bundle:nil];
	TestViewController3* viewCtrl3 = [[TestViewController3 alloc] initWithNibName:nil bundle:nil];
	TestViewController4* viewCtrl4 = [[TestViewController4 alloc] initWithNibName:nil bundle:nil];
	TestViewController5* viewCtrl5 = [[TestViewController5 alloc] initWithNibName:nil bundle:nil];
	
	viewCtrl1.tabBarImage = [UIImage imageNamed:@"Clock.png"];
	viewCtrl2.tabBarImage = [UIImage imageNamed:@"Contacts.png"];
	viewCtrl3.tabBarImage = [UIImage imageNamed:@"Messages.png"];
	viewCtrl4.tabBarImage = [UIImage imageNamed:@"Things.png"];
	viewCtrl5.tabBarImage = [UIImage imageNamed:@"Weather.png"];
	
	tabBarController = [[SOTabBarController alloc] initWithViewControllers:
											[NSArray arrayWithObjects:
											 viewCtrl1,
											 viewCtrl2,
											 viewCtrl3,
											 viewCtrl4,
											 viewCtrl5,
											 nil]];
	
    [self.window makeKeyAndVisible];
	tabBarController.view.frame = CGRectMake(0, 20, 320, 460);
	[self.window addSubview:tabBarController.view];
    
	[viewCtrl1 release];
	[viewCtrl2 release];
	[viewCtrl3 release];
	[viewCtrl4 release];
	[viewCtrl5 release];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application 
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
