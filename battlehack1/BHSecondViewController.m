//
//  BHSecondViewController.m
//  battlehack1
//
//  Created by Jimmy Young on 26/07/2014.
//  Copyright (c) 2014 Battlehack. All rights reserved.
//

#import "BHSecondViewController.h"
#import "NetworkManager.h"

@interface BHSecondViewController ()

@end

@implementation BHSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NetworkManager getMyStuffwithCompletionBlock:^(BOOL sucess, NSArray *array) {
        if(sucess){
            self.tableData = array;
            NSLog(@"%@", array);
            [self.tableView reloadData];
        }
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.detailTextLabel.text = [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"description"];
    cell.textLabel.text = [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *url = [[self.tableData objectAtIndex:indexPath.row] objectForKey:@"thumbnail_url"];
    NSNumber *counter = [NSNumber numberWithInteger:1];
    [NetworkManager imageFetcher:url withCompletionhandler:^(BOOL sucess, UIImage *image) {
        if (sucess) {

            cell.imageView.image = image;
            
            int n = 1;
            if (n++ < 5){
                [self.tableView reloadData];
            }
        }
    }];
    return cell;
}

@end
