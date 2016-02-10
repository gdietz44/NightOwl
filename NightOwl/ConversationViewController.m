//
//  ConversationViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/28/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationTableViewCell.h"
#import <Parse/Parse.h>

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define PROFILE_IMAGE_DIMENSIONS 36

static NSString* const ConversationCell = @"ConversationTableViewCell";

@interface ConversationViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (nonatomic) NSMutableArray *currentConversation;
@property (nonatomic) BOOL initialScrollDone;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (nonatomic) User* otherUser;
@property (nonatomic) BOOL autoresponse;
@property (nonatomic) UIImage *profileImage;
@property (weak, nonatomic) id<ConversationViewControllerDelegate> delegate;
@end

@implementation ConversationViewController

- (id)initWithDelegate:(id<ConversationViewControllerDelegate>)delegate
      withConversation:(NSArray *)convo
              withUser:(User *)user
      withAutoresponse:(BOOL)autoresponse {
    if (self = [super init]) {
        self.delegate = delegate;
        self.currentConversation = [[NSMutableArray alloc] initWithArray:convo];
        self.title = user.name;
        self.otherUser = user;
        self.initialScrollDone = NO;
        self.autoresponse = autoresponse;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.messageTextView.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:ConversationCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:ConversationCell];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.estimatedRowHeight = 40;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 92.0, 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 92.0, 0.0);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setButtonColor];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.messageView addGestureRecognizer:swipe];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.tableView addGestureRecognizer:tap];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    
}

- (void)viewDidLayoutSubviews {
    if (!self.initialScrollDone) {
        [self.tableView layoutIfNeeded];
        self.initialScrollDone = YES;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
        if (ip.row > 0) {
            [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    PFFile *file = [currentUser objectForKey:@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error) {
            self.profileImage = [UIImage imageWithData:data];
            [self.tableView reloadData];
        }
    }];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self.delegate conversationViewController:self didUpdateConversation:self.currentConversation withUser:self.otherUser];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - TableViewDelegate/DataSource Methods
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we need to make sure our cell is tall enough so we don't cut off our message bubble
    ConversationTableViewCell *cell = (ConversationTableViewCell*)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    // get the size of the message for this cell
    CGSize newSize = [cell getMessageSize];
    
    // get the height of the bubble and add a little buffer of 8
    CGFloat textHeight = newSize.height + 4;
    
    // don't make our cell any smaller than 60
    textHeight = (textHeight < 40) ? 40 : textHeight;
    
    return textHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentConversation count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ConversationCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:ConversationCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell configureCellWithMessage:[self.currentConversation objectAtIndex:indexPath.row] profileImage:self.profileImage];
    return cell;
}

#pragma mark UITextViewDelegate Methods
- (void)textViewDidChange:(UITextView *)textView {
    [self setButtonColor];
    CGFloat oldHeight = self.messageTextViewHeightConstraint.constant;
    CGFloat newHeight = fminf([self.messageTextView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX) ].height, 90);
    if (newHeight != oldHeight) {
        self.messageTextViewHeightConstraint.constant = newHeight;
        CGFloat bottomInset = self.tableView.contentInset.bottom - oldHeight + newHeight;
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, bottomInset, 0.0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, bottomInset, 0.0);
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
        if (ip.row > 0) {
            [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark Action Methods
- (IBAction)sendButtonWasPressed:(id)sender {
    if ([self.currentConversation count] == 0) {
        Message *message = [[Message alloc] initWithUser:self.otherUser message:self.messageTextView.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Conversation Began" object:message];
    }
    Message *message = [[Message alloc] initWithUser:nil message:self.messageTextView.text];
    [self.currentConversation addObject:message];
    [self.tableView reloadData];
    NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    self.messageTextView.text = @"";
    [self setButtonColor];
    if (self.autoresponse) {
        [self performSelector:@selector(otherUserSendMessage) withObject:nil afterDelay:3];
    }
}


#pragma mark Private Methods
- (void)otherUserSendMessage {
    Message *message = [[Message alloc] initWithUser:self.otherUser message:@"Sounds good!"];
    [self.currentConversation addObject:message];
    [self.tableView reloadData];
    NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height) + 43.0, 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height) + 43.0, 0.0);
    self.messageViewBottomConstraint.constant = keyboardSize.height;
    [self.view layoutIfNeeded];
    NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0] - 1 inSection:0];
    if (ip.row > 0) {
        [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (void)hideKeyboard {
    [self.messageTextView resignFirstResponder];
    self.messageViewBottomConstraint.constant = 49.0;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 92.0, 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, 92.0, 0.0);
}

- (void)setButtonColor {
    if (self.messageTextView.text.length > 0) {
        [self.sendButton setTitleColor:[UIColor colorWithRed:128.0/255.0 green:91.0/255.0 blue:160.0/255.0 alpha:1] forState:UIControlStateNormal];
        self.sendButton.enabled = YES;
    } else {
        [self.sendButton setTitleColor:[UIColor colorWithRed:165.0/255.0 green:163.0/255.0 blue:163.0/255.0 alpha:1] forState:UIControlStateNormal];
        self.sendButton.enabled = NO;
    }
}

@end
