//
//  AppDelegate.m
//  Vox
//
//  Created by Mark Adams on 10/16/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "AppDelegate.h"
#import "SongsViewController.h"
#import "LyricsViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UISplitViewController *svc = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *nav = [svc.viewControllers objectAtIndex:0];
    SongsViewController *songsVC = (SongsViewController *)nav.topViewController;
    songsVC.managedObjectContext = self.managedObjectContext;
    LyricsViewController *lyricsVC = [svc.viewControllers lastObject];
    svc.delegate = lyricsVC;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)saveContext
{
    if (!self.managedObjectContext)
        return;
    
    if (!self.managedObjectContext.hasChanges)
        return;
    
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error])
        NSLog(@"Could not save context. %@, %@", error, error.userInfo);
}

#pragma mark - Core Data Stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (!managedObjectContext)
    {
        if (!self.persistentStoreCoordinator)
            return nil;
        
        managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!managedObjectModel)
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Vox" withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!persistentStoreCoordinator)
    {
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Vox.sqlite"];
        NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        NSError *error = nil;
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
        {
            NSLog(@"Could not add persistent store to coordinator. %@, %@", error, error.userInfo);
            return nil;
        }
    }
    
    return persistentStoreCoordinator;
}

#pragma mark - Application's Documents Directory
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
