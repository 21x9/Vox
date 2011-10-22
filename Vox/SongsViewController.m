//
//  SongsViewController.m
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "SongsViewController.h"
#import "SongCell.h"
#import "Artist.h"
#import "Song.h"
#import "LyricsViewController.h"
#import "EditSongViewController.h"
#import "AlbumArtSearch.h"

@interface SongsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) LyricsViewController *lyricsViewController;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (assign, nonatomic) BOOL editingSong;

- (void)updateLeftBarButtonState;
- (void)updateRightBarButtonState;
- (void)editSong:(Song *)aSong;
- (void)selectSongAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(SongCell *)cell forIndexPath:(NSIndexPath *)indexPath;
- (void)updateAlbumArtForSong:(Song *)aSong;

@end

#pragma mark -

@implementation SongsViewController

@synthesize managedObjectContext;
@synthesize addSongButton;

@synthesize fetchedResultsController;
@synthesize lyricsViewController;
@synthesize selectedIndexPath;
@synthesize editingSong;

#pragma mark - Getters
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"uppercaseFirstLetter" cacheName:nil];
        fetchedResultsController.delegate = self;
        
        NSError *error = nil;
        
        if (![fetchedResultsController performFetch:&error])
            NSLog(@"Couldn't perform fetch. %@, %@", error, error.userInfo);
    }
    
    return fetchedResultsController;
}

- (LyricsViewController *)lyricsViewController
{
    if (!lyricsViewController)
    {
        UINavigationController *nav = (UINavigationController *)[self.splitViewController.viewControllers lastObject];
        lyricsViewController = (LyricsViewController *)nav.topViewController;
        
        __weak SongsViewController *weakSelf = self;
        
        lyricsViewController.editSongBlock = ^{
            [weakSelf editSong:[weakSelf.fetchedResultsController objectAtIndexPath:[weakSelf.tableView indexPathForSelectedRow]]];
        };
    }
    
    return lyricsViewController;
}

#pragma mark - Setters
- (void)setEditingSong:(BOOL)editingSongFlag
{
    editingSong = editingSongFlag;
    [self updateLeftBarButtonState];
    [self updateRightBarButtonState];
}

#pragma mark - View Lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.fetchedResultsController.fetchedObjects.count)
        [self addSong];
    else
    {
        self.lyricsViewController.song = nil;
        self.editingSong = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:nil usingBlock:^(NSNotification *notification) {
        CGRect startingFrame = [[notification.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        CGRect endingFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval duration = [[notification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve animationCurve = [[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        startingFrame = [self.view convertRect:startingFrame fromView:nil];
        endingFrame = [self.view convertRect:endingFrame fromView:nil];
        
        CGRect viewFrame = self.tableView.frame;
        viewFrame.size.height = endingFrame.origin.y - viewFrame.origin.y;
        
        [UIView animateWithDuration:duration delay:0.0 options:animationCurve animations:^{
            self.tableView.frame = viewFrame;
        } completion:nil];
    }];
}

- (void)viewDidUnload
{
    self.addSongButton = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [super viewDidUnload];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self updateRightBarButtonState];
}

#pragma mark - UI Helpers
- (void)updateLeftBarButtonState
{
    UIBarButtonItem *buttonItem = nil;
    
    if (!self.editingSong && self.fetchedResultsController.sections.count)
        buttonItem = self.editButtonItem;
    
    [self.navigationItem setLeftBarButtonItem:buttonItem animated:YES];
}

- (void)updateRightBarButtonState
{
    UIBarButtonItem *buttonItem = nil;
    
    if (!self.editing && !self.editingSong)
        buttonItem = self.addSongButton;
    
    [self.navigationItem setRightBarButtonItem:buttonItem animated:YES];
}

#pragma mark - Add Song
- (void)editSong:(Song *)aSong
{
    EditSongViewController *esvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditSongViewController"];
    esvc.song = aSong;
    esvc.saveBlock = ^(Song *song) {
        self.editingSong = NO;
        [self.lyricsViewController.navigationController popViewControllerAnimated:NO];
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error])
            NSLog(@"Couldn't save song. %@, %@", error, error.userInfo);
        
        [self selectSongAtIndexPath:[self.fetchedResultsController indexPathForObject:song]];
        [self updateAlbumArtForSong:song];
    };
    esvc.cancelBlock = ^{
        self.editingSong = NO;
        [self.lyricsViewController.navigationController popViewControllerAnimated:NO];
    };
    
    [self.lyricsViewController.navigationController pushViewController:esvc animated:NO];
    self.editingSong = YES;
}

- (void)addSong
{
    [self editSong:[NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.managedObjectContext]];
}

- (void)selectSongAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.lyricsViewController.song = song;
}

#pragma mark - UITableView Helper
- (void)configureCell:(SongCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    Song *song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self updateAlbumArtForSong:song];    
    cell.song = song;
}

- (void)updateAlbumArtForSong:(Song *)aSong
{
    if (aSong.albumArt)
        return;
    
    AlbumArtSearch *search = [[AlbumArtSearch alloc] init];
    [search searchAlbumArtForSong:aSong completionBlock:^{
        [self.managedObjectContext performBlock:^{
            [self.managedObjectContext save:nil];
        }];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongCell *cell = (SongCell *)[tableView dequeueReusableCellWithIdentifier:@"SongCell"];    
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.fetchedResultsController.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[self.fetchedResultsController.sections objectAtIndex:section] name];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lyricsViewController.song = [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle != UITableViewCellEditingStyleDelete)
        return;
    
    [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error])
        NSLog(@"Could not delete object. %@, %@", error, error.userInfo);
}

#pragma mark - NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{        
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            self.selectedIndexPath = newIndexPath;
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(SongCell *)[self.tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            self.selectedIndexPath = newIndexPath;
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self updateLeftBarButtonState];
    [self selectSongAtIndexPath:self.selectedIndexPath];
}

@end
