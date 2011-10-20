//
//  LyricsViewController.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSongViewController.h"

typedef void (^LyricsViewControllerEditSongBlock)();

@class Song;

@interface LyricsViewController : UIViewController <UISplitViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Song *song;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (weak, nonatomic) IBOutlet UITextView *lyricsTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *flexibleSpace;
@property (copy, nonatomic) LyricsViewControllerEditSongBlock editSongBlock;

- (IBAction)editSong:(id)sender;

@end