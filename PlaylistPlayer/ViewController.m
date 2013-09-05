//
//  ViewController.m
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import "ViewController.h"
#import "MenuCell.h"
#import "SongInfo.h"
#import <MediaPlayer/MediaPlayer.h>


@interface ViewController ()

@end

@implementation ViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.musicTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if (self.playlistLibrary == nil)
        self.playlistLibrary = [[NSArray alloc] init];
    if (self.songlist == nil)
        self.songlist = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // get playlist names from music library
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    self.playlistLibrary = [myPlaylistsQuery collections];
    
    if ([self.playlistLibrary count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"NO Personal Playlist Found"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    [self.musicTable reloadData];
}

- (NSString*)formatDuration:(NSNumber*)duration
{
    NSString *durStr = @"";
    NSInteger durValue = [duration doubleValue];
    
    NSInteger hours = durValue / 3600;
    NSInteger rem1 = durValue % 3600;
    NSInteger mins = rem1 / 60;
    NSInteger secs = rem1 % 60;
    
    if (hours)
        durStr = [NSString stringWithFormat:@"%i:%02i:%02i", hours, mins, secs];
    else
        durStr = [NSString stringWithFormat:@"%i:%02i", mins, secs];
    
    return durStr;
}



#pragma mark Table Data Source and Delegate Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.playlistLibrary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    MPMediaPlaylist *playlist = [self.playlistLibrary objectAtIndex:indexPath.row];
    cell.menuLabel.text = [playlist valueForProperty:MPMediaPlaylistPropertyName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // customize the cell
    UIImage *background = [[Utils sharedInstance] blackCellsForRowAtIndexPath:indexPath withRowCount:[self.playlistLibrary count]];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cell.backgroundView = cellBackgroundView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // load all songs for this playlist
    [self.songlist removeAllObjects];       // reset
    MPMediaPlaylist *playlist = [self.playlistLibrary objectAtIndex:indexPath.row];
    NSArray *songItems = [playlist items];
    
    for (MPMediaItem *song in songItems)
    {
        NSString *durStr = [self formatDuration:[song valueForProperty: MPMediaItemPropertyPlaybackDuration]];
        SongInfo *songInfo = [[SongInfo alloc]
                              initWithSongInfo:(NSString*)[playlist valueForProperty:MPMediaPlaylistPropertyName]
                              songTitle:(NSString*)[song valueForProperty:MPMediaItemPropertyTitle]
                              artist:(NSString*)[song valueForProperty:MPMediaItemPropertyArtist]
                              duration:(NSString*)durStr
                              songURL:(NSURL*)[song valueForProperty:MPMediaItemPropertyAssetURL]];
        
        [self.songlist addObject:songInfo];
    }
    
    // make sure we have music
    if ([self.songlist count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"NO Songs in Playlist"
                              message:@"Please select again"
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if (self.musicController == nil)
        {
            self.musicController = [self.storyboard instantiateViewControllerWithIdentifier:@"MusicView"];
        }
        self.musicController.songList = [NSArray arrayWithArray:self.songlist];
        self.musicController.isPlaylistNew = YES;
        [self.musicController.audioPlayer pause];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.05;
        transition.timingFunction = [CAMediaTimingFunction
                                     functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type =kCATransitionReveal;
        transition.subtype =kCATransitionFromLeft;
        
        transition.delegate   = self;
        
        [self presentViewController:self.musicController animated:NO completion:NULL];
        
        [self.view.layer addAnimation:transition forKey:nil];
        
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"OK"])
    {
        
    }
}


@end

