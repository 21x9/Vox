//
//  EditSongViewController.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditSongViewControllerDelegate;

@class Song;

@interface EditSongViewController : UIViewController

@property (strong, nonatomic) Song *song;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) id <EditSongViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *lyricsTextView;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol EditSongViewControllerDelegate <NSObject>

- (void)editSongViewController:(EditSongViewController *)controller didBeginEditingSong:(Song *)song;
- (void)editSongViewController:(EditSongViewController *)controller didSaveSong:(Song *)song successfully:(BOOL)success;

@end
