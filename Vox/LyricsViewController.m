//
//  LyricsViewController.m
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "LyricsViewController.h"

@implementation LyricsViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController
{
    //
}

@end
