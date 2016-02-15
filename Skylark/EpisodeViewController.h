//
//  EpisodeViewController.h
//  Skylark
//
//  Created by Warrd Adlani on 15/02/2016.
//  Copyright © 2016 Warrd Adlani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EpisodeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrEpisodes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
