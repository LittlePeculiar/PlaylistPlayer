//
//  Utils.m
//  PlaylistPlayer
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 LittlePeculiar. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (Utils*)sharedInstance
{
    static Utils *myInstance = nil;
	
    // if first time here, allocate our instance
    if (myInstance == nil)
	{
        myInstance  = [[[self class] alloc] init];
    }
    
    return myInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
        NSLog(@"Utils init");
    }
    
    return self;
}

// method to customize table cells
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath*)indexPath withRowCount:(NSInteger)rowCount
{
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0)
    {
        background = [UIImage imageNamed:@"cell_top.png"];
    }
    else if (rowIndex == rowCount - 1)
    {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    }
    else
    {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

// method to customize table cells
- (UIImage *)blackCellsForRowAtIndexPath:(NSIndexPath*)indexPath withRowCount:(NSInteger)rowCount
{
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0)
    {
        background = [UIImage imageNamed:@"cell_top_black.png"];
    }
    else if (rowIndex == rowCount - 1)
    {
        background = [UIImage imageNamed:@"cell_bottom_black.png"];
    }
    else
    {
        background = [UIImage imageNamed:@"cell_middle_black.png"];
    }
    
    return background;
}

// string helper methods
- (NSDate*)formatDateFromString:(NSString*)dateString
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter dateFromString:dateString];
}

- (NSString*)formatStringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate:date];
}


// cannot use autolayout as it's >= ios6
- (BOOL)isIPhone5
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568)
    {
        // iPhone 5
        return YES;
    }
    // everyone else
    return NO;
}

@end
