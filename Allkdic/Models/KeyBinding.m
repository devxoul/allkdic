//
//  KeyBinding.m
//  Allkdic
//
//  Created by 전수열 on 13. 9. 14..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "KeyBinding.h"

@implementation KeyBinding

+ (KeyBinding *)keyBindingWithKeyCode:(NSInteger)keyCode flags:(NSUInteger)flag
{
	KeyBinding *keyBinding = [[KeyBinding alloc] init];
	keyBinding.keyCode = keyCode;
	for( int i = 0; i < 6; i ++ )
	{
		if( flag & (1 << i) )
		{
			if( i == 0 ) {
				keyBinding.control = YES;
			} else if( i == 1 ) {
				keyBinding.shift = YES;
			} else if( i == 3 ) {
				keyBinding.command = YES;
			} else if( i == 5 ) {
				keyBinding.option = YES;
			}
		}
	}
	
	return keyBinding;
}

+ (KeyBinding *)keyBindingWithDictionary:(NSDictionary *)dictionary
{
	if( !dictionary ) return nil;
	
	KeyBinding *keyBinding = [[KeyBinding alloc] init];
	keyBinding.keyCode = [[dictionary objectForKey:@"keyCode"] integerValue];
	keyBinding.shift = [[dictionary objectForKey:@"shift"] boolValue];
	keyBinding.control = [[dictionary objectForKey:@"control"] boolValue];
	keyBinding.option = [[dictionary objectForKey:@"option"] boolValue];
	keyBinding.command = [[dictionary objectForKey:@"command"] boolValue];
	return keyBinding;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"<KeyBinding keyCode=%ld, control=%@, shift=%@, command=%@, option=%@>",
			self.keyCode,
			self.control ? @"YES" : @"NO",
			self.shift ? @"YES" : @"NO",
			self.command ? @"YES" : @"NO",
			self.option ? @"YES" : @"NO"];
}

- (NSDictionary *)dictionary
{
	return @{@"shift": [NSNumber numberWithBool:self.shift],
			 @"control": [NSNumber numberWithBool:self.control],
			 @"option": [NSNumber numberWithBool:self.option],
			 @"command": [NSNumber numberWithBool:self.command],
			 @"keyCode": [NSNumber numberWithInteger:self.keyCode]};
}

+ (NSString *)keyStringFormKeyCode:(CGKeyCode)keyCode
{
    // Proper key detection seems to want a switch statement, unfortunately
    switch (keyCode)
    {
        case 0: return @"a";
        case 1: return @"s";
        case 2: return @"d";
        case 3: return @"f";
        case 4: return @"h";
        case 5: return @"g";
        case 6: return @"z";
        case 7: return @"x";
        case 8: return @"c";
        case 9: return @"v";
            // what is 10?
        case 11: return @"b";
        case 12: return @"q";
        case 13: return @"w";
        case 14: return @"e";
        case 15: return @"r";
        case 16: return @"y";
        case 17: return @"t";
        case 18: return @"1";
        case 19: return @"2";
        case 20: return @"3";
        case 21: return @"4";
        case 22: return @"6";
        case 23: return @"5";
        case 24: return @"=";
        case 25: return @"9";
        case 26: return @"7";
        case 27: return @"-";
        case 28: return @"8";
        case 29: return @"0";
        case 30: return @"]";
        case 31: return @"o";
        case 32: return @"u";
        case 33: return @"[";
        case 34: return @"i";
        case 35: return @"p";
        case 36: return @"RETURN";
        case 37: return @"l";
        case 38: return @"j";
        case 39: return @"'";
        case 40: return @"k";
        case 41: return @";";
        case 42: return @"\\";
        case 43: return @",";
        case 44: return @"/";
        case 45: return @"n";
        case 46: return @"m";
        case 47: return @".";
        case 48: return @"TAB";
        case 49: return @"SPACE";
        case 50: return @"`";
        case 51: return @"DELETE";
        case 52: return @"ENTER";
        case 53: return @"ESCAPE";
			
            // some more missing codes abound, reserved I presume, but it would
            // have been helpful for Apple to have a document with them all listed
			
        case 65: return @".";
			
        case 67: return @"*";
			
        case 69: return @"+";
			
        case 71: return @"CLEAR";
			
        case 75: return @"/";
        case 76: return @"ENTER";   // numberpad on full kbd
			
        case 78: return @"-";
			
        case 81: return @"=";
        case 82: return @"0";
        case 83: return @"1";
        case 84: return @"2";
        case 85: return @"3";
        case 86: return @"4";
        case 87: return @"5";
        case 88: return @"6";
        case 89: return @"7";
			
        case 91: return @"8";
        case 92: return @"9";
			
        case 96: return @"F5";
        case 97: return @"F6";
        case 98: return @"F7";
        case 99: return @"F3";
        case 100: return @"F8";
        case 101: return @"F9";
			
        case 103: return @"F11";
			
        case 105: return @"F13";
			
        case 107: return @"F14";
			
        case 109: return @"F10";
			
        case 111: return @"F12";
			
        case 113: return @"F15";
        case 114: return @"HELP";
        case 115: return @"HOME";
        case 116: return @"PGUP";
        case 117: return @"DELETE";  // full keyboard right side numberpad
        case 118: return @"F4";
        case 119: return @"END";
        case 120: return @"F2";
        case 121: return @"PGDN";
        case 122: return @"F1";
        case 123: return @"LEFT";
        case 124: return @"RIGHT";
        case 125: return @"DOWN";
        case 126: return @"UP";
			
        default:
			
            return @"Unknown key";
            // Unknown key, bail and note that RUI needs improvement
            //fprintf(stderr, "%ld\tKey\t%c (DEBUG: %d)\n", currenttime, keyCode;
            //exit(EXIT_FAILURE;
    }
}

