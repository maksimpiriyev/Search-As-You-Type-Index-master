//
//  TSTableViewController.m
//  Test Search Index
//
//  Created by Maksim Piriyev on 8/1/14.
//  Copyright (c) 2014 Maksim Industries. All rights reserved.
//

#import "TSSearchTableViewController.h"
#include <vector>
#include <string>
#include "F.h"
#include "Search.h"
using namespace std;


@interface TSSearchTableViewController ()

@end

@implementation TSSearchTableViewController

{
    vector<std::string> list;
    NSMutableArray* olist;//= [NSMutableArray new];
    NSMutableArray* filteredList;//= [NSMutableArray new];
    INDEX* index;
    SaytIndex* sindex;

}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    
    olist= [NSMutableArray new];
    filteredList= [NSMutableArray new];
    
    list=read_file("list");
    NSString* filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%s" , "index"]
                                                         ofType:@"txt"];
   // sindex=new SaytIndex([filePath UTF8String]);
    sindex=new SaytIndex();

    sindex->readAsync([filePath UTF8String]);

    //index=&search::read_index([filePath UTF8String]);
    //list.push_back("ASDasd");
    for (int i=0; i<list.size(); i++) {
        [olist addObject:[NSString stringWithFormat:@"%s",list[i].c_str()]];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self activeList:tableView].count;
    // return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString* ss=[[self activeList:tableView] objectAtIndex:indexPath.row];
    // Configure the cell...
    [cell.textLabel setText:[[self activeList:tableView] objectAtIndex:indexPath.row]];//[NSString stringWithFormat:@"%s",list[indexPath.row].c_str()]];
    return cell;
}


#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filteredList removeAllObjects];
    // Filter the array using NSPredicate
    auto l=sindex->search([searchText UTF8String]);
    for (int i=0; i<l.size(); i++) {
        [filteredList addObject:[NSString stringWithFormat:@"%s",list[l[i]].c_str()]];
    }
 //   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@",searchText];
   // filteredList = [NSMutableArray arrayWithArray:[olist filteredArrayUsingPredicate:predicate]];
}
#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
-(NSArray*) activeList:(UITableView*) tableView{
    if (tableView != self.tableView){// self.searchDisplayController.searchResultsTableView) {
        return filteredList ;
    } else {
        return olist;
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
