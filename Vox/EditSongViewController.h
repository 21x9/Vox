//
//  EditSongViewController.h
//  Vox
//
//  Created by Mark Adams on 10/17/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Song;
@class PlaceholderTextView;

typedef void (^EditSongViewControllerSaveBlock)(Song *song);
typedef void (^EditSongViewControllerCancelBlock)();

@interface EditSongViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) Song *song;
@property (weak, nonatomic) IBOutlet UIImageView *albumArtImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *lyricsTextView;
@property (copy, nonatomic) EditSongViewControllerSaveBlock saveBlock;
@property (copy, nonatomic) EditSongViewControllerCancelBlock cancelBlock;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)textFieldEditingChanged:(UITextField *)sender;

@end