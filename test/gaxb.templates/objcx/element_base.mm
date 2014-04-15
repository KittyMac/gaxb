<%
-- Copyright (c) 2012 Small Planet Digital, LLC
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files 
-- (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, 
-- publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
-- subject to the following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
-- WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 %>
<%
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_"..string.upper(this.name).."BASE".."_";
CAP_NAME = capitalizedString(this.name);
FULL_NAME_CAMEL = capitalizedString(this.namespace).."_"..capitalizedString(this.name).."Base";
%>//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//

#import "<%= FULL_NAME_CAMEL %>.h"
#import "<%= capitalizedString(this.namespace) %>_XMLLoader.h"
<% -- check for ENUMs defined in other namespaces and load their XMLLoaders as needed
local namespaces = {};
for k,v in pairs(this.attributes) do
	if (isEnumForItem(v) and v.type.namespace ~= nil and v.type.namespace ~= this.namespace and namespaces[v.type.namespace] == nil) then
		namespaces[v.type.namespace] = true;
		gaxb_print("#import \""..v.type.namespace.."_XMLLoader.h\"\n");
	end
end
%>

@interface NSData (NSDataAdditions)

+ (NSString *) encode:(NSData *) rawBytes;
+ (NSString *) encode:(const uint8_t *) input length:(NSInteger) length;
+ (NSData *) decode:(const char *) string length:(NSInteger) inputLength;
+ (NSData *) decode:(NSString *) string;

@end

@implementation <%= FULL_NAME_CAMEL %>
<% if (hasSuperclass(this) == false) then %>
@synthesize parent;
@synthesize uid;

- (id) gaxb_init { return self; }
- (void) gaxb_dealloc {  }
- (void) gaxb_loadDidComplete {  }
- (void) gaxb_valueWillChange: (NSString *)_name {  }
- (void) gaxb_valueDidChange: (NSString *)_name {  }
<% end %>
- (id) init 
{
	if ((self = [super init])) 
	{
		if (!gaxb_init_called)
		{
			gaxb_init_called=YES;
			[self gaxb_init];
		}
		<%
		for k,v in pairs(this.sequences) do
			if (v.name == "any") then %>	
		anys = [[NSMutableArray array] retain];<%
			elseif(isPlural(v)) then %>
		<%= pluralName(v.name) %> = [[NSMutableArray array] retain];<%	
			end	
		end 
		for k,v in pairs(this.attributes) do
			if (v.default ~= nil) then %>
		[self set<%= capitalizedString(v.name) %>WithString: @"<%= v.default %>"]; <%
			end
		end
%>
	}
	
	return self;
}

- (void) dealloc 
{
	[uid release], uid = nil;
	
	if (!gaxb_dealloc_called)
	{
		gaxb_dealloc_called = YES;
		[self gaxb_dealloc];
	}
	
<%
	for k,v in pairs(this.attributes) do
		if (isObject(v)) then
			gaxb_print("\t["..v.name.." release], "..v.name.." = nil;\n")
		end
	end
	for k,v in pairs(this.sequences) do
		if (v.name == "any") then
			gaxb_print("\t[anys release], anys=nil;\n")
		elseif(isPlural(v)) then
			gaxb_print("\t["..pluralName(v.name).." release], "..pluralName(v.name).."=nil;\n")
		else
			gaxb_print("\t["..v.name.." release], "..v.name.."=nil;\n")
		end
	end
%>
	[super dealloc];
}

- (NSArray *) validAttributes
{
	static NSArray *validAttributes;
		validAttributes = [[NSArray alloc] initWithObjects:
<%

	for k,v in pairs(this.attributes) do
		--printAllKeys(v)
		gaxb_print("\t\t\t[NSDictionary dictionaryWithObject:@\""..simpleTypeForItem(v).."\" forKey:@\""..v.name.."\"],\n")
	end
	if (this.mixedContent) then
		gaxb_print("\t\t\t[NSDictionary dictionaryWithObject:@\"string\" forKey:@\"MixedContent\"],\n");
	end
	for k,v in pairs(this.sequences) do
		if (v.name == "any") then
			gaxb_print("\t\t\t[NSDictionary dictionaryWithObject:@\"any[]\" forKey:@\"anys\"],\n")
		elseif(isPlural(v)) then
			gaxb_print("\t\t\t[NSDictionary dictionaryWithObject:@\""..simpleTypeForItem(v).."[]\" forKey:@\""..pluralName(v.name).."\"],\n")
		else
	 		gaxb_print("\t\t\t[NSDictionary dictionaryWithObject:@\""..simpleTypeForItem(v).."\" forKey:@\""..v.name.."\"],\n")
		end
	end
%>			nil];
	
	return validAttributes;
}

- (void) setValue:(id)_value forKey:(NSString *)_key 
{ 
 	if([_value isKindOfClass:[NSString class]]) 
	{ 
    	SEL selector = NSSelectorFromString([NSString stringWithFormat:@"set%@WithString:", [[[_key capitalizedString] substringToIndex:1] stringByAppendingString:[_key substringFromIndex:1]]]);
    	if([self respondsToSelector:selector]) 
		{ 
			[self performSelector:selector withObject:_value]; 
			return;
		}
  	} 

	[super setValue:_value forKey:_key];
}

- (void) setValue:(id)value forUndefinedKey:(NSString *)key { }

<%
	for k,v in pairs(this.attributes) do
		local capName = capitalizedString(v.name);
%>
@synthesize <%= v.name %>;
@synthesize <%= v.name %>Exists;<%
if (isObject(v)) then  %>
- (void) set<%= capName %>:(<% if (v.type == "string") then gaxb_print("NSString *") else gaxb_print(typeForItem(v)) end %>)v 
{ 
	id _t = <%= v.name %>; 
	<%= v.name %>Exists=YES; <%
	if  (v.type == "string") then %>
	if ([v isKindOfClass:[NSString class]] == NO) 
	{ 
		v = [v description]; 
	} <%
	end %>
	[self gaxb_valueWillChange:@"<%= v.name %>"]; 
	[self willChangeValueForKey:@"<%= v.name %>AsString"]; 
	<%= v.name %> = [v retain]; 
	[_t release]; 
	[self didChangeValueForKey:@"<%= v.name %>AsString"]; 
	[self gaxb_valueDidChange:@"<%= v.name %>"]; 
}<%
else %>
- (void) set<%= capName %>:(<%= typeForItem(v) %>)v 
{ 
	<%= v.name %>Exists=YES; 
	[self gaxb_valueWillChange:@"<%= v.name %>"]; 
	[self willChangeValueForKey:@"<%= v.name %>AsString"]; 
	<%= v.name %> = v; 
	[self didChangeValueForKey:@"<%= v.name %>AsString"]; 
	[self gaxb_valueDidChange:@"<%= v.name %>"]; 
}<%
end %>	
- (NSString *) <%= v.name %>AsString {<%
if (TYPEMAP[v.type]=="BOOL") then
	%> return ((<%= v.name %>Exists) ? (<%= v.name %> ? @"true" : @"false") : nil); <%
elseif (TYPEMAP[v.type]=="float") then 
	%> return ((<%= v.name %>Exists) ? [[NSNumber numberWithFloat:<%= v.name %>] stringValue] : nil); <%
elseif (TYPEMAP[v.type]=="short") then 
	%> return ((<%= v.name %>Exists) ? [[NSNumber numberWithShort:<%= v.name %>] stringValue] : nil); <%
elseif (TYPEMAP[v.type]=="int" or isEnumForItem(v)) then
	%> return ((<%= v.name %>Exists) ? [[NSNumber numberWithInt:<%= v.name %>] stringValue] : nil); <%
elseif (TYPEMAP[v.type]=="long") then
	%> return ((<%= v.name %>Exists) ? [[NSNumber numberWithLong:<%= v.name %>] stringValue] : nil); <%
elseif (TYPEMAP[v.type]=="double") then
	%> return ((<%= v.name %>Exists) ? [[NSNumber numberWithDouble:<%= v.name %>] stringValue] : nil); <%
elseif (TYPEMAP[v.type]=="char") then 
	%> return ((<%= v.name %>Exists) ? [[NSNumber numberWithChar:<%= v.name %>] stringValue] : nil); <%
elseif (TYPEMAP[v.type]=="date") then 
	%> return [self dateStringFromSchema:<%= v.name %>]; <%
elseif (TYPEMAP[v.type]=="dateTime") then
	%> return [self dateTimeStringFromSchema:<%= v.name %>]; <%
elseif (TYPEMAP[v.type]=="base64Binary") then
	%> return [<%= v.name %> base64Encoding]; <%
else
	%> return [<%= v.name %> description]; <%
end %>}
- (void) set<%= capName %>WithString:(NSString *)string 
{ 	
	<%= v.name %>Exists=YES; <%	
if (TYPEMAP[v.type]=="BOOL") then %>
	[self set<%= capName %>:([string isEqualToString:@"true"] ? YES : NO)];
<% elseif (TYPEMAP[v.type]=="float") then %>
	[self set<%= capName %>:[string floatValue]];
<% elseif (TYPEMAP[v.type]=="short") then %>
	[self set<%= capName %>:[string shortValue]];
<% elseif (TYPEMAP[v.type]=="int") then %>
	[self set<%= capName %>:[string intValue]];
<% elseif (TYPEMAP[v.type]=="long") then %>
	[self set<%= capName %>:[string longValue]];
<% elseif (TYPEMAP[v.type]=="double") then %>
	[self set<%= capName %>:[string doubleValue]];
<% elseif (TYPEMAP[v.type]=="char") then %>
	[self set<%= capName %>:[string intValue];
<% elseif (v.type=="date") then %>
	[self set<%= capName %>:[self schemaDateFromString:string]]; 
<% elseif (v.type=="dateTime") then %>
	[self set<%= capName %>:[self schemaDateTimeFromString:string]]; 
<% elseif (v.type=="base64Binary") then %>
	[self set<%= capName %>:[NSData decode:string]]; 
<% elseif (v.type=="string") then %>
	[self set<%= capName %>:string]; 
<% elseif (isEnumForItem(v)) then %>
	[self set<%= capName %>:(<%= v.type.name %>)([[string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]] length] == 0 ? 
		[string intValue] : [[<%= capitalizedString(v.type.namespace).."_XMLLoader arrayForEnum"..capitalizedString(v.type.name) %>] indexOfObject:string])];
<% elseif (isObject(v)) then %>
	[self set<%= capName %>:[[[NSClassFromString(@"<%= typeNameForItem(v) %>") alloc] initWithString:string] autorelease]]; 
<% else %>
	// bleh 
<% end 
%>}

<%
	end
	if (this.mixedContent) then %>
@synthesize MixedContent;
@synthesize MixedContentExists;
-(void) setMixedContent:(NSString *)v 
{ 
    id _t = MixedContent; 
    MixedContentExists=YES; 
    if([v isKindOfClass:[NSString class]] == NO) 
    { 
        v = [v description]; 
    } 
    [self gaxb_valueWillChange:@"MixedContent"]; 
    [self willChangeValueForKey:@"MixedContentAsString"]; 
    MixedContent = [v retain]; 
    [_t release]; 
    [self didChangeValueForKey:@"MixedContentAsString"]; 
    [self gaxb_valueDidChange:@"MixedContent"]; 
};
- (NSString *) MixedContentAsString { return [MixedContent description]; }
- (void) setMixedContentWithString:(NSString *)string 
{ 
	MixedContentExists=YES; 
	[self setMixedContent:[[[NSClassFromString(@"NSString") alloc] initWithString:string] autorelease]]; 
}
<%
	end
	for k,v in pairs(this.sequences) do
		if (v.name == "any") then
%>@synthesize anys;
- (void) appendAnyWithString:(NSString *)string 
{ 
	// does this make sense?
	[anys addObject:[[[NSClassFromString(@"any") alloc] initWithString:string] autorelease]]; 
}
<%		elseif(isPlural(v)) then %>
@synthesize <%= pluralName(v.name) %>;<%
		else %>
@synthesize <%= v.name %>;
@synthesize <%= v.name %>Exists;<%
			if (isObject(v)) then %>
- (void) set<%= capitalizedString(v.name) %>:(<% typeForItem(v) %>)v 
{ 
	id _t = <%= v.name %>; 
	<%= v.name %>Exists=YES; 
	[self gaxb_valueWillChange:@"<%= v.name %>"]; 
	[self willChangeValueForKey:@"<%= v.name %>AsString"]; 
	<%= v.name %> = [v retain];
	[_t release]; 
	[self didChangeValueForKey:@"<%= v.name %>AsString"]; 
	[self gaxb_valueDidChange:@"<%= v.name %>"]; 
};
<%			end
		end
	end
%>	


- (void) appendXMLAttributesForSubclass:(NSMutableString *)xml
{
<% if (hasSuperclass(this)) then %>	[super appendXMLAttributesForSubclass:xml];
<% end
for k,v in pairs(this.attributes) do
	if (v.type == "boolean") then 
%>	if (<%= v.name %>Exists || <%= v.name %> ) { [xml appendFormat:@" <%= v.name %>='%@'", SAFESTRING(((<%= v.name %>Exists || <%= v.name %> ) ? (<%= v.name %> ? @"true" : @"false") : NULL))]; }
<% elseif (TYPEMAP[v.type]=="short") then %>
	if (<%= v.name %>Exists || <%= v.name %> ) { [xml appendFormat:@" <%= v.name %>='%hi'", <%= v.name %>]; }
<% elseif (TYPEMAP[v.type]=="int" or isEnumForItem(v)) then %>
	if (<%= v.name %>Exists || <%= v.name %> ) { [xml appendFormat:@" <%= v.name %>='%i'", <%= v.name %>]; }
<% elseif (TYPEMAP[v.type]=="long") then %>
	if (<%= v.name %>Exists || <%= v.name %> ) { [xml appendFormat:@" <%= v.name %>='%ld'", <%= v.name %>]; }
<% elseif (TYPEMAP[v.type]=="char") then %>
	if (<%= v.name %>Exists || <%= v.name %> ) { [xml appendFormat:@" <%= v.name %>='%i'", <%= v.name %>]; }
<% elseif (TYPEMAP[v.type]=="float" or TYPEMAP[v.type]=="double") then %>
	if (<%= v.name %>Exists || <%= v.name %> ) 
	{ 
		NSString *s = [[NSString stringWithFormat:@"%0.2f", <%= v.name %>] stringByReplacingOccurrencesOfString:@".00" withString:@""]; 
		[xml appendFormat:@" <%= v.name %>='%@'", s]; 
	}
<% elseif (v.type=="date") then %>
	if (<%= v.name %>Exists || <%= v.name %> ) [xml appendFormat:@" <%= v.name %>='%@'", [self dateStringFromSchema:<%= v.name %>]]; 
<% elseif (v.type=="dateTime") then %>
	if (<%= v.name %>Exists | <%= v.name %> ) [xml appendFormat:@" <%= v.name %>='%@'", [self dateTimeStringFromSchema:<%= v.name %>]]; 
<% elseif (v.type=="base64Binary") then %>
	if (<%= v.name %>Exists | <%= v.name %> ) [xml appendFormat:@" <%= v.name %>='%@'", [<%= v.name %> base64Encoding]]; 
<% elseif (v.type=="string") then %>
	if (<%= v.name %>) [xml appendFormat:@" <%= v.name %>='%@'", SAFESTRING(<%= v.name %>)]; 
<% 	else %>	if (<%= v.name %>) { [xml appendFormat:@" <%= v.name %>='%@'", SAFESTRING([<%= v.name %> description])]; }
<%	end
end
%>}

- (void) appendXMLElementsForSubclass:(NSMutableString *)xml
{
<% if (hasSuperclass(this)) then %>	[super appendXMLElementsForSubclass:xml];
<% end
for k,v in pairs(this.sequences) do
-- print(table.tostring(v))
	if (v.name == "any") then 
%>
	FAST_ENUMERATION(x,anys) { [x appendXML:xml]; } 
<%	elseif (v.ref ~= nil) then 
		if (isPlural(v)) then
%>	FAST_ENUMERATION(x,<%= pluralName(v.name) %>) { [x appendXML:xml]; } 
<% 		else
%>	[<%= v.name %> appendXML:xml];<%
	  	end
	elseif (isPlural(v)) then 
%>	FAST_ENUMERATION(x,<%= pluralName(v.name) %>) { [xml appendFormat:@"<<%= v.name%>>%@</<%= v.name %>>", SAFESTRING(x)]; } 
<%	else 
%>	if (<%= v.name %> && [<%= v.name %> isEqualToString:@"(null)"] == NO) { [xml appendFormat:@"<<%= v.name %>>%@</<%= v.name %>>", SAFESTRING(<%= v.name %>)]; }<%
	end
end	 
%>}

- (void) appendXML:(NSMutableString *)xml
{
	[xml appendFormat:@"<<%= CAP_NAME %>"];
	if ([parent performSelector:@selector(xmlns)] != @"<%= this.namespaceURL %>") 
	{ 
		[xml appendFormat:@" xmlns='<%= this.namespaceURL %>'"]; 
	} 
	[self appendXMLAttributesForSubclass:xml];
	NSMutableString * elems = [NSMutableString string];
	[self appendXMLElementsForSubclass:elems];
	if([elems length])
	{
		[xml appendFormat:@">"];
		[xml appendFormat:@"%@</<%= CAP_NAME %>>", elems];
	}
	else
	{
		[xml appendFormat:@"/>"];
	}
}

- (NSString *) xmlns
{
	return @"<%= this.namespaceURL %>";
}

- (NSString *) translateToXMLSafeString:(NSString *)__value
{
	NSMutableString * string = [NSMutableString stringWithString:[__value description]];
	[string replaceOccurrencesOfString:@\"&\" withString:@\"&amp;\" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
	[string replaceOccurrencesOfString:@\"<\" withString:@\"&lt;\" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
	[string replaceOccurrencesOfString:@\">\" withString:@\"&gt;\" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
	[string replaceOccurrencesOfString:@\"\\"\" withString:@\"&quot;\" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
	[string replaceOccurrencesOfString:@\"'\" withString:@\"&apos;\" options:NSLiteralSearch range:NSMakeRange(0, [string length])];
	return string;
}

- (NSString *) description 
{ 
	NSMutableString * s = [NSMutableString string]; 
	[self appendXMLAttributesForSubclass:s]; 
	return [NSString stringWithFormat:@"<<%= CAP_NAME %>%@ />", s]; 
}

- (NSDate *) dateFromString:(NSString *)date_string
				 WithFormat:(NSString *)date_format
{
	struct tm timeStruct;
	strptime((const char *)[date_string UTF8String], (const char *)[date_format UTF8String], &timeStruct);
	
	NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
	[components setSecond:timeStruct.tm_sec];
	[components setMinute:timeStruct.tm_min];
	[components setHour:timeStruct.tm_hour];
	[components setDay:timeStruct.tm_mday];
	[components setMonth:timeStruct.tm_mon];
	[components setYear:timeStruct.tm_year];
	[components setWeekday:timeStruct.tm_wday];	
	
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	return [gregorian dateFromComponents:components];
}

- (NSDate *) schemaDateTimeFromString:(NSString *)date_string
{ 
	return [self dateFromString:date_string WithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSDate *) schemaDateFromString:(NSString *)date_string
{
	return [self dateFromString:date_string WithFormat:@"yyyy-MM-dd"];
}

- (NSString *) dateTimeStringFromSchema:(NSDate *)_date
{
	NSDateFormatter * date_format = [[[NSDateFormatter alloc] init] autorelease]; 
	[date_format setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
	return [date_format stringFromDate:_date]; 
}

- (NSString *) dateStringFromSchema:(NSDate *)_date
{ 
	NSDateFormatter * date_format = [[[NSDateFormatter alloc] init] autorelease]; 
	[date_format setDateFormat:@"yyyy-MM-dd"]; 
	return [date_format stringFromDate:_date]; 
}

@end