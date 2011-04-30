//
//  ViewUtil.h
//  Castor
//
//  Created by Nobuyuki Matsui on 11/04/30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupData.h"
#import "EntryData.h"

@interface ViewUtil : NSObject {
    
}

+ (CGFloat)getGroupCellHeight:(CGSize)size group:(GroupData *)group portrate:(BOOL)portrate;
+ (UIView *)getGroupCellView:(CGSize)size group:(GroupData *)group portrate:(BOOL)portrate;
+ (CGFloat)getEntryCellHeight:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate;
+ (UIView *)getEntryCellView:(CGSize)size entry:(EntryData *)entry portrate:(BOOL)portrate;

@end
