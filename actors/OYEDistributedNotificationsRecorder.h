/*
 Copyright (c) 2019, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>

#import "OYEDistributedNotificationRecord.h"

#import "OYEDistributedNotificationRecordSession.h"


@class OYEDistributedNotificationsRecorder;

@protocol OYEDistributedNotificationsRecorderDelegate <NSObject>

- (void)distributedNotificationsRecorder:(OYEDistributedNotificationsRecorder *)inDistributedNotificationsRecorder didRecordNewDistributedNotification:(OYEDistributedNotificationRecord *)inDistributedNotificationRecord;

@end


typedef OYEDistributedNotificationRecordSession * (^OYESessionAllocator)();

@interface OYEDistributedNotificationsRecorder : NSObject

	@property (readonly) OYEDistributedNotificationRecordSession * recordSession;

	@property (readonly,getter=isRecording) BOOL recording;
	@property (readonly,getter=isPaused) BOOL paused;

	@property (weak) id<OYEDistributedNotificationsRecorderDelegate> delegate;

- (instancetype)initWithSessionAllocator:(OYESessionAllocator)inAllocator;

- (void)start;

- (void)pause;
- (void)resume;

- (void)stop;

@end
