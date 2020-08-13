//
//  FirstViewController.m
//  LNPopupControllerExample
//
//  Created by Leo Natan on 7/16/15.
//  Copyright © 2015 Leo Natan. All rights reserved.
//

@import LNPopupController;
#import "FirstViewController.h"
#import "DemoPopupContentViewController.h"
#import "LoremIpsum.h"
#import "RandomColors.h"
#import "SettingsTableViewController.h"
@import UIKit;

@interface TabBar : UITabBar @end
@implementation TabBar

- (void)setFrame:(CGRect)frame
{
//	NSLog(@"🤦‍♂️ frame: %@ safe area: %@", @(frame), [self valueForKey:@"safeAreaInsets"]);

	[super setFrame:frame];
}

@end

@interface DemoGalleryControllerTableView : UITableView @end
@implementation DemoGalleryControllerTableView

- (BOOL)canBecomeFocused
{
	return NO;
}

@end

@interface DemoGalleryController : UITableViewController @end
@implementation DemoGalleryController

- (IBAction)unwindToGallery:(UIStoryboardSegue *)unwindSegue { }

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if(segue.destinationViewController.modalPresentationStyle != UIModalPresentationFullScreen)
	{
		[self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section != 0 || indexPath.row != [tableView numberOfRowsInSection:0] - 1)
	{
		return;
	}
	
	UITabBarController* tvc = [UITabBarController new];
	tvc.modalPresentationStyle = UIModalPresentationFullScreen;
	
	UIViewController* vc1 = [UIViewController new];
	vc1.view.backgroundColor = UIColor.redColor;
	
	if(@available(iOS 14.0, *))
	{
		UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithPrimaryAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
			[self dismissViewControllerAnimated:YES completion:nil];
		}]];
		item.title = @"Gallery";
		item.style = UIBarButtonItemStyleDone;
		
		vc1.navigationItem.rightBarButtonItem = item;
	}
	
	UIViewController* vc2 = [UIViewController new];
	vc2.view.backgroundColor = UIColor.greenColor;
	vc2.hidesBottomBarWhenPushed = YES;
	
	UINavigationController* nvc = [UINavigationController new];
	nvc.viewControllers = @[vc1];
	nvc.tabBarItem.title = @"Navigation Bar";
	if(@available(iOS 13.0, *))
	{
		nvc.tabBarItem.image = [UIImage systemImageNamed:@"star"];
	}
	
	tvc.viewControllers = @[nvc];
	
	[self presentViewController:tvc animated:YES completion:^{
		UIViewController* demoVC = [DemoPopupContentViewController new];
		
		if (@available(iOS 13.0, *)) {
			demoVC.view.backgroundColor = LNRandomDarkColor();
		} else {
			demoVC.view.backgroundColor = LNRandomDarkColor();
		}
		
		if([NSUserDefaults.standardUserDefaults boolForKey:@"NSForceRightToLeftWritingDirection"])
		{
			demoVC.popupItem.title = @"עברית";//[LoremIpsum sentence];
			demoVC.popupItem.subtitle = @"עברית";//[LoremIpsum sentence];
		}
		else
		{
			demoVC.popupItem.title = [LoremIpsum sentence];
			demoVC.popupItem.subtitle = [LoremIpsum sentence];
		}
		demoVC.popupItem.image = [UIImage imageNamed:@"genre7"];
		demoVC.popupItem.progress = (float) arc4random() / UINT32_MAX;
		
		[tvc presentPopupBarWithContentViewController:demoVC animated:YES completion:^{
			[nvc pushViewController:vc2 animated:YES];
		}];
	}];
}

@end

@interface FirstView : UIView @end

@implementation FirstView

- (void)willMoveToWindow:(UIWindow *)newWindow
{
	[super willMoveToWindow:newWindow];
}

- (void)didMoveToWindow
{
	[super didMoveToWindow];
}

@end

@interface FirstViewController () <UIContextMenuInteractionDelegate, LNPopupPresentationDelegate>

@end

