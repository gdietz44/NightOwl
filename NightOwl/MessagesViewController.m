//
//  MessagesViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/8/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "MessagesViewController.h"
#import "MessageTableViewCell.h"
#import "ConversationViewController.h"
#import "Message.h"
#import "User.h"
#import <Parse/Parse.h>

static NSString* const MessageCell = @"MessageTableViewCell";

@interface MessagesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, ConversationViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarBackgroundHeight;
@property (strong, nonatomic) UISearchController *searchController;
@end

@implementation MessagesViewController

- (id)init {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) {
        self.title = @"Messages";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageSent:) name:@"Conversation Began" object:nil];
        self.messageData = [[MessageData alloc] init];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    
    self.statusBarBackgroundHeight.constant = 0;
    [self.view setNeedsUpdateConstraints];
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UINib *cellNib = [UINib nibWithNibName:MessageCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:MessageCell];
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 49.0, 0.0);
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"Messages";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDelegate/DataSource Methods
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 74;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchController.isActive) {
        return [self.searchResults count];
    } else {
        return self.messageData.conversations.count;
    }
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user =[self.messageData.contactedUsers objectAtIndex:indexPath.row];
    ConversationViewController *fnovc = [[ConversationViewController alloc] initWithDelegate:self withConversation:[self.messageData.conversations objectForKey:user.name] withUser:user withAutoresponse:YES];
    [self.navigationController pushViewController:fnovc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MessageCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:MessageCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    User *user = (self.searchController.isActive) ? [self.searchResults objectAtIndex:indexPath.row] : [self.messageData.contactedUsers objectAtIndex:indexPath.row];
    NSArray *conversation = [self.messageData.conversations objectForKey:user.name];
    NSString *mostRecentMessage = ((Message *)[conversation lastObject]).message;
    [cell configureCellWithUser:user.name sharedClasses:[user.sharedClasses componentsJoinedByString:@", "] message:mostRecentMessage image:user.image];
    [cell setNeedsUpdateConstraints];
    return cell;
}

#pragma mark UISearchResultsUpdating Methods
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = searchController.searchBar.text;
    self.searchResults = [self.messageData.contactedUsers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(User* userObject, NSDictionary *bindings) {
        return [[userObject.name lowercaseString] containsString:[searchString lowercaseString]];
    }]];
    [self.tableView reloadData];
}

#pragma mark UISearchDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar
selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    self.statusBarBackgroundHeight.constant = 25;
    [self.view setNeedsUpdateConstraints];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    self.statusBarBackgroundHeight.constant = 0;
    [self.view setNeedsUpdateConstraints];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
}

#pragma mark ConversationCiewControllerDelegate Method
- (void)conversationViewController:(ConversationViewController *)conversationViewController
             didUpdateConversation:(NSArray *)conversation
                          withUser:(User *)user {
    [self.messageData.conversations setObject:conversation forKey:user.name];
    [self.messageData.contactedUsers removeObjectAtIndex:[self.messageData.contactedUsers indexOfObject:user]];
    [self.messageData.contactedUsers insertObject:user atIndex:0];
    [self.tableView reloadData];
}

#pragma mark Private Methods
- (void)messageSent:(NSNotification *)notification {
    Message *message = notification.object;
    User *otherUser = message.sender;
    message.sender = nil;
    
    if ([self.messageData.contactedUsers containsObject:otherUser]) {
        NSMutableArray *conversation = [self.messageData.conversations objectForKey:otherUser.name];
        [conversation addObject:message];
        [self.messageData.conversations setObject:conversation forKey:otherUser.name];
        [self.messageData.contactedUsers removeObjectAtIndex:[self.messageData.contactedUsers indexOfObject:otherUser]];
        [self.messageData.contactedUsers insertObject:otherUser atIndex:0];
    } else {
        NSMutableArray *conversation = [[NSMutableArray alloc] initWithObjects:message, nil];
        [self.messageData.conversations setObject:conversation forKey:otherUser.name];
        [self.messageData.contactedUsers insertObject:otherUser atIndex:0];
    }
    [self.tableView reloadData];
    
}
@end







