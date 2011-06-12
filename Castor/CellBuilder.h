//
//  CellBuilder.h
//  Castor
//
//  Copyright (C) 2011 Nobuyuki Matsui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFactory.h"
#import "RoomData.h"
#import "EntryData.h"

@interface CellBuilder : NSObject {
    DataFactory *_factory;
    dispatch_queue_t _localQueue;
    dispatch_queue_t _mainQueue;
}

@property(nonatomic, retain) DataFactory *factory;

- (UIView *)getRoomHeaderView:(RoomData *)room target:(id)target action:(SEL)action section:(NSInteger)section portrate:(BOOL)portrate;
- (CGFloat)getRoomCellHeight:(RoomData *)room portrate:(BOOL)portrate;
- (UIView *)getRoomCellView:(RoomData *)room portrate:(BOOL)portrate;
- (CGFloat)getEntryCellHeight:(EntryData *)entry portrate:(BOOL)portrate;
- (UIView *)getEntryCellView:(EntryData *)entry portrate:(BOOL)portrate;
- (UIView *)getTriggerHeader:(CGRect)rect portrate:(BOOL)portrate;
- (UIView *)getTriggerFooter:(CGRect)rect portrate:(BOOL)portrate;
- (UIView *)getNilFooter:(CGRect)rect portrate:(BOOL)portrate;
- (NSInteger)getTriggerBounds;
- (id)initWithDataFactory:(DataFactory *)factory;

@end
