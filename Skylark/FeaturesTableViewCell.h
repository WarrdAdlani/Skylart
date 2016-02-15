//
//  FeaturesTableViewCell.h
//  Skylark
//
//  Created by Warrd Adlani on 15/02/2016.
//  Copyright © 2016 Warrd Adlani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgFeatureImage;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblQouter;
@property (weak, nonatomic) IBOutlet UIButton *btnViewEpisodes;
@end
