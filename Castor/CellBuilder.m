//
//  CellBuilder.m
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CellBuilder.h"

@interface CellBuilder (Private)
- (UILabel *)_makeLabel:(CGRect)rect text:(NSString *)text font:(UIFont *)font;
- (UIImageView *)_makeIcon:(CGRect)rect;
@end

@implementation CellBuilder

@synthesize factory = _factory;

static const int GROUP_FONT_SIZE  = 14;
static const int ENTRY_FONT_SIZE  = 12;
static const int INDENT_FONT_SIZE = 10;
static const int INDENT_WIDTH     = 6;
static const int SECTION_HEADER_FONT_SIZE = 16;

- (id)initWithDataFactory:(DataFactory *)factory
{
    self = [super init];
    if(self){
        self.factory = factory;
        _localQueue = dispatch_queue_create("cube.Castor", NULL);
        _mainQueue = dispatch_get_main_queue();
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(_localQueue);
    self.factory = nil;
    [super dealloc];
}

- (UIView *)getRoomHeaderView:(RoomData *)room target:(id)target action:(SEL)action section:(NSInteger)section portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [v setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [v setAlpha:0.8];
    float w = (portrate) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height;
    UILabel *nameLabel = [self _makeLabel:CGRectMake(10, 0, w - 10, 20) text:room.roomName font:[UIFont systemFontOfSize:SECTION_HEADER_FONT_SIZE]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:SECTION_HEADER_FONT_SIZE]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setShadowColor:[UIColor darkTextColor]];
    [nameLabel setShadowOffset:CGSizeMake(1.0f, 1.0f)];
    [v addSubview:nameLabel];
    
    if (target != nil) {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow001_black.gif"]];
        [icon setFrame:CGRectMake(w - 20, 5, 10, 10)];
        [v addSubview:icon];
        [icon release];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, w, 20)];
        [button setTag:section];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:button];
        
    }
    return v;
}

