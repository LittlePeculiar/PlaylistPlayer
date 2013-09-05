//
//  Utils.h
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject


+ (Utils*)sharedInstance;

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath*)indexPath withRowCount:(NSInteger)rowCount;
- (UIImage *)blackCellsForRowAtIndexPath:(NSIndexPath*)indexPath withRowCount:(NSInteger)rowCount;
- (NSDate*)formatDateFromString:(NSString*)dateString;
- (NSString*)formatStringFromDate:(NSDate*)date;
- (BOOL)isIPhone5;


@end
