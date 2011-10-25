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

@property (strong, nonatomic) UIBarButtonItem *textOptionsButton;

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
@synthesize editSongBlock;
@synthesize editSongButton;

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
    if (!self.song.title)
    {
        self.navigationItem.rightBarButtonItem = nil;
        self.songTitleLabel.text = NSLocalizedString(@"No Song Selected", @"No Song Selected");
        self.artistNameLabel.text = NSLocalizedString(@"Add or select a song to get started", @"Add or select a song to get started");
        self.lyricsTextView.text = nil;
        self.albumArtImageView.image = [UIImage imageNamed:@"AlbumPlaceholder"];
        return;
    }
    
    self.navigationItem.rightBarButtonItem = self.editSongButton;
    self.songTitleLabel.text = self.song.title;
    self.artistNameLabel.text = self.song.artist.name;
    self.lyricsTextView.text = self.song.lyrics;
    
    if (self.song.albumArt)
        self.albumArtImageView.image = [UIImage imageWithData:self.song.albumArt];
    else
        self.albumArtImageView.image = [UIImage imageNamed:@"AlbumPlaceholder"];
}

#pragma mark - View Lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self configureUI]; 
        });
    }];
}

- (void)viewDidUnload
{
    self.toolbar = nil;
    self.songTitleLabel = nil;
    self.artistNameLabel = nil;
    self.albumArtImageView = nil;
    self.lyricsTextView = nil;
    self.flexibleSpace = nil;
    self.editSongButton = nil;
    
    [super viewDidUnload];
}

#pragma mark - Song Editing
- (IBAction)editSong:(id)sender
{
    self.editSongBlock();
}

#pragma mark - UISplitViewControllerDelegate Helpers
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}


@end
