//
//  SOTabBarViewController.m
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/27/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import "SOTabBarController.h"


@interface SOTabBarController()
-(CGRect) clientFrame;
@property (nonatomic, readonly) UIViewController* currentViewController;

@end


@implementation SOTabBarController


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark construction && deconstruction

-(id) initWithViewControllers:(NSArray*)viewControllers
{
	if((self = [super initWithNibName:@"SOTabBarController" bundle:nil]) != nil)
	{
		fViewControllers = [NSArray arrayWithArray:viewControllers];
		fCurrentCtrlIndex = ([fViewControllers count]-1)/2;
	}
	return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	self.currentViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width,
													   self.view.frame.size.height - [fTabBar clippingHeight]);
	
	[fTabBar setViewControllers:fViewControllers];
	
	[self.view addSubview:self.currentViewController.view];
	[self.view bringSubviewToFront:fTabBar];
	fTabBar.delegate = self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidUnload 
{
    [super viewDidUnload];
	[fTabBar release];fTabBar = nil;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc 
{
	[fViewControllers release];
	[fTabBar release];	
	
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIViewController methods
////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.currentViewController viewWillAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.currentViewController viewDidAppear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.currentViewController viewWillDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self.currentViewController viewDidDisappear:animated];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark SOTabBarDelegate

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	if([animationID isEqualToString:@"Left"] || [animationID isEqualToString:@"Right"])
	{
		UIViewController* viewController = (UIViewController*)context;
		
		[self.currentViewController.view removeFromSuperview];
		[self.currentViewController viewDidDisappear:YES];
		
		//smart memory managment, release view that is not neccessary any more
		self.currentViewController.view = nil;   
		[viewController viewDidAppear:YES];	
		
		fCurrentCtrlIndex = [fViewControllers indexOfObject:viewController];
		
		[viewController release];
	}
	
}


////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) tabBar:(SOTabBar *)tabBar didSelectItem:(NSInteger)index isDirectionLeft:(BOOL) directionLeft
{
	UIViewController* viewController = [fViewControllers objectAtIndex:index];
	BOOL animated = YES;
	
	(void)viewController.view;
	
	viewController.view.frame = [self clientFrame];
	[viewController viewWillAppear:animated];
	
	[self.currentViewController viewWillDisappear:animated];
	
	[self.view addSubview: viewController.view];
	[self.view bringSubviewToFront:fTabBar];
	
	if(animated)
	{
		
		NSInteger direction = directionLeft? 1:-1;
		
		viewController.view.frame = CGRectOffset(viewController.view.frame, self.view.frame.size.width*direction, 0);
		
		[UIView beginAnimations:@"Left" context: [viewController retain]];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished: context:)];
		[UIView setAnimationDuration:.33];
		
		self.currentViewController.view.frame = CGRectOffset(self.currentViewController.view.frame, -self.view.frame.size.width*direction, 0);
		viewController.view.frame = CGRectOffset(viewController.view.frame, -self.view.frame.size.width*direction, 0);
		
		[UIView commitAnimations];
	}
	else
	{
		[self.currentViewController.view removeFromSuperview];
		[self.currentViewController viewDidDisappear:animated];
		self.currentViewController.view = nil;
		
		[viewController viewDidAppear:animated];	
		
		fCurrentCtrlIndex = index;
	}
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark uitilities
////////////////////////////////////////////////////////////////////////////////////////////////////
-(UIViewController*) currentViewController
{
	if(!(fCurrentCtrlIndex >=0 && fCurrentCtrlIndex< [fViewControllers count]))
		fCurrentCtrlIndex = 0;
		
	return [fViewControllers objectAtIndex:fCurrentCtrlIndex];
}

-(CGRect) clientFrame
{
	return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - [fTabBar clippingHeight]);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public methods
////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSInteger) selectedViewControlelrIndex
{
	return fCurrentCtrlIndex;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) setSelectedViewControllerIndex:(NSInteger) index
{
	fCurrentCtrlIndex = index;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
@end
