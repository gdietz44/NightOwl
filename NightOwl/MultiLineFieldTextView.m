//
//  MultiLineFieldTextView.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/20/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "MultiLineFieldTextView.h"

@interface MultiLineFieldTextView()

@property (nonatomic) UILabel *placeholderLabel;
@end

@implementation MultiLineFieldTextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addPlaceholderLabel];
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.textColor = [UIColor darkGrayColor];
    self.tintColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
    self.layer.borderColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 8;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    self.placeholderLabel.text = placeholderText;
}

- (void)addPlaceholderLabel {
    self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, CGRectGetWidth(self.frame)-20.0, 20.0)];
    self.placeholderLabel.text = @"Add comment here";
    self.placeholderLabel.textColor = [UIColor lightGrayColor];
    self.placeholderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    self.placeholderLabel.textAlignment = NSTextAlignmentLeft;
    self.placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    [self addSubview:self.placeholderLabel];
    
    // setup constraints
    // left constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0 constant:8.0]];
    // right constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeRight
                                                    multiplier:1.0 constant:8.0]];
    // top constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                     attribute:NSLayoutAttributeTopMargin
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self attribute:NSLayoutAttributeTopMargin
                                                    multiplier:1.0 constant:5.0]];
    // height constraint
    [self.placeholderLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0 constant:20.0]];
}

- (void)textFieldDidChange:(NSNotification *)notification {
    NSInteger length = [((MultiLineFieldTextView *)notification.object).text length];
    if (length == 0) {
        [self animatePlaceholderLabelUpwards:YES];
    } else {
        [self animatePlaceholderLabelUpwards:NO];
    }
}

- (BOOL)isPlaceholderLabelVisible {
    return self.placeholderLabel.alpha == 1;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (self.text.length > 0) {
        self.placeholderLabel.alpha = 0.0;
    } else {
        self.placeholderLabel.alpha = 1.0;
    }
}

- (void)animatePlaceholderLabelUpwards:(BOOL)visible
{
    [UIView animateWithDuration:0.3 animations:^{
        if (visible) {
            self.placeholderLabel.alpha = 1.0;
            self.placeholderLabel.transform = CGAffineTransformIdentity;
        } else {
            self.placeholderLabel.alpha = 0.0;
            self.placeholderLabel.transform = CGAffineTransformMakeTranslation(0.0, -10.0);
        }
    }];
}

@end
