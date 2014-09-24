//
//  MonthHeaderView.m
//  xike
//
//  Created by Leading Chen on 14-9-8.
//  Copyright (c) 2014年 Leading. All rights reserved.
//

#import "MonthHeaderView.h"



@implementation MonthHeaderView {
    CGRect selectionRect;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)layoutSubviews {
    if (_table == nil) {
        [self createTableView];
    }
    [super layoutSubviews];
}

- (void)createTableView {
    selectionRect = [self.dataSource rectForSelectionInSelector:self];

    _table = [[UITableView alloc] initWithFrame:self.bounds];
    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    _table.transform = rotateTable;
    
    CGFloat OffsetCreated = _table.frame.origin.x;
    _table.frame = self.bounds;
    
    _table.backgroundColor = [UIColor clearColor];
    _table.editing = NO;
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.rowHeight = [self.dataSource rowWidthInSelector:self]/1000;//To keep 3 decimal digits (0.001)
    _table.contentInset = UIEdgeInsetsMake( selectionRect.origin.x , 0, _table.frame.size.height - selectionRect.origin.x - selectionRect.size.width - 2*OffsetCreated, 0);
    _table.showsVerticalScrollIndicator = NO;
    _table.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:_table];
    
}

- (void)reloadData {
    [_table reloadData];
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = [_dataSource numberOfRowsInSelector:self];
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    
    NSArray *contentSubviews = [cell.contentView subviews];
    //We the content view already has a subview we just replace it, no need to add it again
    //hopefully ARC will do the rest and release the old retained view
    
    if ([contentSubviews count] >0 ) {
        //remove all the subviews and add a new one!
        [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *viewToAdd = [_dataSource selector:self viewForRowAtIndex:indexPath.row];
        [cell.contentView addSubview:viewToAdd];
    }
    else {
        
        UILabel *viewToAdd = (UILabel *)[self.dataSource selector:self viewForRowAtIndex:indexPath.row];
        //This is a new cell so we just have to add the view
        [cell.contentView addSubview:viewToAdd];
        
    }
    
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(M_PI_2);
        cell.transform = rotateTable;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _table) {
        //[_table scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:indexPath];
    }
}


#pragma mark Scroll view methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToTheSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollToTheSelectedCell];
    }
}

- (void)scrollToTheSelectedCell {
    
    CGRect selectionRectConverted = [self convertRect:selectionRect toView:_table];
    NSArray *indexPathArray = [_table indexPathsForRowsInRect:selectionRectConverted];
    
    CGFloat intersectionHeight = 0.0;
    NSIndexPath *selectedIndexPath = nil;
    
    for (NSIndexPath *index in indexPathArray) {
        //looping through the closest cells to get the closest one
        UITableViewCell *cell = [_table cellForRowAtIndexPath:index];
        CGRect intersectedRect = CGRectIntersection(cell.frame, selectionRectConverted);
        
        if (intersectedRect.size.height>=intersectionHeight) {
            selectedIndexPath = index;
            intersectionHeight = intersectedRect.size.height;
        }
    }
    if (selectedIndexPath!=nil) {
        //As soon as we elected an indexpath we just have to scroll to it
        [_table scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self.delegate selector:self didSelectRowAtIndex:selectedIndexPath];
    }
}


@end
