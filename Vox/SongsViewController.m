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

@interface SongsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) LyricsViewController *lyricsViewController;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

- (void)addButtonVisible:(BOOL)visible;
- (void)editButtonVisible:(BOOL)visible;
- (void)configureCell:(SongCell *)cell forIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark -

@implementation SongsViewController

@synthesize managedObjectContext;
@synthesize addSongButton;

@synthesize fetchedResultsController;
@synthesize lyricsViewController;
@synthesize selectedIndexPath;

#pragma mark - Getters
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Song"];
        fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
        fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"SongsCache"];
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
    }
    
    return lyricsViewController;
}

#pragma mark - View Lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.fetchedResultsController.fetchedObjects.count)
        [self addSong];
}

- (void)viewDidUnload
{
    self.addSongButton = nil;
    
    [super viewDidUnload];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self addButtonVisible:!editing];
}

- (void)addButtonVisible:(BOOL)visible
{
    if (visible)
        [self.navigationItem setRightBarButtonItem:self.addSongButton animated:YES];
    else
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
}

- (void)editButtonVisible:(BOOL)visible
{
    if (visible)
        [self.navigationItem setLeftBarButtonItem:self.editButtonItem animated:YES];
    else
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
}

#pragma mark - Add Song
- (void)addSong
{
    [self addButtonVisible:NO];
    [self editButtonVisible:NO];
    
    EditSongViewController *esvc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditSongViewController"];
    esvc.song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.managedObjectContext];
    esvc.saveBlock = ^(Song *song) {
        [self addButtonVisible:YES];
        [self editButtonVisible:YES];
        [self.lyricsViewController.navigationController popViewControllerAnimated:NO];
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error])
            NSLog(@"Couldn't save song. %@, %@", error, error.userInfo);
    };
    esvc.cancelBlock = ^{
        [self addButtonVisible:YES];
        [self editButtonVisible:YES];
        [self.lyricsViewController.navigationController popViewControllerAnimated:NO];
    };
    
    [self.lyricsViewController.navigationController pushViewController:esvc animated:NO];
}

#pragma mark - UITableView Helper
- (void)configureCell:(SongCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.song = [self.fetchedResultsController objectAtIndexPath:indexPath];
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
    [self.tableView selectRowAtIndexPath:self.selectedIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    self.lyricsViewController.song = [self.fetchedResultsController objectAtIndexPath:self.selectedIndexPath];
}

@end
