//
//  FFHistoryInfo.m
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import "FFHistoryInfo.h"

@implementation FFHistoryInfo


+(FFHistoryInfo *)fetchAllHistory:(NSDictionary *)dict {
    
    FFHistoryInfo *objHistory = [[FFHistoryInfo alloc] init];
    objHistory.fromAddress = [dict objectForKeyNotNull:@"source" expectedObj:@""];
    objHistory.toAddress = [dict objectForKeyNotNull:@"destination" expectedObj:@""];
    objHistory.fromAddressLat = [dict objectForKeyNotNull:@"source_lat" expectedObj:@""];
    objHistory.fromAddressLong = [dict objectForKeyNotNull:@"source_long" expectedObj:@""];
    objHistory.toAddressLat = [dict objectForKeyNotNull:@"destination_lat" expectedObj:@""];
    objHistory.toAddressLong = [dict objectForKeyNotNull:@"destination_long" expectedObj:@""];
    objHistory.price = [dict objectForKeyNotNull:@"total_amount" expectedObj:@""];
    objHistory.dateTimeStamp = [dict objectForKeyNotNull:@"created_on" expectedObj:@""]; // Get TimeStamp
    // Convert Timestamp to date
    NSDate *dateFromTimeStamp = [NSDate dateWithTimeIntervalSince1970:[objHistory.dateTimeStamp doubleValue]];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, hh:mm a"];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    objHistory.historyFormattedDateAndTime = [dateFormat stringFromDate: dateFromTimeStamp];
    return objHistory;
}


@end
