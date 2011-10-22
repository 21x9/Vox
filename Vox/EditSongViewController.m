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
#import "PlaceholderTextView.h"
#import "ArtistsViewController.h"

@interface EditSongViewController ()

@property (strong, nonatomic) ArtistsViewController *artistsViewController;
@property (strong, nonatomic) UIPopoverController *artistsPopover;

- (void)populateUI;
- (void)updateSaveButtonStatus;
- (Artist *)artistWithName:(NSString *)artistName;

@end

#pragma mark -

@implementation EditSongViewController

@synthesize song;
@synthesize albumArtImageView;
@synthesize titleTextField;
@synthesize artistTextField;
@synthesize lyricsTextView;
@synthesize saveBlock;
@synthesize cancelBlock;
@synthesize saveButton;

@synthesize artistsViewController;
@synthesize artistsPopover;

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self populateUI];
    [self updateSaveButtonStatus];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        CGRect startingFrame = [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endingFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve animationCurve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        startingFrame = [self.view convertRect:startingFrame fromView:nil];
        endingFrame = [self.view convertRect:endingFrame fromView:nil];
                
        CGRect viewFrame = self.lyricsTextView.frame;
        viewFrame.size.height = endingFrame.origin.y - viewFrame.origin.y;
        
        [UIView animateWithDuration:duration delay:0.0 options:animationCurve animations:^{
            self.lyricsTextView.frame = viewFrame;
        } completion:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

- (void)viewDidUnload
{
    self.albumArtImageView = nil;
    self.titleTextField = nil;
    self.artistTextField = nil;
    self.lyricsTextView = nil;
    self.saveButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![segue.identifier isEqualToString:@"ShowArtists"])
        return;
    
    UIStoryboardPopoverSegue *popoverSegue = (UIStoryboardPopoverSegue *)segue;
    self.artistsPopover = popoverSegue.popoverController;
    self.artistsViewController = (ArtistsViewController *)self.artistsPopover.contentViewController;
    self.artistsViewController.managedObjectContext = self.song.managedObjectContext;
    self.artistsViewController.searchFilter = self.artistTextField.text;
    
    __weak EditSongViewController *weakSelf = self;
    
    self.artistsViewController.selectedArtistBlock = ^(Artist *artist) {
        weakSelf.artistTextField.text = artist.name;
        [weakSelf.artistsPopover dismissPopoverAnimated:YES];
        weakSelf.artistsPopover = nil;
    };
}

#pragma mark - UI Helpers
- (void)populateUI
{
    self.titleTextField.text = self.song.title;
    self.artistTextField.text = self.song.artist.name;
    self.lyricsTextView.text = self.song.lyrics;
    self.albumArtImageView.image = [UIImage imageNamed:@"AlbumPlaceholder"];
    
    if (self.song.albumArt)
        self.albumArtImageView.image = [UIImage imageWithData:self.song.albumArt];
}

- (void)updateSaveButtonStatus
{
    BOOL enabled = YES;
    
    if (!self.titleTextField.text.length || !self.artistTextField.text.length || !self.lyricsTextView.hasText)
        enabled = NO;
    
    self.saveButton.enabled = enabled;
}

#pragma mark - Interface Actions
- (IBAction)save:(id)sender
{
    [self.view endEditing:NO];
    self.song.title = self.titleTextField.text;
    self.song.artist = [self artistWithName:self.artistTextField.text];
    self.song.lyrics = self.lyricsTextView.text;
    self.saveBlock(self.song);
}

- (Artist *)artistWithName:(NSString *)artistName
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
    request.includesSubentities = NO;
    request.predicate = [NSPredicate predicateWithFormat:@"name like[cd] %@", artistName];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    NSError *error = nil;
    NSArray *artists = [self.song.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!artists.count)
    {
        Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.song.managedObjectContext];
        artist.name = artistName;
        return artist;
    }
    
    return [artists objectAtIndex:0];
}

- (IBAction)cancel:(id)sender
{
    [self.view endEditing:NO];
    
    if (!self.song.title)
        [self.song.managedObjectContext deleteObject:self.song];
    
    self.cancelBlock();
}

- (IBAction)textFieldEditingChanged:(UITextField *)sender
{
    [self updateSaveButtonStatus];
    
    if (sender != self.artistTextField)
        return;
    
    if (!self.artistsPopover)
        [self performSegueWithIdentifier:@"ShowArtists" sender:self];
    
    self.artistsViewController.searchFilter = self.artistTextField.text;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField != self.artistTextField)
        return;
    
    [self performSegueWithIdentifier:@"ShowArtists" sender:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.artistsPopover dismissPopoverAnimated:YES];
    self.artistsPopover = nil;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self updateSaveButtonStatus];
}

@end
