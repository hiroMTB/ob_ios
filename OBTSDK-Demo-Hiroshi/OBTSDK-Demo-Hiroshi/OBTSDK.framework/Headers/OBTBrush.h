//
//  OBTBrush.h
//  OBTSDK
//
//  Created by Christian Weinberger on 30/06/14.
//  Copyright (c) 2014 iconmobile GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Brush modes (not all models support the full list of modes).
 */
typedef NS_ENUM(NSInteger, OBTBrushMode) {
    /**
     *  Brush mode unknown.
     */
    OBTBrushModeUnknown = 0,
    /**
     *  Daily Clean mode.
     */
    OBTBrushModeDailyClean = 1,
    /**
     *  Sensitive mode.
     */
    OBTBrushModeSensitive,
    /**
     *  Massage mode.
     */
    OBTBrushModeMassage,
    /**
     *  Whitening mode.
     */
    OBTBrushModeWhitening,
    /**
     *  Deep Clean mode.
     */
    OBTBrushModeDeepClean,
    /**
     *  Tongue Cleaning mode.
     */
    OBTBrushModeTongue
};

extern NSString * NSStringFromOBTBrushingMode(OBTBrushMode brushingMode);

/**
 *  Describes the state of a toothbrush.
 */
typedef NS_ENUM(NSInteger, OBTDeviceState) {
    /**
     *  Toothbrush device state unknown.
     */
    OBTDeviceStateUnkown = 0,
    /**
     *  Idle (Bluetooth is enabled, motor is turned off).
     */
    OBTDeviceStateIdle = 1,
    /**
     *  Bbrushing (Bluetooth is enabled, motor is turned on).
     */
    OBTDeviceStateBrushing,
    /**
     *  Toothbrush is on the charger.
     */
    OBTDeviceStateCharger
};

extern NSString * NSStringFromOBTDeviceState(OBTDeviceState deviceState);

@interface OBTBrush : NSObject

/**
 *  The display name of the brush. (read-only)
 */
@property (nonatomic, strong, readonly)     NSString        *name;

/**
 *  Indicates whether the toothbrush is connected. (read-only)
 */
@property (nonatomic, readonly)             BOOL            isConnected;

/**
 *  Indicates whether the toothbrush is a preferred one. (read-only)
 */
@property (nonatomic, readonly)             BOOL            isPreferredBrush;

/**
 *  The current RSSI value (Received Signal Strength Indication) of the peripheral, in decibels.
 */
@property (nonatomic, readonly)             float           RSSI;

/**
 *  The local ID of the toothbrush handle. (read-only)
 */
@property (nonatomic, readonly, strong)     NSString        *localHandleID;

/**
 *  The remote ID of the toothbrush handle. (read-only)
 */
@property (nonatomic, readonly)             long            remoteHandleID;

/**
 *  A value that represents the type of the toothbrush handle. (read-only)
 */
@property (nonatomic, readonly)             NSString        *handleType;

/**
 *  An OBTDeviceState value that represents the current device state. (read-only)
 */
@property (nonatomic, readonly)             OBTDeviceState  deviceState;

/**
 *  The current battery level (0.0 - 1.0). (read-only)
 */
@property (nonatomic, readonly)             float           batteryLevel;

/**
 *  An OBTBrushMode value that represents the current brushing mode. (read-only)
 */
@property (nonatomic, readonly)             OBTBrushMode    brushMode;

/**
 *  An NSTimeInterval that represents the duration of the current brushing session. (read-only)
 */
@property (nonatomic, readonly)             NSTimeInterval  brushingDuration;

/**
 *  Indicates the current brushing sector. (read-only)
 */
@property (nonatomic, readonly)             int             sector;

/**
 *  Indicates whether the user is applying too much pressure. (read-only)
 */
@property (nonatomic, readonly)             BOOL            overpressure;

/**
 *  An array of OBTBrushSession objects. (read-only)
 */
@property (nonatomic, strong, readonly)     NSArray         *cachedSessions;

/**
 *  Represents the protocol version of the toothbrush firmware. (read-only)
 */
@property (nonatomic, readonly)             int             protocolVersion;

/**
 *  Represents the software version of the toothbrush firmware. (read-only)
 */
@property (nonatomic, readonly)             int             softwareVersion;

/**
 *  The list of brush modes currently set up on the toothbrush. (read-only)
 */
@property (nonatomic, strong, readonly)     NSArray         *brushModes;

@end
