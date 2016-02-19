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

@interface AddClassesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) id<AddClassesViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusBarBackgroundHeight;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
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
    
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.returnKeyType = UIReturnKeyDone;

    self.definesPresentationContext = YES;
    
    self.statusBarBackgroundHeight.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
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
    if([self.searchBar.text isEqual:@""]) {
        return [self.classListParser.classList.subjectArr count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
#pragma unused(tableView)
    if([self.searchBar.text isEqual:@""]) {
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
    if([self.searchBar.text isEqual:@""]) {
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
    [self.delegate AddClassesViewController:self didAddClass:class];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AddAClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AddAClassCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:AddAClassCell owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if([self.searchBar.text isEqual:@""]) {
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

#pragma mark UISearchDelegate Methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchForText:searchText];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text = @"";
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark Private Methods
- (void)searchForText:(NSString *)searchText
{
    NSArray *data = self.classListParser.classList.classArr;
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.searchResults = [data filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText]];
}

@end
