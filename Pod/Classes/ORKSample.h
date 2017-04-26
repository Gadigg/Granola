//
//  ORKSample.h
//  Pods
//
//  Created by Anders Borch on 4/25/17.
//
//

#import <HealthKit/HealthKit.h>

@interface ORKSample: HKSample

+ (instancetype)sampleWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
