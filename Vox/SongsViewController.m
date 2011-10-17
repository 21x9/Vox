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

@interface SongsViewController ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(SongCell *)cell forIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark -

@implementation SongsViewController

@synthesize managedObjectContext;

@synthesize fetchedResultsController;

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

#pragma mark - View Lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.fetchedResultsController.fetchedObjects.count)
    {
        Artist *artist = [NSEntityDescription insertNewObjectForEntityForName:@"Artist" inManagedObjectContext:self.managedObjectContext];
        artist.name = @"Aerosmith";
        
        Song *song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.managedObjectContext];
        song.title = @"Last Child";
        song.lyrics = @"Lyrics";
        song.artist = artist;
        
        Song *anotherSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:self.managedObjectContext];
        anotherSong.title = @"Toys In The Attic";
        anotherSong.lyrics = @"Lyrics";
        anotherSong.artist = artist;
        
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error])
            NSLog(@"Couldn't save placeholder data. %@, %@", error, error.userInfo);
    }
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
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{        
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(SongCell *)[self.tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
