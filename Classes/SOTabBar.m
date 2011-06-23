//
//  SOTabBar.m
//  StatusOn
//
//  Created by Sergey Gavrilyuk on 5/27/11.
//  Copyright 2011 SoftTechnics. All rights reserved.
//

#import "SOTabBar.h"
#import "SOViewController.h"

#define BUTTON_GAP 0
#define BUTTON_PERSPECTIVE 1.8
#define CLIPPING_HEIGHT 44.0
#define BUTTON_RATIO  1.55

@interface SOTabBar()
-(void) animatedShiftRight:(NSInteger) steps;
-(void) animatedShiftRightWithParams:(NSMutableDictionary*) params;
-(void) animatedShiftLeft:(NSInteger) steps;
-(void) animatedShiftLeftWithparams:(NSMutableDictionary*) params;

@end


@implementation SOTabBar
@synthesize delegate;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark construction && deconstruction
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) commonInit
{
	fButtons = [[NSMutableArray alloc] init];
	UIView* clippingView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - CLIPPING_HEIGHT, self.frame.size.width, CLIPPING_HEIGHT)];
	clippingView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleTopMargin;
	[self addSubview:clippingView];
	
	clippingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"perfor-background.png"]];
	self.backgroundColor = [UIColor clearColor];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) 
	{
		[self commonInit];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
	{
		[self commonInit];
    }
    return self;
	
}
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)dealloc 
{
	[fViewControllers release];
	[fButtons release];
	
    [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark internal methods
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) layoutSubviews
{
	[super layoutSubviews];
	
	NSInteger smallButtonSize = 
		(self.frame.size.width - BUTTON_GAP*([fButtons count]-1))/
		(CGFloat)([fButtons count] + (BUTTON_PERSPECTIVE - 1));
	
	NSInteger bigButtonSize = smallButtonSize*BUTTON_PERSPECTIVE;
	
	NSInteger halfButtonsCount = ([fButtons count]-1)/2;
	
	
	//selectedButton first
	UIView* buttView = (UIView*)[fButtons objectAtIndex: halfButtonsCount];
	
	
	
	buttView.frame = CGRectMake(halfButtonsCount*(smallButtonSize+BUTTON_GAP) + bigButtonSize*(1.0-1.0/BUTTON_RATIO)/2
								, self.frame.size.height-bigButtonSize, 
								bigButtonSize/BUTTON_RATIO, bigButtonSize);
	
	for(NSInteger i=0;i<halfButtonsCount; ++i)
	{
		buttView = (UIView*)[fButtons objectAtIndex:i];
		buttView.frame = CGRectMake(i*(smallButtonSize + BUTTON_GAP) + smallButtonSize*(1.0-1.0/BUTTON_RATIO)/2, 
									self.frame.size.height - smallButtonSize, 
									smallButtonSize/BUTTON_RATIO, smallButtonSize);
	}
	
	for(NSInteger i=halfButtonsCount+1; i< [fButtons count]; ++i)
	{
		buttView = (UIView*)[fButtons objectAtIndex:i];
		buttView.frame = CGRectMake((i-1)*smallButtonSize+bigButtonSize + i*BUTTON_GAP + smallButtonSize*(1.0-1.0/BUTTON_RATIO)/2,
									self.frame.size.height - smallButtonSize, 
									smallButtonSize/BUTTON_RATIO, smallButtonSize);		
	}
	
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark navigation
////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
	NSMutableDictionary* params = (NSMutableDictionary*)context;

	UIView* transitionButton = [params objectForKey:@"transition_button"];
	[transitionButton removeFromSuperview];

	NSInteger currentStep = [(NSNumber*)[params objectForKey:@"current_step"] intValue];
	currentStep++;
	[params setObject:[NSNumber numberWithInt:currentStep] forKey:@"current_step"];

	if(currentStep < [(NSNumber*)[params objectForKey:@"steps"] intValue])
	{	
		if([animationID isEqualToString:@"Left"])
		{
			[self animatedShiftLeftWithparams:params];

		}
		else if([animationID isEqualToString:@"Right"])
		{
			[self animatedShiftRightWithParams:params];
		}
	}
	[params release];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) animatedShiftRight:(NSInteger) steps
{
	NSMutableDictionary* params = [NSMutableDictionary dictionary];
	[params setObject:[NSNumber numberWithInt:steps] forKey:@"steps"];
	[params setObject:[NSNumber numberWithInt:0] forKey:@"current_step"];
	[self animatedShiftRightWithParams:params];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) animatedShiftRightWithParams:(NSMutableDictionary*) params
{
	UIButton* transitionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIButton* originButton = [(UIButton*)[fButtons lastObject] retain];
	
	[transitionButton setTitle: [originButton titleForState:UIControlStateNormal] forState:UIControlStateNormal];
	
	transitionButton.frame = originButton.frame;
	UIImageView* image = [[UIImageView alloc] initWithImage: [(UIImageView*)[originButton viewWithTag:111] image]];
	image.contentMode = UIViewContentModeScaleAspectFit;
	image.frame = transitionButton.bounds;
	image.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[transitionButton addSubview:image];
	[image release];

	[self addSubview:transitionButton];
	
	[params setObject:transitionButton forKey:@"transition_button"];
	
	originButton.frame = CGRectOffset(originButton.frame, -originButton.frame.origin.x - originButton.frame.size.width*BUTTON_RATIO-BUTTON_GAP, 0);

	NSInteger smallButtonSize = 
	(self.frame.size.width - BUTTON_GAP*([fButtons count]-1))/
	(CGFloat)([fButtons count] + (BUTTON_PERSPECTIVE - 1));
	
	NSInteger bigButtonSize = smallButtonSize*BUTTON_PERSPECTIVE;
	
	NSInteger halfButtonsCount = ([fButtons count]-1)/2;

	NSInteger steps = [(NSNumber*)[params objectForKey:@"steps"] intValue];
	NSInteger currentStep = [(NSNumber*)[params objectForKey:@"steps"] intValue];
	
	[UIView beginAnimations:@"Right" context:[params retain]];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished:context:)];
	[UIView setAnimationDuration:.33/steps];

	
	if(currentStep == 0)
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	else if(currentStep == steps-1)
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	else
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	

	for(NSInteger i=0; i< [fButtons count]; ++i)
	{
		UIButton* button = [fButtons objectAtIndex:i];
		
		if(i == ([fButtons count]-1)/2 - 1)
		{
			button.frame = CGRectMake(halfButtonsCount*(smallButtonSize + BUTTON_GAP) + bigButtonSize*(1.0 - 1.0/BUTTON_RATIO)/2, 
									  self.frame.size.height-bigButtonSize, 
										bigButtonSize/BUTTON_RATIO, bigButtonSize);
		}
		else if(i == ([fButtons count]-1)/2)
		{
			button.frame = CGRectMake((i-1)*smallButtonSize+bigButtonSize + i*BUTTON_GAP + smallButtonSize*(1.0 - 1.0/BUTTON_RATIO)/2 , 
									  self.frame.size.height - smallButtonSize, 
										smallButtonSize/BUTTON_RATIO, smallButtonSize);		
		}
		else
		{
			button.frame = CGRectOffset(button.frame, button.frame.size.width*BUTTON_RATIO + BUTTON_GAP , 0);			
		}

	}
	transitionButton.frame = CGRectOffset(transitionButton.frame,transitionButton.frame.size.width*BUTTON_RATIO+BUTTON_GAP, 0);
	[UIView commitAnimations];
	
	[fButtons removeLastObject];
	[fButtons insertObject:originButton atIndex:0];
	[originButton release];
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) animatedShiftLeft:(NSInteger) steps
{
	NSMutableDictionary* params = [NSMutableDictionary dictionary];
	[params setObject:[NSNumber numberWithInt:steps] forKey:@"steps"];
	[params setObject:[NSNumber numberWithInt:0] forKey:@"current_step"];
	[self animatedShiftLeftWithparams:params];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) animatedShiftLeftWithparams:(NSMutableDictionary*) params
{
	UIButton* transitionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	UIButton* originButton = [(UIButton*)[fButtons objectAtIndex:0] retain];
	
	transitionButton.frame = originButton.frame;
	UIImageView* image = [[UIImageView alloc] initWithImage: [(UIImageView*)[originButton viewWithTag:111] image]];
	image.contentMode = UIViewContentModeScaleAspectFit;
	image.frame = transitionButton.bounds;
	image.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[transitionButton addSubview:image];
	[image release];
	[self addSubview:transitionButton];
	
	[params setObject:transitionButton forKey:@"transition_button"];
	
	originButton.frame = CGRectOffset(originButton.frame, self.frame.size.width + originButton.frame.size.width-BUTTON_GAP, 0);
	
	NSInteger smallButtonSize = 
	(self.frame.size.width - BUTTON_GAP*([fButtons count]-1))/
	(CGFloat)([fButtons count] + (BUTTON_PERSPECTIVE - 1));
	
	NSInteger bigButtonSize = smallButtonSize*BUTTON_PERSPECTIVE;
	
	NSInteger halfButtonsCount = ([fButtons count]-1)/2;
	
	NSInteger steps = [(NSNumber*)[params objectForKey:@"steps"] intValue];
	NSInteger currentStep = [(NSNumber*)[params objectForKey:@"steps"] intValue];
	
	[UIView beginAnimations:@"Left" context: [params retain]];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop: finished:context:)];
	[UIView setAnimationDuration:.33/steps];

	if(currentStep == 0)
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	else if(currentStep == steps-1)
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	else
		[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	
	
	for(NSInteger i=0; i< [fButtons count]; ++i)
	{
		UIButton* button = [fButtons objectAtIndex:i];
		
		if(i == ([fButtons count]-1)/2 + 1)
		{
			button.frame = CGRectMake(halfButtonsCount*(smallButtonSize + BUTTON_GAP) + bigButtonSize*(1.0-1.0/BUTTON_RATIO)/2, 
									  self.frame.size.height-bigButtonSize, 
									  bigButtonSize/BUTTON_RATIO, bigButtonSize);
		}
		else if(i == ([fButtons count]-1)/2)
		{
			button.frame = CGRectMake((i-1)*smallButtonSize+bigButtonSize + i*BUTTON_GAP + smallButtonSize*(1.0-1.0/BUTTON_RATIO)/2,  
									  self.frame.size.height - smallButtonSize, 
									  smallButtonSize/BUTTON_RATIO, smallButtonSize);		
		}
		else
		{
			button.frame = CGRectOffset(button.frame, -(button.frame.size.width*BUTTON_RATIO +BUTTON_GAP), 0);			
		}
		
	}
	
	transitionButton.frame = CGRectOffset(transitionButton.frame,-(transitionButton.frame.size.width*BUTTON_RATIO+BUTTON_GAP), 0);
	[UIView commitAnimations];
	
	[fButtons removeObjectAtIndex:0];
	[fButtons addObject:originButton];
	[originButton release];
}
////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark user action handelrs
////////////////////////////////////////////////////////////////////////////////////////////////////
-(void) buttonPressed:(id)sender
{
	NSInteger buttonIndexToSelect = [(UIView*)sender tag];
	if(fSelectedButtonIndex == buttonIndexToSelect)
		return;

	
	fSelectedButtonIndex = buttonIndexToSelect;
	
		
	NSInteger i=0;
	while(i<[fButtons count] && [(UIButton*)[fButtons objectAtIndex:i] tag] != buttonIndexToSelect)
		++i;
	if([fButtons count]<=i)
		return;
	

	BOOL directionLeft = YES;
	if(i+1>ceil([fButtons count]/2.0))
	{
		[self animatedShiftLeft:abs(i+1 - ceil([fButtons count]/2.0))];
	}
	else if(i+1<ceil([fButtons count]/2.0))
	{
		[self animatedShiftRight:abs(i+1 - ceil([fButtons count]/2.0))];
		directionLeft = NO;
	}
	
	if([(NSObject*)self.delegate respondsToSelector:@selector(tabBar:didSelectItem:isDirectionLeft:)])
		[self.delegate tabBar:self didSelectItem:fSelectedButtonIndex isDirectionLeft:directionLeft];

}
////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark public methods
////////////////////////////////////////////////////////////////////////////////////////////////////

-(void) setViewControllers:(NSArray*) viewControllers
{
	[fViewControllers autorelease];
	fViewControllers = [viewControllers retain];
	
	[fButtons removeAllObjects];
	
	for(NSInteger i=0; i< [viewControllers count]; ++i)
	{
		UIButton* button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];//[[UIButton alloc] init];
		
		//[button setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
		UIImageView* imageView = [[UIImageView alloc] initWithImage:[(SOViewController*)[fViewControllers objectAtIndex:i] tabBarImage]];
		imageView.frame = button.frame;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
		imageView.tag = 111;
		
		[button addSubview:imageView];
		[imageView release];
		
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[button setTag:i];
		
		[fButtons addObject:button];
		[self addSubview:button];
		
		[button release];
	}
	
	fSelectedButtonIndex = floor([viewControllers count]/2.0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat) clippingHeight
{
	return CLIPPING_HEIGHT;
}

@end
