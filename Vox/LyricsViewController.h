//
//  LyricsViewController.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Song;

@interface LyricsViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Song *song;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *songsButton;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
