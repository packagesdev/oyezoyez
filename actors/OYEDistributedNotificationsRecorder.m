/*
 Copyright (c) 2019, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OYEDistributedNotificationsRecorder.h"

#import "OYEDistributedNotificationObserver.h"

@interface OYEDistributedNotificationsRecorder () <OYEDistributedNotificationObserverDelegate>
{
	OYESessionAllocator _sessionAllocator;
	
	OYEDistributedNotificationObserver * _observer;
}

@property (readwrite) OYEDistributedNotificationRecordSession * recordSession;

@property (readwrite,getter=isRecording) BOOL recording;

@property (readwrite,getter=isPaused) BOOL paused;



@end

@implementation OYEDistributedNotificationsRecorder

- (instancetype)init
{
	self=[super init];
	
	if (self!=nil)
	{
		_sessionAllocator=^OYEDistributedNotificationRecordSession *() {
		
			return [OYEDistributedNotificationRecordSession new];
		};
	}
	
	return self;
}

- (instancetype)initWithSessionAllocator:(OYESessionAllocator)inAllocator
{
	self=[super init];
	
	if (inAllocator==nil)
		return self;
	
	if (self!=nil)
	{
		_sessionAllocator=inAllocator;
	}
	
	return self;
}

#pragma mark -

- (void)start
{
	_observer=[OYEDistributedNotificationObserver new];
	_observer.delegate=self;
	
	_recordSession=_sessionAllocator();
	
	_recording=YES;
	_paused=NO;
	
	[_observer start];
}

- (void)pause
{
	[_observer stop];
	
	_paused=YES;
}

- (void)resume
{
	[_observer start];
	
	_paused=NO;
}

- (void)stop
{
	[_observer stop];
	_observer=nil;
	
	_recording=NO;
	_paused=NO;
}

#pragma mark -

- (void)distributedNotificationObserver:(OYEDistributedNotificationObserver *)inWatcher didObserveNotification:(NSNotification *)inNotification
{
	OYEDistributedNotificationRecord * tDistributedNotificationRecord=[[OYEDistributedNotificationRecord alloc] initWithDistributedNotification:[[OYEDistributedNotification alloc] initWithNotification:inNotification]];
	
	[_recordSession appendRecord:tDistributedNotificationRecord];
	
	if ([self.delegate conformsToProtocol:@protocol(OYEDistributedNotificationsRecorderDelegate)]==YES)
		[self.delegate distributedNotificationsRecorder:self didRecordNewDistributedNotification:tDistributedNotificationRecord];
}

@end
