//
//  SongInfo.m
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import "SongInfo.h"

@implementation SongInfo

- (id)initWithSongInfo:(NSString*)playlistName
             songTitle:(NSString*)songTitle
                artist:(NSString*)artist
              duration:(NSString*)duration
               songURL:(NSURL*)songURL
{
    if ((self = [super init]))
    {
        self.playlistName = playlistName;
        self.songTitle = songTitle;
        self.artist = artist;
        self.duration = duration;
        self.songURL = songURL;
    }
    
    return self;
}

- (void)dealloc
{
    self.playlistName = nil;
    self.songTitle = nil;
    self.artist = nil;
    self.duration = nil;
    self.songURL = nil;
}

@end