@implementation FirstViewController
{
	__weak IBOutlet UIButton *_galleryButton;
	__weak IBOutlet UIButton *_nextButton;
	
	__weak IBOutlet UIBarButtonItem *_barStyleButton;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (@available(iOS 13.0, *)) {
		self.view.backgroundColor = LNRandomAdaptiveColor();
		
		_barStyleButton.title = NSLocalizedString(@"Style", @"");
	} else {
		self.view.backgroundColor = LNRandomLightColor();
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	//Ugly hack to fix tab bar tint color.
	self.tabBarController.view.tintColor = self.view.tintColor;
	//Ugly hack to fix split view controller tint color.
	self.splitViewController.view.tintColor = self.view.tintColor;
	
	_galleryButton.hidden = [self.parentViewController isKindOfClass:[UINavigationController class]];
	_nextButton.hidden = self.splitViewController != nil;
	
	[self _presentBar:nil animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (IBAction)_changeBarStyle:(id)sender
{
	if (@available(iOS 13.0, *))
	{
		UIUserInterfaceStyle currentStyle = self.navigationController.traitCollection.userInterfaceStyle;
		
		self.navigationController.overrideUserInterfaceStyle = currentStyle == UIUserInterfaceStyleLight ? UIUserInterfaceStyleDark : UIUserInterfaceStyleLight;
	}
	else
	{
		self.navigationController.toolbar.barStyle = 1 - self.navigationController.toolbar.barStyle;
	}
	
	if (@available(iOS 13.0, *))
	{
		self.navigationController.toolbar.tintColor = LNRandomAdaptiveInvertedColor();
	}
	else
	{
		self.navigationController.toolbar.tintColor = self.navigationController.toolbar.barStyle ? LNRandomLightColor() : LNRandomDarkColor();
	}
	[self.navigationController.toolbar.items enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		obj.tintColor = self.navigationController.toolbar.tintColor;
	}];
	self.navigationController.navigationBar.barStyle = self.navigationController.toolbar.barStyle;
	self.navigationController.navigationBar.tintColor = self.navigationController.toolbar.tintColor;
	
	[self.navigationController updatePopupBarAppearance];
}

- (UIViewController*)_targetVCForPopup
{
	UIViewController* targetVC = self.navigationController == nil ? self.splitViewController != self.view.window.rootViewController ? self.splitViewController : nil : nil;
	
	if(targetVC == nil)
	{
		targetVC = self.tabBarController;
		if(targetVC == nil)
		{
			targetVC = self.navigationController;
			
			if(targetVC == nil)
			{
				targetVC = self;
			}
		}
	}
	
	return targetVC;
}

- (IBAction)_presentBar:(id)sender
{
	[self _presentBar:sender animated:YES];
}

- (void)_presentBar:(id)sender animated:(BOOL)animated;
{
	//All this logic is just so I can use the same controllers over and over in all examples. :-)
	
	if(sender == nil &&
	   self.navigationController == nil &&
	   self.splitViewController != nil &&
	   self.splitViewController != self.view.window.rootViewController &&
	   self != self.splitViewController.viewControllers.firstObject)
	{
		return;
	}
	
	UIViewController* targetVC = [self _targetVCForPopup];
	
	if(targetVC.popupContentViewController != nil)
	{
		return;
	}
	
	if(targetVC == self.navigationController && self.navigationController.viewControllers.count > 1 && self.splitViewController == nil)
	{
		return;
	}
	
//	UIViewController* demoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
	UIViewController* demoVC = [DemoPopupContentViewController new];
	
	if (@available(iOS 13.0, *)) {
		demoVC.view.backgroundColor = LNRandomDarkColor();
	} else {
		demoVC.view.backgroundColor = LNRandomDarkColor();
	}
	
	if([NSUserDefaults.standardUserDefaults boolForKey:@"NSForceRightToLeftWritingDirection"])
	{
		demoVC.popupItem.title = @"עברית";//[LoremIpsum sentence];
		demoVC.popupItem.subtitle = @"עברית";//[LoremIpsum sentence];
	}
	else
	{
		demoVC.popupItem.title = [LoremIpsum sentence];
		demoVC.popupItem.subtitle = [LoremIpsum sentence];
	}
	demoVC.popupItem.image = [UIImage imageNamed:@"genre7"];
	demoVC.popupItem.progress = (float) arc4random() / UINT32_MAX;
	
	UILabel* topLabel = [UILabel new];
	topLabel.text = NSLocalizedString(@"Top", @"");
	topLabel.textColor = [UIColor whiteColor];
	topLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
	topLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[demoVC.view addSubview:topLabel];
	[NSLayoutConstraint activateConstraints:@[
		[topLabel.topAnchor constraintEqualToAnchor:demoVC.view.safeAreaLayoutGuide.topAnchor],
		[topLabel.centerXAnchor constraintEqualToAnchor:demoVC.view.safeAreaLayoutGuide.centerXAnchor constant:40]
	]];
	
	UILabel* bottomLabel = [UILabel new];
	bottomLabel.text = NSLocalizedString(@"Bottom", @"");
	bottomLabel.textColor = [UIColor whiteColor];
	bottomLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
	bottomLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[demoVC.view addSubview:bottomLabel];
	[NSLayoutConstraint activateConstraints:@[
		[bottomLabel.bottomAnchor constraintEqualToAnchor:demoVC.view.safeAreaLayoutGuide.bottomAnchor],
		[bottomLabel.centerXAnchor constraintEqualToAnchor:demoVC.view.safeAreaLayoutGuide.centerXAnchor]
	]];
	
	demoVC.popupItem.accessibilityLabel = NSLocalizedString(@"Custom popup bar accessibility label", @"");
	demoVC.popupItem.accessibilityHint = NSLocalizedString(@"Custom popup bar accessibility hint", @"");
	
	targetVC.popupContentView.popupCloseButton.accessibilityLabel = NSLocalizedString(@"Custom popup button accessibility label", @"");
	targetVC.popupContentView.popupCloseButton.accessibilityHint = NSLocalizedString(@"Custom popup button accessibility hint", @"");
	
//	targetVC.popupBar.previewingDelegate = self;
	targetVC.popupBar.progressViewStyle = [[[NSUserDefaults standardUserDefaults] objectForKey:PopupSettingsProgressViewStyle] unsignedIntegerValue];
	targetVC.popupBar.barStyle = [[[NSUserDefaults standardUserDefaults] objectForKey:PopupSettingsBarStyle] unsignedIntegerValue];
	targetVC.popupInteractionStyle = [[[NSUserDefaults standardUserDefaults] objectForKey:PopupSettingsInteractionStyle] unsignedIntegerValue];
	targetVC.popupContentView.popupCloseButtonStyle = [[[NSUserDefaults standardUserDefaults] objectForKey:PopupSettingsCloseButtonStyle] unsignedIntegerValue];
	
	NSNumber* marqueeEnabledSetting = [[NSUserDefaults standardUserDefaults] objectForKey:PopupSettingsMarqueeStyle];
	if(marqueeEnabledSetting && [marqueeEnabledSetting isEqualToNumber:@0] == NO)
	{
		targetVC.popupBar.marqueeScrollEnabled = [marqueeEnabledSetting unsignedIntegerValue] - 1;
	}
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:PopupSettingsEnableCustomizations])
	{
		NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		paragraphStyle.alignment = NSTextAlignmentRight;
		paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
		
		[targetVC.popupBar setTitleTextAttributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: [UIFont fontWithName:@"Chalkduster" size:14], NSForegroundColorAttributeName: [UIColor yellowColor]}];
		[targetVC.popupBar setSubtitleTextAttributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: [UIFont fontWithName:@"Chalkduster" size:12], NSForegroundColorAttributeName: [UIColor greenColor]}];
		[targetVC.popupBar setBackgroundStyle:UIBlurEffectStyleDark];
		[targetVC.popupBar setTintColor:[UIColor yellowColor]];
	}
	
	if (@available(iOS 13.0, *))
	{
		UIContextMenuInteraction* i = [[UIContextMenuInteraction alloc] initWithDelegate:self];
		[targetVC.popupBar addInteraction:i];
	}

	targetVC.popupPresentationDelegate = self;
	[targetVC presentPopupBarWithContentViewController:demoVC animated:animated completion:nil];
}

