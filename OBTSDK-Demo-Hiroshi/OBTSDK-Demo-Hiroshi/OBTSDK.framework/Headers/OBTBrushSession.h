//
//  OBTBrushSession.h
//  OBTSDK
//
//  Created by Christian Weinberger on 30/06/14.
//  Copyright (c) 2014 iconmobile GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OBTSDK/OBTBrush.h>

/** This class represents a single brush session of a user.
 */
@interface OBTBrushSession : NSObject

/**
 *  A unique identifier associated with a brush session. (read-only)
 */
@property (nonatomic, readonly)         long long       brushSessionID;

/**
 *  Represents the start date of the brush session. (read-only)
 */
@property (nonatomic, strong, readonly) NSDate          *brushDate;

/**
 *  Represents the total brushing duration of the brush session. (read-only)
 */
@property (nonatomic, readonly)         NSTimeInterval  brushingDuration;

/**
 *  Represents the total pressure duration of the brush session. (read-only)
 */
@property (nonatomic, readonly)         NSTimeInterval  totalPressureDuration;

/**
 *  Represents the number of overpressure events over the course of the brush session. (read-only)
 */
@property (nonatomic, readonly)         NSUInteger      numberOfPressureEvents;

/**
 *  Represents the number of start events over the course of the session. This includes resuming a session after a pausing. (read-only)
 */
@property (nonatomic, readonly)         NSUInteger      numberOfStartEvents;

/**
 *  Represents the brush mode that was used the most over the course of the session. (read-only)
 */
@property (nonatomic, readonly)         OBTBrushMode    preferredBrushMode;

/**
 *  Represents the battery level during the current brushing session (0.0 to 1.0). (read-only)
 */
@property (nonatomic, readonly)         float           batteryLevel;


@end