- (CGFloat)getRoomCellHeight:(RoomData *)room portrate:(BOOL)portrate
{
    float w = (portrate) ? [[UIScreen mainScreen] bounds].size.width - 70 : [[UIScreen mainScreen] bounds].size.height - 70;
    CGSize s = [room.roomName sizeWithFont:[UIFont systemFontOfSize:GROUP_FONT_SIZE] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    float height = 10 + s.height + 10;
    return (height<40)?40:height;
}

- (UIView *)getRoomCellView:(RoomData *)room portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    float w = (portrate) ? [[UIScreen mainScreen] bounds].size.width - 70 : [[UIScreen mainScreen] bounds].size.height - 70;
    CGSize s = [room.roomName sizeWithFont:[UIFont systemFontOfSize:GROUP_FONT_SIZE] constrainedToSize:CGSizeMake(w, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *nameLabel = [self _makeLabel:CGRectMake(60, 10, w, s.height) text:room.roomName font:[UIFont systemFontOfSize:GROUP_FONT_SIZE]];
    [v addSubview:nameLabel];
    UIImageView *icon = [self _makeIcon:CGRectMake(20, 5, 30, 30)];
    [icon setImage:[UIImage imageNamed:@"myrooms_gray.png"]];
    [v addSubview:icon];
    if (room.roomIcon != nil && room.roomIcon.size.height != 0 && room.roomIcon.size.width != 0) {
        float height = 30 * room.roomIcon.size.height / room.roomIcon.size.width;
        [icon setFrame:CGRectMake(20, 5 + 15 - height / 2, 30, height)];
        [icon setImage:room.roomIcon];
    }
    else {
        [icon retain];
        [room retain];
        dispatch_async(_localQueue, ^{
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            room.roomIcon = [self.factory getRoomIconByRoomId:room.roomId];
            if (room.roomIcon != nil && room.roomIcon.size.height != 0 && room.roomIcon.size.width != 0) {
                dispatch_async(_mainQueue, ^{
                    float height = 30 * room.roomIcon.size.height / room.roomIcon.size.width;
                    [icon setFrame:CGRectMake(20, 5 + 15 - height / 2, 30, height)];
                    [icon setImage:room.roomIcon];
                });
            }
        
            [pool release];
            [room release];
            [icon release];
        });
    }
    return v;
}

- (CGFloat)getEntryCellHeight:(EntryData *)entry portrate:(BOOL)portrate
{
    float w = (portrate) ? [[UIScreen mainScreen] bounds].size.width - 100 : [[UIScreen mainScreen] bounds].size.height - 100;
    CGSize s = [entry.content sizeWithFont:[UIFont systemFontOfSize:ENTRY_FONT_SIZE] constrainedToSize:CGSizeMake(w-[entry.level intValue]*INDENT_WIDTH, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    float height = 30 + s.height + 20 + [entry.level intValue]*INDENT_WIDTH;
    return (height<60)?60:height;
}

- (UIView *)getEntryCellView:(EntryData *)entry portrate:(BOOL)portrate
{
    UIView *v = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    NSString *str = @"";
    for (int i = 0; i < [entry.level intValue]; i++) {
        str = [str stringByAppendingString:@">"];
    }
    UILabel *indentLabel = [self _makeLabel:CGRectMake(10, 10, 40, 16) text:str font:[UIFont systemFontOfSize:INDENT_FONT_SIZE]];
    [v addSubview:indentLabel];
    UILabel *nameLabel = [self _makeLabel:CGRectMake(60+[entry.level intValue]*INDENT_WIDTH, 10, 250, 16) text:entry.participationName font:[UIFont boldSystemFontOfSize:ENTRY_FONT_SIZE]];
    [v addSubview:nameLabel];
    float w = (portrate) ? [[UIScreen mainScreen] bounds].size.width - 100 : [[UIScreen mainScreen] bounds].size.height - 100;
    if (entry.attachmentType != nil) {
        UILabel *attachmentLabel = [self _makeLabel:CGRectMake(w, 15, 100, 10) text:[NSString stringWithFormat:@"<%@ attached>", entry.attachmentType] font:[UIFont systemFontOfSize:INDENT_FONT_SIZE]];
        [v addSubview:attachmentLabel];
    }
    CGSize s = [entry.content sizeWithFont:[UIFont systemFontOfSize:ENTRY_FONT_SIZE] constrainedToSize:CGSizeMake(w-[entry.level intValue]*INDENT_WIDTH, 1024) lineBreakMode:UILineBreakModeCharacterWrap];
    UILabel *contentLabel = [self _makeLabel:CGRectMake(60+[entry.level intValue]*INDENT_WIDTH, 30, w-[entry.level intValue]*INDENT_WIDTH, s.height+[entry.level intValue]*INDENT_WIDTH) text:entry.content font:[UIFont systemFontOfSize:ENTRY_FONT_SIZE]];
    [v addSubview:contentLabel];
    if (entry.descendantsCount != nil) {
        UILabel *descendantsLabel = [self _makeLabel:CGRectMake(w, 5, 100, 10) 
                                                text:[NSString stringWithFormat:@"%@ comments", entry.descendantsCount] font:[UIFont systemFontOfSize:INDENT_FONT_SIZE]];
        [v addSubview:descendantsLabel];
    }
    UIImageView *icon = [self _makeIcon:CGRectMake(20+[entry.level intValue]*INDENT_WIDTH, 5, 30, 30)];
    [icon setImage:[UIImage imageNamed:@"myrooms_gray.png"]];
    [v addSubview:icon];
    if (entry.participationIcon != nil && entry.participationIcon.size.height != 0 && entry.participationIcon.size.width != 0) {
        float height = 30 * entry.participationIcon.size.height / entry.participationIcon.size.width;
        [icon setFrame:CGRectMake(20+[entry.level intValue]*INDENT_WIDTH, 5 + 15 - height / 2, 30, height)];
        [icon setImage:entry.participationIcon];
    }
    else {
        [icon retain];
        [entry retain];
        dispatch_async(_localQueue, ^{
            NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
            entry.participationIcon = [self.factory getParticipationIconByRoomId:entry.roomId participationId:entry.participationId];
            
            if (entry.participationIcon != nil && entry.participationIcon.size.height != 0 && entry.participationIcon.size.width != 0) {
                dispatch_async(_mainQueue, ^{
                    float height = 30 * entry.participationIcon.size.height / entry.participationIcon.size.width;
                    [icon setFrame:CGRectMake(20+[entry.level intValue]*INDENT_WIDTH, 5 + 15 - height / 2, 30, height)];
                    [icon setImage:entry.participationIcon];
                });
            }
            [pool release];
            [entry release];
            [icon release];
        });
    }
    return v;
}

- (UIView *)getTriggerHeader:(CGRect)rect portrate:(BOOL)portrate
{
    rect.origin.y -= 40;
    rect.size.height = 40;
    UIView *v = [[[UIView alloc] initWithFrame:rect] autorelease];
    UILabel *label = [self _makeLabel:CGRectMake(40, 10, 190, 20) text:@"プルダウンすると更新" font:[UIFont systemFontOfSize:ENTRY_FONT_SIZE]];
    label.tag = 1;
    [v addSubview:label];
    UIImageView *arrow = [self _makeIcon:CGRectMake(230, 12, 16, 16)];
    [arrow setImage:[UIImage imageNamed:@"57-download.png"]];
    arrow.tag = 2;
    [v addSubview:arrow];
    
    return v;
}

- (UIView *)getTriggerFooter:(CGRect)rect portrate:(BOOL)portrate
{
    rect.origin.y = 0;
	rect.size.height = 40;
    UIView *v = [[[UIView alloc] initWithFrame:rect] autorelease];
    UILabel *label = [self _makeLabel:CGRectMake(40, 10, 190, 20) text:@"プルアップすると次ページを表示" font:[UIFont systemFontOfSize:ENTRY_FONT_SIZE]];
    label.tag = 1;
    [v addSubview:label];
    UIImageView *arrow = [self _makeIcon:CGRectMake(230, 12, 16, 16)];
    [arrow setImage:[UIImage imageNamed:@"57-upload.png"]];
    arrow.tag = 2;
    [v addSubview:arrow];
    
    return v;
}

- (UIView *)getNilFooter:(CGRect)rect portrate:(BOOL)portrate
{
    rect.origin.y = 0;
    rect.size.height = 40;
    UIView *v = [[[UIView alloc] initWithFrame:rect] autorelease];
    return v;
}

- (NSInteger)getTriggerBounds
{
    return 110;
}

//// Private
- (UILabel *)_makeLabel:(CGRect)rect text:(NSString *)text font:(UIFont *)font
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

- (UIImageView *)_makeIcon:(CGRect)rect
{
    UIImageView *imageView = [[[UIImageView alloc] init] autorelease];
    [imageView setFrame:rect];
    return imageView;
}

@end
