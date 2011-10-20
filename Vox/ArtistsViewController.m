//
//  ArtistsViewController.m
//  Vox
//
//  Created by Mark Adams on 10/19/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "ArtistsViewController.h"
#import "Artist.h"

@interface ArtistsViewController ()

@property (strong, nonatomic) NSArray *allArtists;
@property (strong, nonatomic) NSArray *filteredArtists;

- (void)populateArtists;

@end

#pragma mark -

@implementation ArtistsViewController

@synthesize managedObjectContext;
@synthesize searchFilter;
@synthesize selectedArtistBlock;

@synthesize allArtists;
@synthesize filteredArtists;

#pragma mark - Initialization
- (void)populateArtists
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Artist"];
    fetchRequest.predicate = nil;
    fetchRequest.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error = nil;
    self.allArtists = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.filteredArtists = self.allArtists;
    
    if (!self.allArtists)
        NSLog(@"Could not fetch artists. %@, %@", error, error.userInfo);
}

#pragma mark - Setters
- (void)setSearchFilter:(NSString *)newSearchFilter
{
    if (searchFilter == newSearchFilter)
        return;
    
    searchFilter = newSearchFilter;
    
    if (!searchFilter.length)
        self.filteredArtists = self.allArtists;
    else
        self.filteredArtists = [self.allArtists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name beginswith[cd] %@", searchFilter]];
}

- (void)setFilteredArtists:(NSArray *)newFilteredArtists
{
    if (filteredArtists == newFilteredArtists)
        return;
    
    filteredArtists = newFilteredArtists;
    [self.tableView reloadData];
}

#pragma mark - View Lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self populateArtists];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredArtists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ArtistCell"];
    Artist *artist = [self.filteredArtists objectAtIndex:indexPath.row];
    cell.textLabel.text = artist.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Artist *artist = [self.filteredArtists objectAtIndex:indexPath.row];
    self.selectedArtistBlock(artist);
}

@end
