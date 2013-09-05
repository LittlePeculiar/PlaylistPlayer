//
//  MusicViewController.h
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>


@interface MusicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSArray *songList;
@property (nonatomic, readwrite) BOOL isPlaylistNew;

@property (nonatomic, weak) IBOutlet UITableView *songTable;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UISlider *volumeSlider;
@property (nonatomic, weak) IBOutlet UILabel *playlistLabel;


- (IBAction)goBack:(id)sender;
- (IBAction)playSong:(id)sender;
- (IBAction)playNextSong:(id)sender;
- (IBAction)playPrevSong:(id)sender;
- (IBAction)volumeControl:(id)sender;

- (void)play;
- (void)pause;
- (void)playSongAtIndex;
- (void)songCompleted;
- (void)startProgressTimer;
- (void)stopProgressTimer;
- (void)trackProgress:(NSTimer *)timer;



@end
