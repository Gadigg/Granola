//
//  ORKSample.m
//  Pods
//
//  Created by Anders Borch on 4/25/17.
//
//

#import "ORKSample.h"

@interface ORKSample()

@property (strong) NSDate *startDate;
@property (strong) NSDate *endDate;
@property (strong) NSUUID *UUID;

- (instancetype)init;

@end

@implementation ORKSample

@synthesize startDate;
@synthesize endDate;
@synthesize UUID;

- (instancetype)init
{
    self.UUID = [NSUUID UUID];
    return self;
}

+ (instancetype)sampleWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    ORKSample *sample = [[ORKSample alloc] init];
    sample.startDate = startDate;
    sample.endDate = endDate;
    return sample;
}

@end
