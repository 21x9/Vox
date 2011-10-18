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
@synthesize flexibleSpace;

@synthesize textOptionsButton;

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
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidUnload
{
    self.toolbar = nil;
    self.songTitleLabel = nil;
    self.artistNameLabel = nil;
    self.albumArtImageView = nil;
    self.lyricsTextView = nil;
    self.flexibleSpace = nil;
    
    [super viewDidUnload];
}

#pragma mark - Text Options
- (void)showTextOptions
{
    //
}

#pragma mark - UISplitViewControllerDelegate Helpers
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

@end
