//
//  UIFocusUpdateContext+Neutered.m
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-05-05.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

@import ObjectiveC;

#import "UIFocusUpdateContext+Neutered.h"

//
// We need to create an instance of `UIFocusUpdateContext` in order to fully
// test `FocusMonitor`. We can easily create such an instance using
// `UIFocusUpdateContext()` on tvOS. For whatever reason, iOS throws an
// exception for that case. So we are forced to rely on this ugly hack in
// Objective-C (apparently one of the few cases where Swift falls short) to
// create the instance.
//
@implementation UIFocusUpdateContext (Neutered)

+ (UIFocusUpdateContext *) make {
    return [[UIFocusUpdateContext alloc] initNeutered];
}

- (instancetype) initNeutered {
    return [super init];    // skip the naughty bits; just initialize super
}

@end
