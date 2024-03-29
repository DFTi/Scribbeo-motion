### Fork Note
This is a fork I use for inclusion in my rubymotion projects with git submodule:
```bash
git submodule add git@github.com:keyvanfatehi/Base64 vendor/Base64
```
And then add it to the project like so
```ruby
Motion::Project::App.setup do |app|
  ...
  app.vendor_project 'vendor/Base64', :static
  ...
end
```
--------

Purpose
--------------

Base64 is a set of categories that provide methods to encode and decode data as a base-64-encoded string.


Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 5.1 / Mac OS 10.7 (Xcode 4.3, Apple LLVM compiler 3.0)
* Earliest supported deployment target - iOS 4.3 / Mac OS 10.6
* Earliest compatible deployment target - iOS 3.0 / Mac OS 10.6

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

Base64 can automatically detect if your project is using ARC or not, and output the correct code using conditional compilation. It will therefore work correctly in either ARC or non-ARC projects without modification.


Thread Safety
--------------

All the Base64 methods should be safe to call from multiple threads concurrently.


Installation
--------------

To use the Base64 category in an app, just drag the category files (demo files and assets are not needed) into your project and import the header file into any class where you wish to make use of the Base64 functionality.


NSData Extensions
----------------------

Base64 extends NSData with the following methods:

    + (NSData *)dataWithBase64EncodedString:(NSString *)string;
    
Takes a base-64-encoded string and returns an autoreleased NSData object containing the decoded data. Any non-base-64 characters in the string are ignored, so it is safe to pass a string containing line breaks or other delimiters.

    - (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
    
Encodes the data as a base-64-encoded string and returns it. The wrapWidth argument allows you to specify the number of characters at which the output should wrap onto a new line. The value of wrapWidth must be a multiple of four. Values that are not a multiple of four will be truncated to the nearest multiple. A value of zero indicates that the data should not wrap.
    
    - (NSString *)base64EncodedString;
    
Encodes the data as a base-64-encoded string without any wrapping (line breaks).


NSString Extensions
----------------------

Base64 extends NSString with the following methods:

    + (NSString *)stringWithBase64EncodedString:(NSString *)string;
    
Takes a base-64-encoded string and returns an autoreleased NSString object containing the decoded data, interpreted using UTF8 encoding. The vast majority of use cases for Base64 encoding use Ascii or UTF8 strings, so this should be sufficient for most purposes. If you do need to decode string data in an encoding other than UTF8, convert your string to an NSData object first and then use the NSData dataWithBase64EncodedString: method instead.

    - (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
    
Converts the string data to UTF8 data and then encodes the data as a base-64-encoded string and returns it. The wrapWidth argument allows you to specify the number of characters at which the output should wrap onto a new line. The value of wrapWidth must be a multiple of four. Values that are not a multiple of four will be truncated to the nearest multiple. A value of zero indicates that the data should not wrap.
    
    - (NSString *)base64EncodedString;
    
Encodes the string as UTF8 data and then encodes that as a base-64-encoded string without any wrapping (line breaks).

    - (NSString *)base64DecodedString;
    
Treats the string as a base-64-encoded string and returns an autoreleased NSString object containing the decoded data, interpreted using UTF8 encoding. Any non-base-64 characters in the string are ignored, so it is safe to use a string containing line breaks or other delimiters.

    - (NSData *)base64DecodedData;

Treats the string as base-64-encoded data and returns an autoreleased NSData object containing the decoded data. Any non-base-64 characters in the string are ignored, so it is safe to use a string containing line breaks or other delimiters.