//
//  EditSongViewController.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Song;

typedef void (^EditSongViewControllerSaveBlock)(Song *song);
typedef void (^EditSongViewControllerCancelBlock)();

@interface EditSongViewController : UIViewController

@property (strong, nonatomic) Song *song;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) IBOutlet UITextView *lyricsTextView;
@property (copy, nonatomic) EditSongViewControllerSaveBlock saveBlock;
@property (copy, nonatomic) EditSongViewControllerCancelBlock cancelBlock;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end