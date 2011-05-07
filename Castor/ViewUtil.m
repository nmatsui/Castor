//
//  ViewUtil.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewUtil.h"


@implementation ViewUtil
static const int GROUP_FONT_SIZE  = 14;
static const int ENTRY_FONT_SIZE  = 12;
static const int INDENT_FONT_SIZE = 10;
static const int INDENT_WIDTH     = 6;

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

+ (UITextView *)makeTextView:(CGRect)rect text:(NSString *)text font:(UIFont *)font
{
    UITextView *textView = [[[UITextView alloc] init] autorelease];
    [textView setFrame:rect];
    [textView setText:text];
    [textView setFont:font];
    [textView setTextColor:[UIColor blackColor]];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setTextAlignment:UITextAlignmentLeft];
    [textView setDataDetectorTypes:UIDataDetectorTypeLink];
    return textView;
}

+ (UIImageView *)makeIcon:(CGRect)rect image:(UIImage *)image
{
    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
    [imageView setFrame:rect];
    [imageView setImage:image];
    return imageView;
}

+ (CGFloat)getRoomCellHeight:(CGSize)size room:(RoomData *)room portrate:(BOOL)portrate
{
    float w = (portrate) ? size.width - 70 : size.height - 70;
    CGSize s = [room.roomName sizeWithFont:[UIFont systemFontOfSize:GROUP_FONT_SIZE] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    float height = 10 + s.height + 10;
    return (height<40)?40:height;
}

+ (UIView *)getRoomCellView:(CGSize)size room:(RoomData *)room portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    UIImageView *icon = [ViewUtil makeIcon:CGRectMake(20, 5, 30, 30) image:room.roomIcon];
    [v addSubview:icon];
    float w = (portrate) ? size.width - 70 : size.height - 70;
    CGSize s = [room.roomName sizeWithFont:[UIFont systemFontOfSize:GROUP_FONT_SIZE] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *nameLabel = [ViewUtil makeLabel:CGRectMake(60, 10, w, s.height) text:room.roomName font:[UIFont systemFontOfSize:GROUP_FONT_SIZE]];
    [v addSubview:nameLabel];
    return v;
}

+ (CGFloat)getEntryCellHeight:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate
{
    float w = (portrate) ? size.width - 70 : size.height - 70;
    CGSize s = [entry.content sizeWithFont:[UIFont systemFontOfSize:ENTRY_FONT_SIZE] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    float height = 30 + s.height + 20;
    return (height<60)?60:height;
}

+ (UIView *)getEntryCellView:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    NSString *str = @"";
    for (int i = 0; i < [entry.level intValue]; i++) {
        str = [str stringByAppendingString:@">"];
    }
    UILabel *indentLabel = [ViewUtil makeLabel:CGRectMake(10, 10, 40, 16) text:str font:[UIFont systemFontOfSize:INDENT_FONT_SIZE]];
    [v addSubview:indentLabel];
    UIImageView *icon = [ViewUtil makeIcon:CGRectMake(20+[entry.level intValue]*INDENT_WIDTH, 5, 30, 30) image:entry.participationIcon];
    [v addSubview:icon];
    UILabel *nameLabel = [ViewUtil makeLabel:CGRectMake(60+[entry.level intValue]*INDENT_WIDTH, 10, 250, 16) text:entry.participationName font:[UIFont boldSystemFontOfSize:ENTRY_FONT_SIZE]];
    [v addSubview:nameLabel];
    float w = (portrate) ? size.width - 100 : size.height - 100;
    if (entry.attachmentType != nil) {
        UILabel *attachmentLabel = [ViewUtil makeLabel:CGRectMake(w, 10, 100, 16) text:[NSString stringWithFormat:@"<%@ attached>", entry.attachmentType] font:[UIFont systemFontOfSize:ENTRY_FONT_SIZE]];
        [v addSubview:attachmentLabel];
    }
    CGSize s = [entry.content sizeWithFont:[UIFont systemFontOfSize:ENTRY_FONT_SIZE] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *contentLabel = [ViewUtil makeLabel:CGRectMake(60+[entry.level intValue]*INDENT_WIDTH, 30, w-[entry.level intValue]*INDENT_WIDTH, s.height) text:entry.content font:[UIFont systemFontOfSize:ENTRY_FONT_SIZE]];
//    UITextView *contentText = [ViewUtil makeTextView:CGRectMake(60+[entry.level intValue]*INDENT_WIDTH, 30, w-[entry.level intValue]*INDENT_WIDTH, s.height) text:entry.content font:[UIFont systemFontOfSize:ENTRY_FONT_SIZE]];
    [v addSubview:contentLabel];
    return v;
}

+ (UIView *)getNextPageCellView:(CGSize)size portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    float w = (portrate) ? size.width - 10 : size.height - 10;
    UILabel *nextLabel = [ViewUtil makeLabel:CGRectMake(10, 0, w, 40) text:@"<<load next page>>" font:[UIFont systemFontOfSize:ENTRY_FONT_SIZE]];
    [nextLabel setTextAlignment:UITextAlignmentCenter];
    [v addSubview:nextLabel];
    return v;
}


@end
