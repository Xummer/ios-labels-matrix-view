//
//  NALLabelsMatrix.h
//
//  Created by neeks on 04/02/14.
//  Copyright (c) 2014 neeks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NALLabelsMatrix : UIView

@property (assign, nonatomic) BOOL m_bIsEditable;

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray *)columns NS_DESIGNATED_INITIALIZER;

- (NSUInteger)rowsCount;

- (void)addRecord:(NSArray *)record;
- (void)removeRecordAtRow:(NSUInteger)uiRow;

@end