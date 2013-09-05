//
//  SongInfo.h
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject

@property (nonatomic, copy) NSString *playlistName;
@property (nonatomic, copy) NSString *songTitle;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, strong) NSURL *songURL;



- (id)initWithSongInfo:(NSString*)playlistName
             songTitle:(NSString*)songTitle
                artist:(NSString*)artist
              duration:(NSString*)duration
               songURL:(NSURL*)songURL;

@end
