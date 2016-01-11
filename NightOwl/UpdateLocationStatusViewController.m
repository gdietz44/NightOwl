//
//  UpdateLocationStatusViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/19/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "UpdateLocationStatusViewController.h"
#import "MultiLineFieldTextView.h"

static NSUInteger const MaxStatusLength = 60;

@interface UpdateLocationStatusViewController () <UITextViewDelegate> {
    CGPoint scrollViewStartOffset;
}
@property (weak, nonatomic) IBOutlet MultiLineFieldTextView *statusField;
@property (weak, nonatomic) IBOutlet UILabel *charsRemainingLabel;
@property (weak, nonatomic) IBOutlet MultiLineFieldTextView *locationField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) id<UpdateLocationStatusViewControllerDelegate> delegate;
@property (nonatomic) NSString *location;
@property (nonatomic) NSString *status;
@property (nonatomic) BOOL fromLocationAlert;
@end

@implementation UpdateLocationStatusViewController
- (id)initWithDelegate:(id<UpdateLocationStatusViewControllerDelegate>)delegate
            classTitle:(NSString *)classTitle
          currLocation:(NSString *)location
            currStatus:(NSString *)status {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) {
        self.delegate = delegate;
        self.title = classTitle;
        self.location = location;
        self.status = status;
        self.fromLocationAlert = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.statusField setPlaceholderText:@"eg Finished everything but problem 7"];
    [self.statusField setText:self.status];
    self.statusField.delegate = self;
    self.statusField.returnKeyType = UIReturnKeyDone;
    [self.locationField setText:self.location];
    [self.locationField setPlaceholderText:@"eg Green Library"];
    self.locationField.delegate = self;
    self.locationField.returnKeyType = UIReturnKeyDone;
    NSUInteger charactersRemaining = MaxStatusLength - [self.statusField.text length];
    self.charsRemainingLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)charactersRemaining];
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 60.0, 0.0);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllKeyboards)];
    [self.scrollView addGestureRecognizer:tap];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationField resignFirstResponder];
    [self.statusField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)updateClass {
    [self.delegate updateLocationStatusViewController:self didUpdateClass:self.title withLocation:self.locationField.text andStatus:self.statusField.text];
}

- (void)deactivateClass {
    [self.delegate updateLocationStatusViewController:self didDeactivateClass:self.title];

}



- (IBAction)didSelectDeactivate:(id)sender {
    NSString *actionTitle = [NSString stringWithFormat:@"Deactivate for %@?", self.title];
    NSString *actionMessage = [NSString stringWithFormat:@"Are you sure you are done working on %@?", self.title];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:actionTitle message:actionMessage preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self deactivateClass];
                                                      }];
    
    [alert addAction:yesAction];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)didSelectUpdate:(id)sender {
    if ([self.locationField.text length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Please enter your location." message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if ([self.statusField.text length] == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to activate this class without a status?" message:@"Status messages make it easier to find other NightOwls." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self updateClass];
                                                          }];
        
        [alert addAction:yesAction];
        UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
        
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [self updateClass];
    }
}

- (void)textViewEditYes {
    self.fromLocationAlert = YES;
    [self.locationField becomeFirstResponder];
}

#pragma mark - UITextViewDelegate
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

- (BOOL)isAcceptableTextLength:(NSUInteger)length {
    return length <= MaxStatusLength;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    if([string isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if (![textView isEqual:self.statusField]) return YES;
    return [self isAcceptableTextLength:self.statusField.text.length + string.length - range.length];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (![textView isEqual:self.statusField]) return;
    NSUInteger charactersRemaining = MaxStatusLength - [self.statusField.text length];
    self.charsRemainingLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)charactersRemaining];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if([textView isEqual:self.locationField]) {
        if ([self.locationField.text length] == 0 || self.fromLocationAlert) return YES;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to edit your location?" message:@"This will change your location for all activated classes." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self textViewEditYes];
                                                          }];
        
        [alert addAction:yesAction];
        UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
        
        [alert addAction:noAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark Private Methods
- (void)resignAllKeyboards {
    [self.scrollView setContentOffset:scrollViewStartOffset animated:YES];
    [self.locationField resignFirstResponder];
    [self.statusField resignFirstResponder];
}


@end
