#import <OBTSDK/OBTSDK.h>

@class OBTCloudEngine;
@class ToothbrushManager;
@class TBBrushDataConfig;
@class Toothbrush;

extern NSString * const OBTCloudSyncFinishedNotification;
extern NSString * const OBTCloudSyncFailedNotification;

@interface OBTSDK()

@property (nonatomic, strong, readonly) NSString *appID;
@property (nonatomic, strong, readonly) NSString *appKey;
@property (nonatomic, strong, readonly) NSString *bearerToken;
@property (nonatomic, strong, readonly) NSString *userToken;

@property (nonatomic, readwrite) OBTAuthorizationStatus authorizationStatus;
@property (nonatomic, readwrite) OBTUserAuthorizationStatus userAuthorizationStatus;

- (instancetype)initWithCloudEngine:(OBTCloudEngine *)aCloudEngine toothBrushManager:(ToothbrushManager *)aToothbrushManager;

- (void)setupWithAppID:(NSString *)appID appKey:(NSString *)appKey;

- (void)presentUserAuthorizationFromViewController:(UIViewController *)fromViewController completion:(void (^)(BOOL, NSError *))completionBlock;

- (BOOL)bluetoothAvailableAndEnabled;

- (void)startScanning;

- (void)stopScanning;

- (void)disconnectToothbrush;

- (BOOL)isConnected;

- (BOOL)isScanning;

- (OBTBrush *)connectedToothbrush;

- (void)loadBrushSessionsForConnectedToothbrush;

- (NSArray *)nearbyToothbrushes;

- (void)addDelegate:(id)delegate;

- (void)removeDelegate:(id)delegate;

- (void)loadSessionsFromDate:(NSDate *)fromDate
                      toDate:(NSDate *)toDate
             completionBlock:(void(^)(NSArray *sessions))completionBlock
                  errorBlock:(void(^)(NSError *error))errorBlock;


#pragma ToothbrushManager delegate methods

- (void)toothbrushManagerDidLoadSession:(TBBrushDataConfig *)sessionValue
                                  index:(NSUInteger)index
                                  count:(NSUInteger)count
                               finished:(BOOL)finished;

- (void)toothbrushManagerDidConnectToothbrush:(Toothbrush *)toothbrush;

@end
