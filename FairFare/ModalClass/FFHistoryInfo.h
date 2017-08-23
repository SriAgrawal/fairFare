//
//  FFHistoryInfo.h
//  FairFare
//
//  Created by Deepak Chauhan on 05/08/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"

@interface FFHistoryInfo : NSObject

// History
@property (nonatomic,strong) NSString *fromAddress;
@property (nonatomic,strong) NSString *toAddress;

@property (nonatomic,strong) NSString *fromAddressLat;
@property (nonatomic,strong) NSString *fromAddressLong;

@property (nonatomic,strong) NSString *toAddressLat;
@property (nonatomic,strong) NSString *toAddressLong;

@property (nonatomic,strong) NSString *dateAndTime;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *dateTimeStamp;
@property (nonatomic,strong) NSString *dateString;

@property (nonatomic,strong) NSString *historyFormattedDateAndTime;

// Favourite
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *placeAddress;
@property (nonatomic,strong) NSString *placeLat;
@property (nonatomic,strong) NSString *placeLong;
@property (nonatomic,strong) NSString *locationId;
@property (nonatomic,strong) NSString *selectedTitle;
@property (nonatomic,assign) BOOL isSelect;



+(FFHistoryInfo *)fetchAllHistory:(NSDictionary *)dict;


@end
