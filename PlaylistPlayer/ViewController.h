//
//  ViewController.h
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicViewController.h"



@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>


@property (nonatomic, strong) MusicViewController *musicController;
@property (nonatomic, strong) NSArray *playlistLibrary;
@property (nonatomic, strong) NSMutableArray *songlist;
@property (strong, nonatomic) IBOutlet UITableView *musicTable;


- (NSString*)formatDuration:(NSNumber*)duration;



@end
