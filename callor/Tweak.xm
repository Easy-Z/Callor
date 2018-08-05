#import "libcolorpicker.h"

#define prefPath @"/var/mobile/Library/Preferences/com.xezi.callor.color.plist"
#define prefsDict [NSDictionary dictionaryWithContentsOfFile:PLIST_PATH]

static NSString *kButtonColor = nil; //keep note of the "k" that means its a key (for prefs in plist)

static NSMutableDictionary *prefs = nil;


static void loadPrefs()
{
    prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefPath];

    kButtonColor = [prefs objectForKey:@"kButtonColor"];
}

static void receivedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    loadPrefs();
}

%ctor {
CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        receivedNotification,
        CFSTR("com.xezi.callor/color.changed"),
        NULL,
        CFNotificationSuspensionBehaviorCoalesce);
    loadPrefs();
}


@interface PHBottomBarButton
-(void)_setCornerRadius:(CGFloat)arg1;
-(void)setFrame:(CGRect)arg1;
-(void)setBackgroundColor:(id)arg1;
@end

@interface UITabBarButton
@property (nonatomic, retain) UIColor *interactionTintColor;
@end

@interface UITabBarButtonLabel
@property bool hidden;
@end


CGFloat width = [UIScreen mainScreen].bounds.size.width;
CGFloat buttonWidth = width/2;
CGFloat height = [UIScreen mainScreen].bounds.size.height;
CGFloat buttonHeight = height/1.318895506226313;

%hook PHBottomBarButton
-(void)layoutSubviews {
  [self _setCornerRadius:17];
  %orig();
}
-(void)setBackgroundColor:(id)arg1 {
  arg1 = LCPParseColorString(kButtonColor, @"#000000");
  %orig(arg1);
}
%end

%hook PHHandsetDialerNumberPadButton

-(void)layoutSubviews {
  [self setColor:LCPParseColorString(kButtonColor, @"#000000")]; //this here sets the color
}
%end

%hook UIView // that should hide the background of the numberpads
-(void)didMoveToWindow {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(PHHandsetDialerNumberPadButton)];
  CGFloat viewCRadius = [self.layer cornerRadius];
  if(isCorrect) {
    self.hidden = true;
  }
  if(viewCRadius == 36) {
      [self.layer setCornerRadius:17];
  }
  %orig();
}
%end

%hook UIImageView
-(void)layoutSubviews {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(PHHandsetDialerDeleteButton)];
  if(isCorrect) {
    self.alpha = 0;
  }
  %orig;
}
-(void)setHidden:(bool)arg1 {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(PHHandsetDialerDeleteButton)];
  if(isCorrect) {
    arg1 = true;
    %orig(arg1);
  } else {
    %orig;
  }
}

%end


%hook UITabBarButton
-(void)layoutSubviews {
  %orig;
  self.interactionTintColor = LCPParseColorString(kButtonColor, @"#000000");
}
%end

%hook UITabBarButtonLabel
-(void)layoutSubviews {
    %orig;
    self.hidden = true;
}
%end
