//
//  DeepLinking.m
//  FairFareApp
//
//  Created by Shridhar Agarwal on 23/06/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "DeepLinking.h"

@implementation DeepLinking


+(void)callDeepLinkingOfHailo
{
    
    NSURL* url = [NSURL URLWithString:@"hailoapp://confirm?pickupCoordinate=51.511807,-0.117389&pickupAddress=Somerset%20House,%20Strand&referrer=2znqNsLu2TT3VUiTI0QP2V551mo52FFN5dezf7vj6f+IJ45IMD8VGMnN05x4Ui8j2sQ5MFa9k/fH0X42lyv8vYkmPyYUzBeV14eXWZr4drE4NFshG6W8lwdeNwuFTIh7e2o/0PJ5HPvyiuki8OLmi3u5WOm8LN+3gRn/JEBoCbkAOaJqKtRmOwJEf+7WD3L5XqDmKVh9pp2Q+GGuslg77A=="];
    
    //    NSString *token =@"2znqNsLu2TT3VUiTI0QP2V551mo52FFN5dezf7vj6f+IJ45IMD8VGMnN05x4Ui8j2sQ5MFa9k/fH0X42lyv8vYkmPyYUzBeV14eXWZr4drE4NFshG6W8lwdeNwuFTIh7e2o/0PJ5HPvyiuki8OLmi3u5WOm8LN+3gRn/JEBoCbkAOaJqKtRmOwJEf+7WD3L5XqDmKVh9pp2Q+GGuslg77A==";
    //    NSString *urlString = [NSString stringWithFormat:@"hailoapp://confirm?pickupCoordinate=%@&referrer=%@",self.strPickMeCoordinate,token];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]){
        // The Hailo app is installed: launch it
        [[UIApplication sharedApplication] openURL:url];
    }
    else {
        // Hailo is not installed: take the user to the App Store
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/hailo-taxi-app/id468420446"]];
    }
}

+(void)callDeepLinkingOfUber
{
        
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uber://?client_id=YOUR_CLIENT_ID&action=setPickup&pickup[latitude]=37.775818&pickup[longitude]=-122.418028&pickup[nickname]=UberHQ&pickup[formatted_address]=1455%20Market%20St%2C%20San%20Francisco%2C%20CA%2094103&dropoff[latitude]=37.802374&dropoff[longitude]=-122.405818&dropoff[nickname]=Coit%20Tower&dropoff[formatted_address]=1%20Telegraph%20Hill%20Blvd%2C%20San%20Francisco%2C%20CA%2094133&product_id=a1111c8c-c720-46c3-8534-2fcdd730040d&link_text=View%20team%20roster&partner_deeplink=partner%3A%2F%2Fteam%2F9383"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"uber://?client_id=YOUR_CLIENT_ID&action=setPickup&pickup[latitude]=37.775818&pickup[longitude]=-122.418028&pickup[nickname]=UberHQ&pickup[formatted_address]=1455%20Market%20St%2C%20San%20Francisco%2C%20CA%2094103&dropoff[latitude]=37.802374&dropoff[longitude]=-122.405818&dropoff[nickname]=Coit%20Tower&dropoff[formatted_address]=1%20Telegraph%20Hill%20Blvd%2C%20San%20Francisco%2C%20CA%2094133&product_id=a1111c8c-c720-46c3-8534-2fcdd730040d&link_text=View%20team%20roster&partner_deeplink=partner%3A%2F%2Fteam%2F9383"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/uber/id368677368"]];
    }
    
}
+(void)callDeepLinkingOfLyft:(NSString *)pickMeCoordinate withTakeMeTo:(NSString*)takeMeToCoordinate
{
    
    
    NSArray* pickMeCoordinateArray = [pickMeCoordinate componentsSeparatedByString: @","];
    NSString *pickMeLat = [pickMeCoordinateArray objectAtIndex: 0];
    NSString *pickMeLong = [pickMeCoordinateArray objectAtIndex: 1];

    
    NSArray* takeMeCoordinateArray = [takeMeToCoordinate componentsSeparatedByString: @","];
    NSString *takeMeLat = [takeMeCoordinateArray objectAtIndex: 0];
    NSString *takeMeLong = [takeMeCoordinateArray objectAtIndex: 1];
    
    NSString* urlString = [NSString stringWithFormat:@"lyft://ridetype?id=lyft&pickup[latitude]=%@&pickup[longitude]=%@&destination[latitude]=%@&destination[longitude]=%@",pickMeLat,pickMeLong,takeMeLat,takeMeLong];

    UIApplication *myApp = UIApplication.sharedApplication;
    
    NSURL *lyftAppURL = [NSURL URLWithString:urlString];
    if ([myApp canOpenURL:lyftAppURL])
    {
        // Lyft is installed; launch it
        [myApp openURL:lyftAppURL];
    } else
    {
        // Lyft not installed; open App Store
        NSURL *lyftAppStoreURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/lyft-taxi-bus-app-alternative/id529379082"];
        [myApp openURL:lyftAppStoreURL];
    }
    
}
+(void)callDeepLinkingOfWay2Ride
{
    UIApplication *myApp = UIApplication.sharedApplication;
    
    NSURL *way2RideAppURL = [NSURL URLWithString:@"curb://"];
    if ([myApp canOpenURL:way2RideAppURL])
    {
        // Lyft is installed; launch it
        [myApp openURL:way2RideAppURL];
    } else
    {
        // Lyft not installed; open App Store
        NSURL *way2RideAppURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/curb-the-taxi-app/id299226386?mt=8"];
        [myApp openURL:way2RideAppURL];
    }
    
}
@end
