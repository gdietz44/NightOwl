//
//  SendAMessageViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/27/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "SendAMessageViewController.h"
#import "MultiLineFieldTextView.h"
#import "User.h"

@interface SendAMessageViewController () <UITextViewDelegate> {
    CGPoint scrollViewStartOffset;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet MultiLineFieldTextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) User *user;
@property (weak, nonatomic) id<SendAMessageViewControllerDelegate> delegate;
@end

@implementation SendAMessageViewController
- (id)initWithDelegate:(id<SendAMessageViewControllerDelegate>)delegate
         userToContact:(User *)user {
    if (self = [super init]) {
        self.delegate = delegate;
        self.user = user;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.messageTextView setPlaceholderText:[NSString stringWithFormat:@"Enter your message to %@", self.user.name]];
    self.messageTextView.returnKeyType = UIReturnKeyDone;
    [self setButtonColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllKeyboards)];
    [self.scrollView addGestureRecognizer:tap];
    self.messageTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITextViewDelegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect scrollViewFrame = self.scrollView.frame;
    scrollViewStartOffset = self.scrollView.contentOffset;
    if (scrollViewFrame.size.height > 300) {
        scrollViewFrame.size.height -= 216;
        self.scrollView.frame = scrollViewFrame;
    }
    CGRect rect = textView.frame;
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self setButtonColor];
}

#pragma mark - Actions
- (IBAction)sendMessageButtonWasClicked:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your message has been sent." message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self.messageTextView resignFirstResponder];
                                                         [self.delegate sendAMessageViewController:self didContactUser:self.user withMessage:self.messageTextView.text];
                                                     }];
    
    [alert addAction:okAction];
    [alert.view setTintColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark Private Methods
- (void)resignAllKeyboards {
    [self.scrollView setContentOffset:scrollViewStartOffset animated:YES];
    [self.messageTextView resignFirstResponder];
}

- (void)setButtonColor {
    if (self.messageTextView.text.length > 0) {
        self.buttonView.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1];
        self.button.enabled = YES;
    } else {
        self.buttonView.backgroundColor = [UIColor colorWithRed:216.0/255.0 green:216.0/255.0 blue:216.0/255.0 alpha:1];
        self.button.enabled = NO;
    }
}



@end
