<%
FULL_NAME_CAPS = "_"..string.upper(this.namespace).."_"..string.upper(this.name).."_";
CAP_NAME = capitalizedString(this.name);
FULL_NAME_CAMEL = capitalizedString(this.namespace).."_"..capitalizedString(this.name);
%>//
// Autogenerated by gaxb at <%= os.date("%I:%M:%S %p on %x") %>
//

#import "<%= FULL_NAME_CAMEL %>.h"

@implementation <%= FULL_NAME_CAMEL %>

@end
