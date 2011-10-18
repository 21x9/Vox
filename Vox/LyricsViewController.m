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
@property (nonatomic, strong) NSArray *toolbarItems;

- (void)configureUI;

@end

#pragma mark -

@implementation LyricsViewController

@synthesize song;
@synthesize toolbar;
@synthesize songTitleLabel;
@synthesize artistNameLabel;
@synthesize albumArtImageView;
@synthesize lyricsTextView;

@synthesize textOptionsButton;
@synthesize songsPopover;
@synthesize toolbarItems;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.toolbar setItems:self.toolbarItems animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    self.toolbar = nil;
    self.songTitleLabel = nil;
    self.artistNameLabel = nil;
    self.albumArtImageView = nil;
    self.lyricsTextView = nil;
    
    [super viewDidUnload];
}

#pragma mark - Text Options
- (void)showTextOptions
{
    //
}

#pragma mark - UISplitViewControllerDelegate Helpers
static UIBarButtonItem *flexibleSpace = nil;

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    if (!flexibleSpace)
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    barButtonItem.title = NSLocalizedString(@"Songs", @"Songs");
    
    NSArray *items = [NSArray arrayWithObjects:barButtonItem, flexibleSpace, self.textOptionsButton, nil];
    
    if (!self.view)
        self.toolbarItems = items;
    else
        [self.toolbar setItems:items animated:YES];
    
    self.songsPopover = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    if (!flexibleSpace)
        flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, self.textOptionsButton, nil] animated:YES];
    
    self.songsPopover = nil;
}

@end
