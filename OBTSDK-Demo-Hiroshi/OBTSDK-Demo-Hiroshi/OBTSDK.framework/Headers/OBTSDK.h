//
//  OBTSDK.h
//  OBTSDK
//
//  Created by Christian Weinberger on 06/06/16.
//  Copyright © 2016 iconmobile GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for OBTSDK.
FOUNDATION_EXPORT double OBTSDKVersionNumber;

//! Project version string for OBTSDK.
FOUNDATION_EXPORT const unsigned char OBTSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <OBTSDK/PublicHeader.h>

#import <OBTSDK/OBTSDKDelegate.h>
#import <OBTSDK/OBTBrush.h>
#import <OBTSDK/OBTBrushSession.h>

extern NSString * const OBTDeveloperAuthenticationStatusChangedNotification;
extern NSString * const OBTUserAuthenticationStatusChangedNotification;

/**
 *  Indicates the application authorization status. Before using any functionalities of the SDK, you must provide it with
 *  App ID and App Key in order to let the SDK check the app's authorization status.
 */
typedef NS_ENUM(NSInteger, OBTAuthorizationStatus) {
    /**
     *  Authorization status unknown.
     */
    OBTAuthorizationStatusUnknown = -1,
    /**
     *  Access to SDK has not been granted.
     */
    OBTAuthorizationStatusNotAuthorized = 0,
    /**
     *  Access to SDK has been granted.
     */
    OBTAuthorizationStatusAuthorized = 1,
};

/**
 *  Before a third party app can access a user's brush session data they must authorize it. These options reflect the user authorization status of the app.
 */
typedef NS_ENUM(NSInteger, OBTUserAuthorizationStatus) {
    /**
     *  User authorization status unknown.
     */
    OBTUserAuthorizationStatusUnknown = -1,
    /**
     *  Access to user data has not been granted.
     */
    OBTUserAuthorizationStatusNotAuthorized = 0,
    /**
     *  Access to user data has been granted.
     */
    OBTUserAuthorizationStatusAuthorized = 1,
};


/**
 
 The `OBTSDK` is a singleton implementation.
 You must not initialize it directly; instead use the provided class methods.
 
 */
@interface OBTSDK : NSObject

#pragma mark - Setting up the SDK

/**
 *  @name Developer authentication
 */

/**
 *  Before you can use any of the features of the Oral-B SDK it will first check your
 *  authorization status with an App ID and an App Key. In order to obtain these you
 *  have to sign up for a developer account and register your application.
 *
 *  @param appID  The App ID you have received from the developer portal.
 *  @param appKey The App Key you have received from the developer portal.
 */
+ (void)setupWithAppID:(NSString *)appID
                appKey:(NSString *)appKey;

/**
 *  @name Authorize the SDK
 */

/**
 *  Determine your app's developer authorization status.
 *
 *  @return Returns an OBTAuthorizationStatus value to indicate your authorization status. If successfully
 *  authorized this method returns OBTAuthorizationStatusAuthorized.
 */
+ (OBTAuthorizationStatus)authorizationStatus;

#pragma mark - User Authentication

/**
 *  @name User authentication
 */

/**
 *  @name Fetching the user's sessions from the cloud
 */

/**
 *  Determine the user authorization status.
 *
 *  @return Returns an OBTUserAuthorizationStatus value to indicate the user authorization status. If
 *  successfully authorized this method returns OBTUserAuthorizationStatusAuthorized.
 
 */
+ (OBTUserAuthorizationStatus)userAuthorizationStatus;

/**
 *  Use this method to open an authorization page controlled by the SDK.
 *
 *  @param fromViewController The view controller that presents the authorization page
 *  @param completionBlock An optional block that is called once the authorization process was completed or canceled.
 */
+ (void)presentUserAuthorizationFromViewController:(UIViewController *)fromViewController completion:(void(^)(BOOL success, NSError *error))completionBlock;

#pragma mark - Toothbrush Discovery & Connection

/**
 *  @name Toothbrush Discovery & Connection
 */

/**
 *  This method checks whether Bluetooth Low Energy is available, turned on, and ready to establish a connection.
 *
 *  @return A boolean value to indicate whether Bluetooth is available.
 */
+ (BOOL)bluetoothAvailableAndEnabled;

/**
 *  Call this method to start scanning for Oral-B Bluetooth®-enabled toothbrushes.
 */
+ (void)startScanning;

/**
 *  Call this method to stop scanning for Oral-B Bluetooth®-enabled toothbrushes.
 *
 *  You cannot stop scanning while a brush is connected.
 */
+ (void)stopScanning;

/**
 *  Establish a connection to an Oral-B Bluetooth®-enabled toothbrush.
 *
 *  @param toothbrush The toothbrush you want to connect. An OBTBrush object that represents a physical toothbrush handle.
 */
+ (void)connectToothbrush:(OBTBrush *)toothbrush;

/**
 *  Call this method to disconnect the currently connected toothbrush (if any).
 */
+ (void)disconnectToothbrush;

/**
 *  This method checks whether a toothbrush handle is connected.
 *
 *  @return A boolean value that indicates whether a toothbrush is connected.
 */
+ (BOOL)isConnected;

/**
 *  Call this method to check whether the SDK is currently scanning for toothbrushes.
 *
 *  @return A boolean value that indicates whether the SDK is scanning for toothbrushes.
 */
+ (BOOL)isScanning;

/**
 *  Call this method to get the currently connected toothbrush handle.
 *
 *  @return An OBTBrush object that represents the currently connected toothbrush (if any).
 */
+ (OBTBrush *)connectedToothbrush;


/**
 *  Call this method to start synchronizing brush sessions stored on the currently connected toothbrush.
 *  Depending on the model a toothbrush can store up to 30 sessions.
 *  Synchronizing sessions does not delete them from the toothbrush.
 *
 *  Fetched sessions are stored in the storedSession property of the currently connected toothbrush.
 */
+ (void)loadBrushSessionsForConnectedToothbrush;

/**
 *  Call this method to obtain a list of all nearby toothbrushes that broadcast a Bluetooth signal.
 *
 *  @return An array of nearby discoverable toothbrush handles.
 */
+ (NSArray *)nearbyToothbrushes;

#pragma mark - Managing the delegates

/**
 *  @name Managing the delegates
 */

/**
 *  Call this method to register a new delegate.
 *
 *  @param delegate The object that acts as a delegate for the OBTSDK. Delegates must implement the OBTSDKDelegate protocol. The delegate is not retained.
 */
+ (void)addDelegate:(id<OBTSDKDelegate>)delegate;

/**
 *  Call this method to remove an object from the list of delegates.
 *
 *  @param delegate The delegate you want to remove.
 */
+ (void)removeDelegate:(id<OBTSDKDelegate>)delegate;

#pragma mark - Fetching the user's sessions from the WebService

+ (void)loadSessionsFromDate:(NSDate *)fromDate
                      toDate:(NSDate *)toDate
             completionBlock:(void(^)(NSArray *sessions))completionBlock
                  errorBlock:(void(^)(NSError *error))errorBlock;

#pragma mark - Other

/**
 *  @name Other
 */

/**
 *  Call this method to retrieve the version of the Oral-B SDK.
 *
 *  @return Returns a string representation of the version of the SDK (x.x.x).
 */
+ (NSString *)version;

@end

