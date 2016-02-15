//
//  EpisodeViewController.m
//  Skylark
//
//  Created by Warrd Adlani on 15/02/2016.
//  Copyright © 2016 Warrd Adlani. All rights reserved.
//

#import "EpisodeViewController.h"
#import "EpisodeTableViewCell.h"
#import "GETRequestClass.h"

@interface EpisodeViewController ()
{
    GETRequestClass *getRequest;
    NSMutableArray *arrTitles;
    NSOperationQueue *downloadQueue;
    UIView *loadingView;
    UILabel *loadingLabel;
}

@end

@implementation EpisodeViewController

@synthesize arrEpisodes = _arrEpisodes;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    getRequest = [[GETRequestClass alloc]init];
    
    NSLog(@"Episode array: %@", self.arrEpisodes);
    
    arrTitles = [[NSMutableArray alloc]init];
    for(int i = 0; i < self.arrEpisodes.count; i++)
    {
        [arrTitles addObject:@""];
    }
    
    downloadQueue = [[NSOperationQueue alloc]init];
}

-(void)viewDidLayoutSubviews
{
    loadingView = [[UIView alloc]initWithFrame:self.view.bounds];
    [loadingView setTranslatesAutoresizingMaskIntoConstraints:YES];
    loadingLabel = [[UILabel alloc]initWithFrame:loadingView.bounds];
    [loadingLabel setText:@"Downloading data.\nPlease wait..."];
    [loadingLabel setTextAlignment:NSTextAlignmentJustified];
    [loadingLabel setNumberOfLines:0];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [loadingLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [loadingView addSubview:loadingLabel];
    [loadingView bringSubviewToFront:loadingLabel];
    [self blurViewUsingView:loadingView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrEpisodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EpisodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"episodeCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if([[arrTitles objectAtIndex:indexPath.row]isEqualToString:@""])
    {
        // Push dynamic download to background thread
        [downloadQueue addOperationWithBlock:^{
            [getRequest getDataWithEndPoint:[self.arrEpisodes objectAtIndex:indexPath.row][@"content_url"] withCompletionBlock:^(id json, NSError *error)
             {
                 [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                     if(json[@"title"] != nil && json[@"title"] != (id)[NSNull null])
                     {
                         [arrTitles replaceObjectAtIndex:indexPath.row withObject:json[@"title"]];
                         [tableView reloadData];
                     }
                 }];
             }];
        }];
    }
    else
        cell.lblTitle.text = [arrTitles objectAtIndex:indexPath.row];;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

// Blurs a view
-(void)blurViewUsingView:(UIView*)paramView
{
    paramView.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = paramView.bounds;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [paramView addSubview:blurEffectView];
    [paramView sendSubviewToBack:blurEffectView];
    
    [paramView setHidden:NO];
    [paramView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
