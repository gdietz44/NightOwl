//
//  AddClassesViewController.m
//  NightOwl
//
//  Created by Griffin Dietz on 11/17/15.
//  Copyright © 2015 Stanford University. All rights reserved.
//

#import "AddClassesViewController.h"
#import "AddAClassTableViewCell.h"
#import "ClassList.h"
#import "ClassListParser.h"

static NSString* const AddAClassCell = @"AddAClassTableViewCell";

@interface AddClassesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>
@property (weak, nonatomic) id<AddClassesViewControllerDelegate> delegate;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarBackgroundHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) ClassListParser *classListParser;
@property (nonatomic) NSArray *searchResults;
@end

@implementation AddClassesViewController

- (id)initWithDelegate:(id<AddClassesViewControllerDelegate>)delegate {
    if (self = [super initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]]) {
        self.delegate = delegate;
        
        NSData *fileData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"courselist" ofType:@"xml"]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:fileData];
        self.classListParser = [[ClassListParser alloc] init];
        self.searchResults = [[NSArray alloc] init];
        parser.delegate = self.classListParser;
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"Add A Class";
    
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
    
    UINib *cellNib = [UINib nibWithNibName:AddAClassCell bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:AddAClassCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDelegate and DataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(!self.searchController.isActive) {
        return [self.classListParser.classList.subjectArr count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
#pragma unused(tableView)
    if(!self.searchController.isActive) {
        NSString *key = [self.classListParser.classList.subjectArr objectAtIndex:(NSUInteger)section];
        NSNumber *sectionSize = [self.classListParser.classList.subjectCountMap objectForKey:key];
        if(sectionSize) {
            return sectionSize.integerValue;
        }
    } else {
        return [self.searchResults count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(!self.searchController.isActive) {
        return [self.classListParser.classList.subjectArr objectAtIndex:(NSUInteger)section];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddAClassTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *class = [cell getClassName];
    [self.searchController.searchBar resignFirstResponder];
    [self.delegate AddClassesViewController:self didAddClass:class];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AddAClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddAClassCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:AddAClassCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(!self.searchController.isActive) {
        NSString *key = [self.classListParser.classList.subjectArr objectAtIndex:(NSUInteger)indexPath.section];
        NSArray *sectionArr = [self.classListParser.classList.subjectCodeMap objectForKey:key];
        NSString *cellText = [[key stringByAppendingString:@" "] stringByAppendingString:[sectionArr objectAtIndex:(NSUInteger)indexPath.row]];
        [(AddAClassTableViewCell *)cell configureCellWithClassName:cellText];
    } else {
        NSMutableString *class = [NSMutableString stringWithString:[self.searchResults objectAtIndex:(NSUInteger)indexPath.row]];
        NSRange spaceIndex = [class rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
        [class insertString:@" " atIndex:spaceIndex.location];
        [(AddAClassTableViewCell *)cell configureCellWithClassName:class];
    }
    return cell;
}


#pragma mark UISearchResultsUpdating Methods
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

#pragma mark UISearchDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar
selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    self.statusBarBackgroundHeight.constant = 20;
    [self.view setNeedsUpdateConstraints];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    self.statusBarBackgroundHeight.constant = 0;
    [self.view setNeedsUpdateConstraints];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);

}

#pragma mark Private Methods
- (void)searchForText:(NSString *)searchText
{
    NSArray *data = self.classListParser.classList.classArr;
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.searchResults = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText]];
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview];
}

@end
