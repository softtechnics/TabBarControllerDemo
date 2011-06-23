//
//  SOTabBarViewController.h
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/27/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOTabBar.h"


@interface SOTabBarController : UIViewController <SOTabBarDelegate>
{
@private
	NSArray* fViewControllers;
	NSInteger fCurrentCtrlIndex;
	
	IBOutlet SOTabBar* fTabBar;
}


-(id) initWithViewControllers:(NSArray*)viewControllers;

// navigation methods

-(NSInteger) selectedViewControlelrIndex;
-(void) setSelectedViewControllerIndex:(NSInteger) index;


@end
