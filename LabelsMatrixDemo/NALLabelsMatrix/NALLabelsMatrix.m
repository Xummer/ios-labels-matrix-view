//
//  NALLabelsMatrix.m
//
//  Created by neeks on 04/02/14.
//  Copyright (c) 2014 neeks. All rights reserved.
//

#import "NALLabelsMatrix.h"

#define MATRIX_TEXT_FONT        [UIFont fontWithName:@"Helvetica" size:12.0]
#define MATRIX_BOARD_COLOR      [UIColor colorWithWhite:0.821 alpha:1.0f]
#define MATRIX_TITLE_BG_COLOR   [UIColor colorWithWhite:247.0f/255.0f alpha:1.0f]
#define MATRIX_ROW_BG_COLOR     [UIColor colorWithRed:249.0f/255.0f green:251.0f/255.0f blue:240.0f/255.0f alpha:1.0f]

@interface NALLabelsMatrix ()
{
    NSArray *columnsWidths;
    NSUInteger numRows;
    NSUInteger dy;
}

// Form Data
@property (strong, nonatomic) NSMutableArray *m_arrRowDatas;
@property (strong, nonatomic) NSMutableArray *m_arrRowHeights;
@property (strong, nonatomic) NSMutableArray *m_arrMatrixLabels;

// Edit Data
@property (strong, nonatomic) NSMutableArray *m_arrDeleteBtns;

@end

@implementation NALLabelsMatrix

