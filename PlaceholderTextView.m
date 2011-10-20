//
//  placeholderTextView.m
//  Vox
//
//  Created by Mark Adams on 10/19/11.
//  Copyright (c) 2011 Interstellar Apps. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()

@property (strong, nonatomic) UILabel *placeholderLabel;

- (void)setupPlaceholderLabel;

@end

#pragma mark -

@implementation PlaceholderTextView

@synthesize placeholder;

@synthesize placeholderLabel;

#pragma mark - Initialization
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (!self)
        return nil;
    
    [self setupPlaceholderLabel];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self)
        return nil;
    
    [self setupPlaceholderLabel];
    
    return self;
}

- (void)setupPlaceholderLabel
{
    placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, 8.0f, 0.0f, 0.0f)];
    placeholderLabel.text = NSLocalizedString(@"Enter lyrics...", @"Enter lyrics...");
    placeholderLabel.textColor = [UIColor colorWithRed:172.0f/255.0f green:172.0f/255.0f blue:172.0f/255.0f alpha:1.0f];
    placeholderLabel.font = self.font;
    [placeholderLabel sizeToFit];
    
    if (self.hasText)
        placeholderLabel.hidden = YES;
    
    [self addSubview:placeholderLabel];
}

#pragma mark - Setters
- (void)setPlaceholder:(NSString *)placeholderString
{
    if (placeholder == placeholderString)
        return;
    
    placeholder = placeholderString;
    self.placeholderLabel.text = placeholder;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    self.placeholderLabel.hidden = self.hasText;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    self.placeholderLabel.hidden = YES;
    
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    self.placeholderLabel.hidden = self.hasText;
    
    return YES;
}

@end
