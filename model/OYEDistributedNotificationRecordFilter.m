/*
 Copyright (c) 2019, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "OYEDistributedNotificationRecordFilter.h"

@interface OYEDistributedNotificationRecordFilter ()
{
}

@property (readwrite) NSString * identifier;

@end

@implementation OYEDistributedNotificationRecordFilter

- (instancetype)init
{
	self=[super init];
	
	if (self!=nil)
	{
		_identifier=@"";
		
		_enabled=YES;
		
		_label=@"";
		
		_action=OYEFilterActionFilterOut;
	}
	
	return self;
}

#pragma mark - DISRepresentable

- (instancetype)initWithRepresentation:(NSDictionary *)inRepresentation
{
	if (inRepresentation==nil || [inRepresentation isKindOfClass:[NSDictionary class]]==NO)
		return nil;
	
	self=[super init];
	
	if (self!=nil)
	{
		NSString * tString=inRepresentation[@"identifier"];
		
		if (tString==nil || [tString isKindOfClass:[NSString class]]==NO)
			return nil;
		
		_identifier=[tString copy];
		
		NSNumber * tNumber=inRepresentation[@"state"];
		
		if (tNumber==nil || [tNumber isKindOfClass:[NSNumber class]]==NO)
			return nil;
		
		_enabled=[tNumber boolValue];
		
		tString=inRepresentation[@"label"];
		
		if (tString==nil || [tString isKindOfClass:[NSString class]]==NO)
			return nil;
		
		_label=[tString copy];
		
		tNumber=inRepresentation[@"action"];
		
		if (tNumber==nil || [tNumber isKindOfClass:[NSNumber class]]==NO)
			return nil;
		
		_action=[tNumber unsignedIntegerValue];
		
		tNumber=inRepresentation[@"highlightColorIndex"];
		
		if (tNumber==nil || [tNumber isKindOfClass:[NSNumber class]]==NO)
			return nil;
		
		_highlightColorIndex=[tNumber unsignedIntegerValue];
	}
	
	return self;
}

- (NSDictionary *)representation
{
	return @{@"class":NSStringFromClass([self class]),
			 @"identifier":self.identifier,
			 @"state":@(self.isEnabled),
			 @"label":self.label,
			 @"action":@(self.action),
			 @"highlightColorIndex":@(self.highlightColorIndex),
			 };
}

#pragma mark -

- (BOOL)matchesDistributedNotificationRecord:(OYEDistributedNotificationRecord *)inDistributedNotificationRecord
{
	return NO;
}

@end
