//
//  ViewUtil.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomData.h"
#import "EntryData.h"

@interface ViewUtil : NSObject {
    
}

+ (CGFloat)getRoomCellHeight:(CGSize)size room:(RoomData *)room portrate:(BOOL)portrate;
+ (UIView *)getRoomCellView:(CGSize)size room:(RoomData *)room portrate:(BOOL)portrate;
+ (CGFloat)getEntryCellHeight:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate;
+ (UIView *)getEntryCellView:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate;
+ (UIView *)getNextPageCellView:(CGSize)size portrate:(BOOL)portrate;

@end
