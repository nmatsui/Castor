//
//  ViewUtil.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewUtil.h"


@implementation ViewUtil
static int groupFontSize = 14;
static int entryFontSize = 12;

+ (UILabel *)makeLabel:(CGRect)rect text:(NSString *)text font:(UIFont *)font
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    [label setFrame:rect];
    [label setText:text];
    [label setFont:font];
    [label setTextColor:[UIColor blackColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:UITextAlignmentLeft];
    [label setNumberOfLines:0];
    [label setLineBreakMode:UILineBreakModeWordWrap];
    return label;
}

+ (CGFloat)getGroupCellHeight:(CGSize)size group:(GroupData *)group portrate:(BOOL)portrate
{
    float w = (portrate) ? size.width - 70 : size.height - 70;
    CGSize s = [group.roomName sizeWithFont:[UIFont systemFontOfSize:groupFontSize] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    float height = 10 + s.height + 10;
    return (height<40)?40:height;
}

+ (UIView *)getGroupCellView:(CGSize)size group:(GroupData *)group portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    float w = (portrate) ? size.width - 70 : size.height - 70;
    CGSize s = [group.roomName sizeWithFont:[UIFont systemFontOfSize:groupFontSize] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *nameLabel = [ViewUtil makeLabel:CGRectMake(60, 10, w, s.height) text:group.roomName font:[UIFont systemFontOfSize:groupFontSize]];
    [v addSubview:nameLabel];
    return v;
}

+ (CGFloat)getEntryCellHeight:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate
{
    float w = (portrate) ? size.width - 70 : size.height - 70;
    CGSize s = [entry.content sizeWithFont:[UIFont systemFontOfSize:entryFontSize] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    float height = 30 + s.height + 10;
    return (height<60)?60:height;
}

+ (UIView *)getEntryCellView:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    UILabel *nameLabel = [ViewUtil makeLabel:CGRectMake(60, 10, 250, 16) text:entry.name font:[UIFont boldSystemFontOfSize:entryFontSize]];
    [v addSubview:nameLabel];
    float w = (portrate) ? size.width - 70 : size.height - 70;
    CGSize s = [entry.content sizeWithFont:[UIFont systemFontOfSize:entryFontSize] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *contentLabel = [ViewUtil makeLabel:CGRectMake(60, 30, w, s.height) text:entry.content font:[UIFont systemFontOfSize:entryFontSize]];
    [v addSubview:contentLabel];
    return v;
}

@end