- (IBAction)_dismissBar:(id)sender
{
	__kindof UIViewController* targetVC = self.tabBarController;
	if(targetVC == nil)
	{
		targetVC = self.navigationController;
		
		if(targetVC == nil)
		{
			targetVC = self;
		}
	}
	
	[targetVC dismissPopupBarAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

#pragma mark UIContextMenuInteractionDelegate

- (nullable UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location API_AVAILABLE(ios(13.0))
{
	return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:nil];
}

- (void)contextMenuInteraction:(UIContextMenuInteraction *)interaction willEndForConfiguration:(UIContextMenuConfiguration *)configuration animator:(nullable id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.0))
{
	[animator addCompletion:^{
		UIActivityViewController* avc = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:@"https://github.com/LeoNatan/LNPopupController"]] applicationActivities:nil];
		avc.modalPresentationStyle = UIModalPresentationFormSheet;
		avc.popoverPresentationController.sourceView = [self _targetVCForPopup].popupBar;
		[self presentViewController:avc animated:YES completion:nil];
	}];
}

#pragma mark LNPopupPresentationDelegate

- (void)popupPresentationControllerWillPresentPopupBar:(UIViewController*)popupPresentationController animated:(BOOL)animated
{
	
}

- (void)popupPresentationControllerDidPresentPopupBar:(UIViewController*)popupPresentationController animated:(BOOL)animated
{

}

- (void)popupPresentationControllerWillDismissPopupBar:(UIViewController*)popupPresentationController animated:(BOOL)animated
{

}

- (void)popupPresentationControllerDidDismissPopupBar:(UIViewController*)popupPresentationController animated:(BOOL)animated
{
	
}

- (void)popupPresentationControllerWillOpenPopup:(UIViewController*)popupPresentationController animated:(BOOL)animated
{
	
}

- (void)popupPresentationControllerDidOpenPopup:(UIViewController*)popupPresentationController animated:(BOOL)animated
{
	
}

- (void)popupPresentationControllerWillClosePopup:(UIViewController*)popupPresentationController animated:(BOOL)animated
{

}

- (void)popupPresentationControllerDidClosePopup:(UIViewController*)popupPresentationController animated:(BOOL)animated
{
	
}

@end
