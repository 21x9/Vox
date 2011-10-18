//
//  SongsViewController.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSongViewController.h"

@interface SongsViewController : UITableViewController <NSFetchedResultsControllerDelegate, EditSongViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)addSong;

@end
