//
//  CellBuilder.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/05/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFactory.h"
#import "RoomData.h"

@interface CellBuilder : NSObject {
    DataFactory *_factory;
    dispatch_queue_t _globalQueue;
    dispatch_queue_t _localQueue;
}

@property(nonatomic, retain) DataFactory *factory;

- (CGFloat)getRoomCellHeight:(CGSize)size room:(RoomData *)room portrate:(BOOL)portrate;
- (UIView *)getRoomCellView:(CGSize)size room:(RoomData *)room portrate:(BOOL)portrate;
- (CGFloat)getEntryCellHeight:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate;
- (UIView *)getEntryCellView:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate;
- (UIView *)getNextPageCellView:(CGSize)size portrate:(BOOL)portrate;

@end
