//
//  MusicViewController.m
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import "MusicViewController.h"
#import "SongCell.h"
#import "SongInfo.h"


@interface MusicViewController ()


@property (nonatomic, strong) AVAudioPlayer *loadedPlayer;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) NSInteger currentSong;

@end

@implementation MusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        if (self.songList == nil)
            self.songList = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.songTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // setup volume slider with custom image
    UIImage *volumeImage = [UIImage imageNamed:@"volume.png"];
    UIImage *minImage = [[UIImage imageNamed:@"slider_minimum.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)
                         resizingMode:UIImageResizingModeStretch];
    
    UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)
                         resizingMode:UIImageResizingModeStretch];
    
    [self.volumeSlider setMaximumTrackImage:maxImage forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:volumeImage forState:UIControlStateNormal];
    
    // increase the touch area for volume
    CGRect sliderFrame = self.volumeSlider.frame;
    sliderFrame.size.height = 30.0;
    [self.volumeSlider setFrame:sliderFrame];
    self.volumeSlider.frame = CGRectIntegral(self.volumeSlider.frame);
    
    // setup for background play
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // playlist name should be the same for all objects
    SongInfo *song = [self.songList objectAtIndex:0];
    self.playlistLabel.text = song.playlistName;
    [self.songTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // set up first song if not currently playing
    if (self.isPlaylistNew)
    {
        [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        self.currentSong = 0;
        [self playSongAtIndex];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)play
{
    [self.playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    self.playButton.selected = YES;
    
    self.audioPlayer = self.loadedPlayer;
    [self.audioPlayer play];
    [self startProgressTimer];
    [self.songTable reloadData];
}

- (void)pause
{
    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    self.playButton.selected = NO;
    
    [self.audioPlayer pause];
    [self stopProgressTimer];
}

- (void)playSongAtIndex
{
    if (self.currentSong >= 0 && self.currentSong < [self.songList count])
    {
        SongInfo *song = [self.songList objectAtIndex:self.currentSong];
        NSError *error = nil;
        self.loadedPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:song.songURL error:&error];
        [self.loadedPlayer prepareToPlay];
    }
}

- (void)songCompleted
{
    if (self.currentSong+1 < [self.songList count])
    {
        // play next song
        self.currentSong++;
        [self playSongAtIndex];
        [self play];
    }
    else
    {
        // done
        self.currentSong = 0;
        [self pause];
    }
}

// timer used for streaming
- (void)startProgressTimer
{
    if (self.progressTimer)
        return;
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                          target:self
                                                        selector:@selector(trackProgress:)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)stopProgressTimer
{
    if (!self.progressTimer)
        return;
    
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)trackProgress:(NSTimer*)timer
{
    double progress = [self.audioPlayer currentTime];
    double duration = [self.audioPlayer duration];
    double timeLeft = duration - progress;
    NSLog(@"timeLeft::%f", timeLeft);
    
    if (timeLeft < 1.0)     // seems to suffice
    {
        [self songCompleted];
    }
}


#pragma mark - Actions


- (IBAction)goBack:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playSong:(id)sender
{
    if ([self.audioPlayer isPlaying])
        [self pause];
    else
        [self play];
}

- (IBAction)playNextSong:(id)sender
{
    if (self.currentSong+1 < [self.songList count])
    {
        self.currentSong++;
        [self playSongAtIndex];
        [self play];
    }
    else
    {
        // reset
        self.currentSong = 0;
        [self pause];
    }
}

- (IBAction)playPrevSong:(id)sender
{
    if (self.currentSong-1 >= 0)
    {
        self.currentSong--;
        [self playSongAtIndex];
        [self play];
    }
    else
    {
        // reset
        self.currentSong = 0;
        [self pause];
    }
}

- (IBAction)volumeControl:(id)sender
{
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    musicPlayer.volume = self.volumeSlider.value;
}


#pragma mark Table Data Source and Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.songList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SongCell *cell = (SongCell *)[tableView dequeueReusableCellWithIdentifier:@"SongCell"];
    SongInfo *song = [self.songList objectAtIndex:indexPath.row];
    cell.playingImage.hidden = YES;
    cell.songTitle.text = song.songTitle;
    cell.artist.text = song.artist;
    cell.duration.text = song.duration;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.audioPlayer isPlaying])
    {
        if (indexPath.row == self.currentSong)
            cell.playingImage.hidden = NO;
    }
    
    // customize the cell
    UIImage *background = [[Utils sharedInstance] blackCellsForRowAtIndexPath:indexPath withRowCount:[self.songList count]];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSong = indexPath.row;
    [self playSongAtIndex];
    [self play];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"OK"])
    {
        
    }
}



@end