#pragma mark - Life Cycle
- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns {
    self = [super initWithFrame:frame];
    if (self) {
        numRows = 0;
        self->columnsWidths = columns;
		self->dy = 0;
		self->numRows = 0;
        
        self.m_arrRowDatas = [NSMutableArray array];
        self.m_arrRowHeights = [NSMutableArray array];
        self.m_arrMatrixLabels = [NSMutableArray array];
        
        self.m_bIsEditable = NO;
        self.m_arrDeleteBtns = [NSMutableArray array];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.window) {
        for (UIView *v in _m_arrDeleteBtns) {
            if (v.tag == 0) {
                v.hidden = YES;
            }
            [self.superview addSubview:v];
        }
    }
    else {
        [_m_arrDeleteBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)dealloc {
    [_m_arrDeleteBtns makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - Setter
- (void)setM_bIsEditable:(BOOL)bIsEditable {
    if (_m_bIsEditable == bIsEditable) {
        return;
    }
    
    _m_bIsEditable = bIsEditable;
    
    for (UIView *editV in _m_arrDeleteBtns) {
        editV.hidden = !_m_bIsEditable;
    }
}

#pragma mark - Public Method
- (NSUInteger)rowsCount {
    return numRows;
}

- (void)addRecord:(NSArray*)record {
    if(record.count != self->columnsWidths.count){
        NSLog(@"!!! Number of items does not match number of columns. !!!");
        return;
    }
    
    CGFloat rowHeight = 30;
	CGFloat dx = 0;
	
    NSMutableArray* labels = [NSMutableArray array];
    
	//CREATE THE ITEMS/COLUMNS OF THE ROW
    for(NSUInteger i = 0; i < record.count; i++){
        float colWidth = [self->columnsWidths[ i ] floatValue];	//colwidth as given at setup
        CGRect rect = CGRectMake(dx, dy, colWidth, rowHeight);
		
		//ADJUST X FOR BORDER OVERLAPPING BETWEEN COLUMNS
		if(i > 0){
			rect.origin.x -= i;
		}
        
        //--------------------------------------------
        
        UILabel* col1 = [[UILabel alloc] init];
        [col1.layer setBorderColor:[MATRIX_BOARD_COLOR CGColor]];
        [col1.layer setBorderWidth:1.0];
		col1.font = MATRIX_TEXT_FONT;
		col1.frame = rect;
        
		
		//SET LEFT RIGHT MARGINS & ALIGNMENT FOR THE LABEL
		NSMutableParagraphStyle *style =
        [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		style.alignment = NSTextAlignmentNatural;
		style.headIndent = 10;
		style.firstLineHeadIndent = 10.0;
		style.tailIndent = -10.0;
		
		
		//SPECIAL TREATMENT FOR THE FIRST ROW
        
        if(self->numRows == 0){
            style.alignment = NSTextAlignmentCenter;
			col1.backgroundColor = MATRIX_TITLE_BG_COLOR;
        }
        else if (self->numRows % 2 == 0) {
            col1.backgroundColor = MATRIX_ROW_BG_COLOR;
        }
		
		NSAttributedString *attrText =
        [[NSAttributedString alloc] initWithString:record[ i ]
                                        attributes:@{ NSParagraphStyleAttributeName : style }];
		
        col1.lineBreakMode = NSLineBreakByCharWrapping;
        col1.numberOfLines = 0;
		col1.attributedText = attrText;
		[col1 sizeToFit];
        
		
		//USED TO FIND HEIGHT OF LONGEST LABEL
        CGFloat h = col1.frame.size.height + 10;
        if(h > rowHeight){
            rowHeight = h;
        }
        
		//MAKE THE LABEL WIDTH SAME AS COLUMN'S WIDTH
		rect.size.width = colWidth;
        col1.frame = rect;
        
        [labels addObject:col1];
		
		//USED FOR SETTING THE NEXT COLUMN X POSITION
		dx += colWidth;
    }
    
    // DELETEBTN
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.tag = numRows;
    [deleteBtn setImage:[UIImage imageNamed:@"MatrixRowDelete"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self
                  action:@selector(onDeleteAction:)
        forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.hidden = !_m_bIsEditable;
    
    CGFloat fW = 30.0f;
    deleteBtn.frame = (CGRect){
        .origin.x = MAX(-2, CGRectGetMinX(self.frame) - fW * .8f),
        .origin.y = CGRectGetMinY(self.frame) + dy + (rowHeight - fW) * .5f,
        .size.width = fW,
        .size.height = fW
    };
    if (self.superview) {
        [self.superview addSubview:deleteBtn];
    }
    [self.m_arrDeleteBtns addObject:deleteBtn];    
    
	//MAKE ALL THE LABELS OF SAME HEIGHT AND THEN ADD TO VIEW
    for (UILabel* tempLabel in labels) {
        CGRect tempRect = tempLabel.frame;
        tempRect.size.height = rowHeight;
		tempLabel.frame = tempRect;
        [self addSubview:tempLabel];
    }
    
    [self.m_arrMatrixLabels addObject:labels];
	
    self->numRows++;
	
	
	//ADJUST y FOR BORDER OVERLAPPING BETWEEN ROWS
    CGFloat fRowH = rowHeight - 1;
    [self.m_arrRowHeights addObject:@( fRowH )];
	self->dy += fRowH;
	
	
	//RESIZE THE MAIN VIEW TO FIT THE ROWS
	CGRect tempRect = self.frame;
	tempRect.size.height = dy;
	self.frame = tempRect;
}

- (void)removeRecordAtRow:(NSUInteger)uiRow {
    
    if (uiRow <= 0 || uiRow >= [_m_arrMatrixLabels count]) {
        return;
    }
    
    NSArray *arrLablesToRemove = _m_arrMatrixLabels[ uiRow ];
    CGFloat fRowHeightToRemove = [_m_arrRowHeights[ uiRow ] floatValue];
    UIView *deleteBtn = _m_arrDeleteBtns[ uiRow ];
    
    [self.m_arrMatrixLabels removeObjectAtIndex:uiRow];
    [self.m_arrRowHeights removeObjectAtIndex:uiRow];
    [self.m_arrDeleteBtns removeObjectAtIndex:uiRow];
    
    self->numRows --;
    self->dy -= fRowHeightToRemove;
    
    // REMOVE DELETE BTN
    [deleteBtn removeFromSuperview];
    
    // REMOVE LABLES
    [arrLablesToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // RESIZE LEFT VIEWS
    UIColor *bgColor;
    CGRect tmpRect;
    for (NSUInteger i = uiRow; i < [_m_arrMatrixLabels count]; i ++) {
        if(i == 0){
            bgColor = MATRIX_TITLE_BG_COLOR;
        }
        else if (i % 2 == 0) {
            bgColor = MATRIX_ROW_BG_COLOR;
        }
        else {
            bgColor = [UIColor whiteColor];
        }
        
        NSArray *arrLabels = _m_arrMatrixLabels[ i ];
        for (UILabel *col in arrLabels) {
            col.backgroundColor = bgColor;
            tmpRect = col.frame;
            tmpRect.origin.y -= fRowHeightToRemove;
            col.frame = tmpRect;
        }
        
        UIView *deleteBtn = _m_arrDeleteBtns[ i ];
        deleteBtn.tag = uiRow;
        tmpRect = deleteBtn.frame;
        tmpRect.origin.y -= fRowHeightToRemove;
        deleteBtn.frame = tmpRect;
    }
    
    //RESIZE THE MAIN VIEW TO FIT THE ROWS
    CGRect tempRect = self.frame;
    tempRect.size.height = dy;
    self.frame = tempRect;
    
}

#pragma mark - Private Method
- (void)onDeleteAction:(id)sender {
    UIButton *btn = sender;
    [self removeRecordAtRow:btn.tag];
}

@end
