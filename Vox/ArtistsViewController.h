//
//  ArtistsViewController.h
//  Vox
//
//  Created by Mark Adams on 10/19/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Artist;

typedef void (^ArtistsViewControllerSelectedArtistBlock)(Artist *artist);

@interface ArtistsViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (copy, nonatomic) NSString *searchFilter;
@property (copy, nonatomic) ArtistsViewControllerSelectedArtistBlock selectedArtistBlock;

@end
