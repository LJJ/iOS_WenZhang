//
//  PageAndModuleTableViewController.m
//  WenZhang
//
//  Created by LJJ on 11/30/14.
//  Copyright (c) 2014 LJJ. All rights reserved.
//

#import "PageAndModuleTableViewController.h"

@interface PageAndModuleTableViewController ()
@property (nonatomic, strong) NSArray *modules;
@end

@implementation PageAndModuleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.title isEqualToString:@"page"]) {
        self.modules = [[NSUserDefaults standardUserDefaults] objectForKey:CONkeyPageAndModule];
    }
    else
    {
        self.modules = [[NSUserDefaults standardUserDefaults] objectForKey:CONkeyPageAndModule][_pageId][@"pageModules"];
    }
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _modules.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleCell" forIndexPath:indexPath];
    NSDictionary *dict = _modules[indexPath.row];
    if([self.title isEqualToString:@"page"])cell.textLabel.text = dict[@"pageName"];
    else cell.textLabel.text = dict[@"moduleName"];
//    cell.textLabel.text = dict[@""];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - table view delagate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"page"]) {
        [self performSegueWithIdentifier:@"SelectModuleSegue" sender:nil];
    }
    else
    {
        NSDictionary *dict = _modules[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:CONNotificationSelectPageAndModule object:@{
                                                                                                              @"pageId":[NSNumber numberWithInteger:_pageId],
                                                                                                              @"pageName":_pageName,
                                                                                                              @"moduleId":dict[@"moduleId"],
                                                                                                              @"moduleName":dict[@"moduleName"]
                                                                                                              }];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SelectModuleSegue"]) {
        NSDictionary *dict = _modules[[self.tableView indexPathForSelectedRow].row];
        ((PageAndModuleTableViewController *)segue.destinationViewController).pageId = [dict[@"pageId"] integerValue];
        ((PageAndModuleTableViewController *)segue.destinationViewController).pageName = dict[@"pageName"];
    }
    
}


@end
