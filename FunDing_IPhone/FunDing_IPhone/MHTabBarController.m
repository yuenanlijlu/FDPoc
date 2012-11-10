//
//  MHTabBarController.m
//  FunDing_IPhone
//
//  Created by Ray on 11/10/12.
//  Copyright (c) 2012 apple. All rights reserved.
//

#import "MHTabBarController.h"
#import "ReservationViewController.h"

static const float TAB_BAR_HEIGHT = 44.0f;
static const NSInteger TAG_OFFSET = 1000;

@implementation MHTabBarController
{
	UIView *tabButtonsContainerView;
	UIView *contentContainerView;
	UIImageView *indicatorImageView;
}

@synthesize viewControllers = _viewControllers;
@synthesize selectedIndex = _selectedIndex;
@synthesize delegate = _delegate;

- (void)centerIndicatorOnButton:(UIButton *)button
{
	CGRect rect = indicatorImageView.frame;
	rect.origin.x = button.center.x - floorf(indicatorImageView.frame.size.width/2.0f);
	rect.origin.y = TAB_BAR_HEIGHT - indicatorImageView.frame.size.height;
	indicatorImageView.frame = rect;
	indicatorImageView.hidden = NO;
}

- (void)selectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
	UIImage *image = [[UIImage imageNamed:@"MHTabBarActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateNormal];
}

- (void)deselectTabButton:(UIButton *)button
{
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
	UIImage *image = [[UIImage imageNamed:@"MHTabBarInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	[button setBackgroundImage:image forState:UIControlStateHighlighted];
    
	[button setTitleColor:[UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)removeTabButtons
{
	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
		[button removeFromSuperview];
}

- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TAG_OFFSET + index;
		[button setTitle:viewController.title forState:UIControlStateNormal];
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchDown];
		button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
		button.titleLabel.shadowOffset = CGSizeMake(0, 1);
		[self deselectTabButton:button];
		[tabButtonsContainerView addSubview:button];
        
		++index;
	}
}

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];
    
	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];
    
	CGRect rect = CGRectMake(0, 0, floorf(self.view.bounds.size.width / count), TAB_BAR_HEIGHT);
    
	indicatorImageView.hidden = YES;
    
	NSArray *buttons = [tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
			rect.size.width = self.view.bounds.size.width - rect.origin.x;
        
		button.frame = rect;
		rect.origin.x += rect.size.width;
        
		if (index == self.selectedIndex)
			[self centerIndicatorOnButton:button];
        
		++index;
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    
    [self addContentViews];
    
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, TAB_BAR_HEIGHT);
    
	tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
	tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:tabButtonsContainerView];
    
	rect.origin.y = TAB_BAR_HEIGHT;
	rect.size.height = self.view.bounds.size.height - TAB_BAR_HEIGHT;
	contentContainerView = [[UIView alloc] initWithFrame:rect];
	contentContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:contentContainerView];
    
	indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHTabBarIndicator"]];
	[self.view addSubview:indicatorImageView];
    
	[self reloadTabButtons];
}

- (void)addContentViews
{
    ReservationViewController *listViewController1 = [[ReservationViewController alloc] init];
	ReservationViewController *listViewController2 = [[ReservationViewController alloc] init];
	ReservationViewController *listViewController3 = [[ReservationViewController alloc] init];
	
	listViewController1.title = @"Restaurant";
	listViewController2.title = @"Reservation";
	listViewController3.title = @"Food";
    
	NSArray *viewControllers = [NSArray arrayWithObjects:listViewController1, listViewController2, listViewController3, nil];
    self.viewControllers = viewControllers;
    
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	tabButtonsContainerView = nil;
	contentContainerView = nil;
	indicatorImageView = nil;
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Only rotate if all child view controllers agree on the new orientation.
	for (UIViewController *viewController in self.viewControllers)
	{
		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
			return NO;
	}
	return YES;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	NSAssert([newViewControllers count] >= 2, @"MHTabBarController requires at least two view controllers");
    
	UIViewController *oldSelectedViewController = self.selectedViewController;
    
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
    
	_viewControllers = [newViewControllers copy];
    
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;
    
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
    
	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
    
	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = [self.viewControllers objectAtIndex:newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}
    
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		UIViewController *fromViewController;
		UIViewController *toViewController;
        
		if (_selectedIndex != NSNotFound)
		{
			UIButton *fromButton = (UIButton *)[tabButtonsContainerView viewWithTag:TAG_OFFSET + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
        
		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;
        
		UIButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (UIButton *)[tabButtonsContainerView viewWithTag:TAG_OFFSET + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
        
		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;
            
			toViewController.view.frame = rect;
			tabButtonsContainerView.userInteractionEnabled = NO;
            
			[self transitionFromViewController:fromViewController
                              toViewController:toViewController
                                      duration:0.3
                                       options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
                                    animations:^
             {
                 CGRect rect = fromViewController.view.frame;
                 if (oldSelectedIndex < newSelectedIndex)
                     rect.origin.x = -rect.size.width;
                 else
                     rect.origin.x = rect.size.width;
                 
                 fromViewController.view.frame = rect;
                 toViewController.view.frame = contentContainerView.bounds;
                 [self centerIndicatorOnButton:toButton];
             }
                                    completion:^(BOOL finished)
             {
                 tabButtonsContainerView.userInteractionEnabled = YES;
                 
                 if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
                     [self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
             }];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];
            
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
            
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return [self.viewControllers objectAtIndex:self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated;
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}

- (void)tabButtonPressed:(UIButton *)sender
{
	[self setSelectedIndex:sender.tag - TAG_OFFSET animated:YES];
}

@end

