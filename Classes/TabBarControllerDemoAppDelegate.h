//
//  TabBarControllerDemoAppDelegate.h
//  TabBarControllerDemo
//
//  Created by Sergey Gavrilyuk on 6/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOTabBarController.h"

@interface TabBarControllerDemoAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	SOTabBarController* tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;


@end

