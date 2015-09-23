#define ZYSingleTonH \
+ (instancetype)sharedInstance;
#if __has_feature (objc_arc)
#define ZYSingleTonM \
static id _instance;\
+ (instancetype)sharedInstance\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\
\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
- copyWithZone:(NSZone *)zone\
{\
return _instance;\
}
#else
#define ZYSingleTonM \
static id _instance;\
+ (instancetype)sharedInstance\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\
\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
- copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(oneway void)release {\
}\
- (id)autorelease{return self;}\
- (id)retain{\
return self;}\
- (NSUInteger)retainCount {return 1;}
#endif
