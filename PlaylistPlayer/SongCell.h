//
//  SongCell.h
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SongCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *songTitle;
@property (nonatomic, weak) IBOutlet UILabel *artist;
@property (nonatomic, weak) IBOutlet UILabel *duration;
@property (nonatomic, weak) IBOutlet UIImageView *playingImage;

@end
