//
//  LyricsViewController.m
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "LyricsViewController.h"
#import "Song.h"
#import "Artist.h"

@interface LyricsViewController ()

@property (nonatomic, strong) UIBarButtonItem *textOptionsButton;
@property (nonatomic, strong) UIPopoverController *songsPopover;

- (void)configureUI;

@end

#pragma mark -

@implementation LyricsViewController

@synthesize song;
@synthesize songsButton;
@synthesize toolbar;
@synthesize songTitleLabel;
@synthesize artistNameLabel;
@synthesize albumArtImageView;
@synthesize lyricsTextView;

@synthesize textOptionsButton;
@synthesize songsPopover;

#pragma mark - Getters
- (UIBarButtonItem *)textOptionsButton
{
    if (!textOptionsButton)
        textOptionsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"TextSizeButton"] style:UIBarButtonItemStylePlain target:self action:@selector(showTextOptions)];
    
    return textOptionsButton;
}

#pragma mark - Setters
- (void)setSong:(Song *)aSong
{
    if (song == aSong)
        return;
    
    song = aSong;
    [self configureUI];
    [self.songsPopover dismissPopoverAnimated:YES];
}

#pragma mark - View Configuration Helpers
- (void)configureUI
{
    if (self.song.albumArt)
        self.albumArtImageView.image = [UIImage imageWithData:self.song.albumArt];
    
    self.songTitleLabel.text = self.song.title;
    self.artistNameLabel.text = self.song.artist.name;
    self.lyricsTextView.text = self.song.lyrics;
}

#pragma mark - View Lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidUnload
{
    self.songsButton = nil;
    self.toolbar = nil;
    self.songTitleLabel = nil;
    self.artistNameLabel = nil;
    self.albumArtImageView = nil;
    self.lyricsTextView = nil;

    [super viewDidUnload];
}

#pragma mark - UISplitViewControllerDelegate Helpers
static UIBarButtonItem *flexibleSpace = nil;

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    if (!flexibleSpace)
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    barButtonItem.title = NSLocalizedString(@"Songs", @"Songs");
    self.toolbar.items = [NSArray arrayWithObjects:barButtonItem, flexibleSpace, self.textOptionsButton, nil];
    
    self.songsPopover = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (!flexibleSpace)
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbar.items = [NSArray arrayWithObjects:flexibleSpace, self.textOptionsButton, nil];
    
    self.songsPopover = nil;
}

@end
