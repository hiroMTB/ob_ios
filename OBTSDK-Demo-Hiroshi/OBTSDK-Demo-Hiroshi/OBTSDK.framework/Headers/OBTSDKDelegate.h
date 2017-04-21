//
//  OBTSDKDelegate.h
//  OBTSDK
//
//  Created by Christian Weinberger on 30/06/14.
//  Copyright (c) 2014 iconmobile GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OBTSDK/OBTBrush.h>

@class OBTBrushSession;

/**
 *  The delegate of the OBTSDK must implement the OBTSDKDelegate protocol. This protocol enables you to handle status changes and updated values of a connected toothbrush.
 */
@protocol OBTSDKDelegate <NSObject>

@optional

/**
 *  @name Managing the toothbrush state
 */

/**
 *  Notifies delegates when the list of nearby toothbrushes has been updated
 *  e.g. because a new toothbrush was discovered.
 *
 *  @param nearbyToothbrushes An array of nearby toothbrushes (OBTBrush objects)
 */
- (void)nearbyToothbrushesDidChange:(NSArray *)nearbyToothbrushes;

/**
 *  Notifies delegates when a connection to a toothbrush has been established.
 *
 *  @param toothbrush The connected toothbrush
 */
- (void)toothbrushDidConnect:(OBTBrush *)toothbrush;

/**
 *  Notifies delegates when a previously connected toothbrush has been disconnected.
 *
 *  @param toothbrush The disconnected toothbrush
 */
- (void)toothbrushDidDisconnect:(OBTBrush *)toothbrush;

/**
 *  Notifies delegates when a connection could not be established.
 *
 *  @param error The error object with further details.
 */
- (void)toothbrushDidFailWithError:(NSError *)error;

/**
 *  Notifies delegates when a new brush session has been loaded.
 *  Will be invoked for every synced brush session.
 *
 *  @param toothbrush   The respective toothbrush
 *  @param brushSession The brush session that was loaded
 *  @param progress     Progress of the syncing process (0.0 - 1.0)
 */
- (void)toothbrush:(OBTBrush *)toothbrush
    didLoadSession:(OBTBrushSession *)brushSession
          progress:(float)progress;

/**
 *  Notifies delegates when the RSSI value (Received Signal Strength Indication) of a nearby brush has changed
 *
 *  @param toothbrush The respective toothbrush
 *  @param rssi       The currently received signal strength indication of the peripheral, in decibels.
 */
- (void)toothbrush:(OBTBrush *)toothbrush didUpdateRSSI:(float)rssi;

/**
 *  @name Toothbrush values
 */

/**
 *  Notifies delegates when the device state of a connected toothbrush has changed
 *
 *  @param toothbrush  The respective toothbrush
 *  @param deviceState The new device state of the toothbrush
 */
- (void)toothbrush:(OBTBrush *)toothbrush didUpdateDeviceState:(OBTDeviceState)deviceState;

/**
 *  Notifies delegates when the battery level of a connected tootgbrush has changed
 *
 *  @param toothbrush   The respective toothbrush
 *  @param batteryLevel The current battery level of the toothbrush
 */
- (void)toothbrush:(OBTBrush *)toothbrush didUpdateBatteryLevel:(float)batteryLevel;

/**
 *  Notifies delegates when the brush mode of a connected brush has changed
 *
 *  @param toothbrush The respective toothbrush
 *  @param brushMode  The currently selected brush mode of the toothbrush
 */
- (void)toothbrush:(OBTBrush *)toothbrush didUpdateBrushMode:(OBTBrushMode)brushMode;

/**
 *  Notifies delegates when the current brushing duration of a connected toothbrush has been updated
 *
 *  @param toothbrush       The respective toothbrush
 *  @param brushingDuration The current brushing duration of the toothbrush
 */
- (void)toothbrush:(OBTBrush *)toothbrush didUpdateBrushingDuration:(NSTimeInterval)brushingDuration;

/**
 *  Notifies delegates when the current brushing sector of a connected toothbrush has changed
 *
 *  @param toothbrush The respective toothbrush
 *  @param sector     The current sector (as assumed by the toothbrush)
 *
 *  @discussion Timers are separated into either 4 or 6 sectors. The toothbrush might indicate a quadrant/sector change by motor stuttering and/or flashing the LED.
 */
- (void)toothbrush:(OBTBrush *)toothbrush didUpdateSector:(int)sector;

/**
 *  Notifies delegates when the overpressure state of a connected toothbrush has changed
 *
 *  @param toothbrush   The respective toothbrush
 *  @param overpressure YES if too much pressure is applied
 */
- (void)toothbrush:(OBTBrush *)toothbrush didUpdateOverpressure:(BOOL)overpressure;

@end
