//
//  ViewController.m
//  Skylark
//
//  Created by Warrd Adlani on 15/02/2016.
//  Copyright © 2016 Warrd Adlani. All rights reserved.
//

#import "ViewController.h"
#import "EpisodeViewController.h"

@interface ViewController ()
{
    NSURLSessionDataTask * dataTask;
    NSHTTPURLResponse *httpResponse;
    NSMutableArray *arrContents;
    NSMutableArray *arrEpisodes;
    UIView *loadingView;
}

@end

@implementation ViewController

@synthesize getRequestObject = _getRequestObject;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    loadingView = [[UIView alloc]initWithFrame:self.view.bounds];
    [loadingView setTranslatesAutoresizingMaskIntoConstraints:YES];
    UILabel *loadingLabel = [[UILabel alloc]initWithFrame:loadingView.bounds];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setNumberOfLines:0];
    [loadingLabel setTextColor:[UIColor whiteColor]];
    [loadingLabel setTranslatesAutoresizingMaskIntoConstraints:YES];
    [loadingView addSubview:loadingLabel];
    [self blurViewUsingView:loadingView];
    
    self.getRequestObject = [[GETRequestClass alloc]init];
    [self.getRequestObject setDelegate:self];
    
    [self.view addSubview:loadingView];
    [self.getRequestObject getDataWithEndPoint:@"api/sets/" withCompletionBlock:^(id json, NSError *error)
    {
        if(error)
        {
            NSLog(@"Error: %@",error.localizedDescription);
        }
        else
        {
            NSLog(@"JSON from block:%@", json);
            arrContents = [[NSMutableArray alloc]initWithArray:json[@"objects"]];
            [self.tableView reloadData];
        }
        
        [loadingView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(arrContents.count == 0)
        return 0;
    else
        return arrContents.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(arrContents.count == 0)
//        return 0;
//    else
//        return arrContents.count;
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeaturesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"featuresCell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    switch (indexPath.row)
    {
        case 0:
            cell.lblQouter.text = [arrContents objectAtIndex:indexPath.section][@"quoter"];
            cell.lblBodyInfo.text = @"";
            [cell.imgFeatureImage setHidden:NO];
            
            break;
        case 1:
            cell.lblBodyInfo.text = [arrContents objectAtIndex:indexPath.section][@"body"];
            cell.lblQouter.text = @"";
            [cell.imgFeatureImage setHidden:YES];
            break;
            
        default:
            break;
    }
    
    if([[arrContents objectAtIndex:indexPath.section][@"items"] count] > 0)
    {
        [cell.btnViewEpisodes setHidden:NO];
        [cell.btnViewEpisodes setTag:indexPath.section];
        [cell.btnViewEpisodes addTarget:self action:@selector(btnGetEpisodes:) forControlEvents:UIControlEventAllEvents];
        
        NSLog(@"Episodes available");
    }
    else
    {
        [cell.btnViewEpisodes setHidden:YES];
        NSLog(@"No Episodes available");
    }
    
    return cell;
}

// Force seperator lines to compose full view length
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    label.text = [NSString stringWithFormat:@"  %@",[arrContents objectAtIndex:section][@"title"]];
    [label setBackgroundColor:[UIColor brownColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor whiteColor]];
    
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 1)
    {
        NSString *bodyString = [arrContents objectAtIndex:indexPath.section][@"body"];
        if(bodyString.length > 0)
        {
            CGSize maximumSize = CGSizeMake(self.view.frame.size.width, MAXFLOAT);
            CGSize myStringSize = [bodyString sizeWithFont:[UIFont systemFontOfSize:16.0]
                                         constrainedToSize:maximumSize
                                             lineBreakMode:NSLineBreakByWordWrapping];
            return myStringSize.height + 64.0f;
        }
        else
        {
            return 0.0f;
        }
    }
    
    return 221.0f;
}

//-(void)getDataWithEndPoint:(NSString*)paramEndPoint
//{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    NSURLSession * session = [NSURLSession sharedSession];
//    NSString *urlAsString = [NSString stringWithFormat:@"http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/api/%@/", paramEndPoint];
//    NSURL * url = [NSURL URLWithString:urlAsString];
//    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0]; // 30 seconds time out
//    [urlRequest setHTTPMethod:@"GET"];
//    
//    dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSLog(@"Dictionary: %@", dictionary);
//
//    }];
//    
//    [dataTask resume];
//}

-(IBAction)btnGetEpisodes:(UIButton*)sender
{
    arrEpisodes =[[NSMutableArray alloc]initWithArray:(NSArray*)[arrContents objectAtIndex:sender.tag][@"items"]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EpisodeViewController *evc = (EpisodeViewController*)segue.destinationViewController;
    [evc setArrEpisodes:arrEpisodes];
}

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

@end
