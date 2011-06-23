//
//  SOTabBar.h
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/27/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOTabBar;

@protocol SOTabBarDelegate
@optional

-(void) tabBar:(SOTabBar*) tabBar didSelectItem:(NSInteger) index isDirectionLeft:(BOOL) direction;

@end


@interface SOTabBar : UIView 
{
@private
	NSArray* fViewControllers;
	NSMutableArray* fButtons;
	
	NSInteger fSelectedButtonIndex;
}


-(void) setViewControllers:(NSArray*) viewControllers;

@property (nonatomic, assign) id<SOTabBarDelegate> delegate;


-(CGFloat) clippingHeight;

@end
