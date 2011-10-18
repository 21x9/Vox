//
//  EditSongViewController.m
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "EditSongViewController.h"
#import "Song.h"
#import "Artist.h"

@implementation EditSongViewController

@synthesize song;
@synthesize albumArtImageView;
@synthesize titleTextField;
@synthesize artistTextField;
@synthesize delegate;
@synthesize lyricsTextView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.delegate editSongViewController:self didBeginEditingSong:self.song];
}

- (void)viewDidUnload
{
    self.albumArtImageView = nil;
    self.titleTextField = nil;
    self.artistTextField = nil;
    
    [self setLyricsTextView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)save:(id)sender
{
    self.song.title = self.titleTextField.text;
    self.song.artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.song.managedObjectContext];
    self.song.artist.name = self.artistTextField.text;
    self.song.lyrics = self.lyricsTextView.text;
    [self.delegate editSongViewController:self didSaveSong:self.song successfully:YES];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate editSongViewController:self didSaveSong:self.song successfully:NO];
}

@end
