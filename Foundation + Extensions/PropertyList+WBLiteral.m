/*
 Copyright (c) 2019, Stephane Sudre
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 
 - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 - Neither the name of the WhiteBox nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "PropertyList+WBLiteral.h"

@interface NSString (WB_Literal) <WBLiteral>

@end

@implementation NSString (WB_Literal)

- (NSString *)WB_literal
{
	return [NSString stringWithFormat:@"@\"%@\"",self];
}

@end

@interface NSNumber (WB_Literal) <WBLiteral>

@end

@implementation NSNumber (WB_Literal)

- (NSString *)WB_literal
{
	if (self==@(YES) || self==@(NO))
	{
		return [NSString stringWithFormat:@"@(%@)",(self.boolValue==YES) ? @"YES" : @"NO"];
	}
	
	return [NSString stringWithFormat:@"@(%@)",self.stringValue];
}

@end

@interface NSDate (WB_Literal) <WBLiteral>

@end

@implementation NSDate (WB_Literal)

- (NSString *)WB_literal
{
	return [NSString stringWithFormat:@"[NSDate dateWithString:@\"%@\"]",[self descriptionWithLocale:nil]];
}

@end

@interface NSData (WB_Literal) <WBLiteral>

@end

@implementation NSData (WB_Literal)

- (NSString *)WB_literal
{
	NSUInteger tLength=self.length;
	
	if (tLength==0)
		return @"[NSData data]";
	
	NSMutableString * tDataAsHexaString=[NSMutableString string];
	
	const char * tBytes=self.bytes;
	
	for(NSUInteger tIndex=0;tIndex<tLength;tIndex++)
	{
		[tDataAsHexaString appendFormat:@"0x%02x,",tBytes[tIndex]];
	}
	
	[tDataAsHexaString deleteCharactersInRange:NSMakeRange(tDataAsHexaString.length-2, 1)];
	
	return [NSString stringWithFormat:@"[NSData dataWithBytes:{%@} length:%lu",tDataAsHexaString,tLength];
}

@end



@implementation NSDictionary (WB_Literal)

- (NSString *)WB_literal
{
	__block NSMutableString * tMutableString=[NSMutableString stringWithString:@"@{\n"];
	
	[self enumerateKeysAndObjectsUsingBlock:^(NSString * bKey, id<WBLiteral> bObject, BOOL *bOutStop) {
		
		if ([bObject respondsToSelector:@selector(WB_literal)]==NO)
		{
			tMutableString=nil;
			*bOutStop=YES;
			return;
		}
		
		[tMutableString appendFormat:@"%@:%@,\n",[bKey WB_literal],[bObject WB_literal]];
	}];
	
	[tMutableString deleteCharactersInRange:NSMakeRange(tMutableString.length-2, 1)];
	
	[tMutableString appendString:@"}"];
	
	return tMutableString;
}

@end

@implementation NSArray (WB_Literal)

- (NSString *)WB_literal
{
	__block NSMutableString * tMutableString=[NSMutableString stringWithString:@"@[\n"];
	
	[self enumerateObjectsUsingBlock:^(id bObject, NSUInteger idx, BOOL *bOutStop) {
		
		if ([bObject respondsToSelector:@selector(WB_literal)]==NO)
		{
			tMutableString=nil;
			*bOutStop=YES;
			return;
		}
		
		[tMutableString appendFormat:@"%@,\n",[bObject WB_literal]];
	}];
	
	[tMutableString deleteCharactersInRange:NSMakeRange(tMutableString.length-2, 1)];
	
	[tMutableString appendString:@"]"];
	
	return tMutableString;
}

@end