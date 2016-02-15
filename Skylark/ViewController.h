//
//  ViewController.h
//  Skylark
//
//  Created by Warrd Adlani on 15/02/2016.
//  Copyright © 2016 Warrd Adlani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GETRequestClass.h"
#import "FeaturesTableViewCell.h"

@interface ViewController : UIViewController <NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) GETRequestClass *getRequestObject;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