+ (CGKeyCode)keyCodeFormKeyString:(NSString *)keyString
{
    if ([keyString isEqualToString:@"a"]) return 0;
    if ([keyString isEqualToString:@"s"]) return 1;
    if ([keyString isEqualToString:@"d"]) return 2;
    if ([keyString isEqualToString:@"f"]) return 3;
    if ([keyString isEqualToString:@"h"]) return 4;
    if ([keyString isEqualToString:@"g"]) return 5;
    if ([keyString isEqualToString:@"z"]) return 6;
    if ([keyString isEqualToString:@"x"]) return 7;
    if ([keyString isEqualToString:@"c"]) return 8;
    if ([keyString isEqualToString:@"v"]) return 9;
    // what is 10?
    if ([keyString isEqualToString:@"b"]) return 11;
    if ([keyString isEqualToString:@"q"]) return 12;
    if ([keyString isEqualToString:@"w"]) return 13;
    if ([keyString isEqualToString:@"e"]) return 14;
    if ([keyString isEqualToString:@"r"]) return 15;
    if ([keyString isEqualToString:@"y"]) return 16;
    if ([keyString isEqualToString:@"t"]) return 17;
    if ([keyString isEqualToString:@"1"]) return 18;
    if ([keyString isEqualToString:@"2"]) return 19;
    if ([keyString isEqualToString:@"3"]) return 20;
    if ([keyString isEqualToString:@"4"]) return 21;
    if ([keyString isEqualToString:@"6"]) return 22;
    if ([keyString isEqualToString:@"5"]) return 23;
    if ([keyString isEqualToString:@"="]) return 24;
    if ([keyString isEqualToString:@"9"]) return 25;
    if ([keyString isEqualToString:@"7"]) return 26;
    if ([keyString isEqualToString:@"-"]) return 27;
    if ([keyString isEqualToString:@"8"]) return 28;
    if ([keyString isEqualToString:@"0"]) return 29;
    if ([keyString isEqualToString:@"]"]) return 30;
    if ([keyString isEqualToString:@"o"]) return 31;
    if ([keyString isEqualToString:@"u"]) return 32;
    if ([keyString isEqualToString:@"["]) return 33;
    if ([keyString isEqualToString:@"i"]) return 34;
    if ([keyString isEqualToString:@"p"]) return 35;
    if ([keyString isEqualToString:@"RETURN"]) return 36;
    if ([keyString isEqualToString:@"l"]) return 37;
    if ([keyString isEqualToString:@"j"]) return 38;
    if ([keyString isEqualToString:@"'"]) return 39;
    if ([keyString isEqualToString:@"k"]) return 40;
    if ([keyString isEqualToString:@";"]) return 41;
    if ([keyString isEqualToString:@"\\"]) return 42;
    if ([keyString isEqualToString:@","]) return 43;
    if ([keyString isEqualToString:@"/"]) return 44;
    if ([keyString isEqualToString:@"n"]) return 45;
    if ([keyString isEqualToString:@"m"]) return 46;
    if ([keyString isEqualToString:@"."]) return 47;
    if ([keyString isEqualToString:@"TAB"]) return 48;
    if ([keyString isEqualToString:@"SPACE"]) return 49;
    if ([keyString isEqualToString:@"`"]) return 50;
    if ([keyString isEqualToString:@"DELETE"]) return 51;
    if ([keyString isEqualToString:@"ENTER"]) return 52;
    if ([keyString isEqualToString:@"ESCAPE"]) return 53;
	
    // some more missing codes abound, reserved I presume, but it would
    // have been helpful for Apple to have a document with them all listed
	
    if ([keyString isEqualToString:@"."]) return 65;
	
    if ([keyString isEqualToString:@"*"]) return 67;
	
    if ([keyString isEqualToString:@"+"]) return 69;
	
    if ([keyString isEqualToString:@"CLEAR"]) return 71;
	
    if ([keyString isEqualToString:@"/"]) return 75;
    if ([keyString isEqualToString:@"ENTER"]) return 76;  // numberpad on full kbd
	
    if ([keyString isEqualToString:@"="]) return 78;
	
    if ([keyString isEqualToString:@"="]) return 81;
    if ([keyString isEqualToString:@"0"]) return 82;
    if ([keyString isEqualToString:@"1"]) return 83;
    if ([keyString isEqualToString:@"2"]) return 84;
    if ([keyString isEqualToString:@"3"]) return 85;
    if ([keyString isEqualToString:@"4"]) return 86;
    if ([keyString isEqualToString:@"5"]) return 87;
    if ([keyString isEqualToString:@"6"]) return 88;
    if ([keyString isEqualToString:@"7"]) return 89;
	
    if ([keyString isEqualToString:@"8"]) return 91;
    if ([keyString isEqualToString:@"9"]) return 92;
	
    if ([keyString isEqualToString:@"F5"]) return 96;
    if ([keyString isEqualToString:@"F6"]) return 97;
    if ([keyString isEqualToString:@"F7"]) return 98;
    if ([keyString isEqualToString:@"F3"]) return 99;
    if ([keyString isEqualToString:@"F8"]) return 100;
    if ([keyString isEqualToString:@"F9"]) return 101;
	
    if ([keyString isEqualToString:@"F11"]) return 103;
	
    if ([keyString isEqualToString:@"F13"]) return 105;
	
    if ([keyString isEqualToString:@"F14"]) return 107;
	
    if ([keyString isEqualToString:@"F10"]) return 109;
	
    if ([keyString isEqualToString:@"F12"]) return 111;
	
    if ([keyString isEqualToString:@"F15"]) return 113;
    if ([keyString isEqualToString:@"HELP"]) return 114;
    if ([keyString isEqualToString:@"HOME"]) return 115;
    if ([keyString isEqualToString:@"PGUP"]) return 116;
    if ([keyString isEqualToString:@"DELETE"]) return 117;
    if ([keyString isEqualToString:@"F4"]) return 118;
    if ([keyString isEqualToString:@"END"]) return 119;
    if ([keyString isEqualToString:@"F2"]) return 120;
    if ([keyString isEqualToString:@"PGDN"]) return 121;
    if ([keyString isEqualToString:@"F1"]) return 122;
    if ([keyString isEqualToString:@"LEFT"]) return 123;
    if ([keyString isEqualToString:@"RIGHT"]) return 124;
    if ([keyString isEqualToString:@"DOWN"]) return 125;
    if ([keyString isEqualToString:@"UP"]) return 126;
	
    return 0;
    //fprintf(stderr, "keyString %s Not Found. Aborting...\n", keyString);
    //exit(EXIT_FAILURE);
}

@end
