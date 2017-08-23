//
//  PAPagination.m
//  PropertyApp
//
//  Created by Ankit Kumar Gupta on 04/08/15.
//  Copyright (c) 2015 Mobiloitte. All rights reserved.
//

#import "PAPagination.h"
#import "Header.h"

@implementation PAPagination


+(PAPagination *)getPaginationInfoFromDict : (NSDictionary *)data {
    
    PAPagination *page = [[PAPagination alloc] init];
    page.pageNo = [data objectForKeyNotNull:@"pageNumber" expectedObj:@""];
    
   // page.pageSize = [data objectForKeyNotNull:PARAM_PageSize expectedObj:@"0"];
    page.maxPageNo = [data objectForKeyNotNull:@"maxPage" expectedObj:@""];
   // page.totalNumberOfRecords = [data objectForKeyNotNull:PARAM_TotalNoRecords expectedObj:@"0"];
    
    return page;
}


@end
