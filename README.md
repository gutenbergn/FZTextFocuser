# FZTextFocuser
`FZTextFocuser` allows focusable text to be displayed in tvOS, with options to customize the focus state, either by highlighting the entire text or only a portion of it.

[![Version](https://img.shields.io/cocoapods/v/FZTextFocuser.svg?style=flat)](https://cocoapods.org/pods/FZTextFocuser)
[![Platform](https://img.shields.io/cocoapods/p/FZTextFocuser.svg?style=flat)](https://cocoapods.org/pods/FZTextFocuser)

## How to Use

To use `FZTextFocuser`, first add an instance to your view, then pass an attributed string to it and set the properties that will define how the focused text will be displayed.

```
let textFocuser = FZTextFocuser(frame: self.view.frame)
self.view.addSubview(textFocuser)

textFocuser.attributedString = NSAttributedString(string: "Test String", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40), NSAttributedString.Key.foregroundColor: UIColor.black])
textFocuser.focusedBackgroundColor = UIColor.red // this will be applied to the entire view when focused
textFocuser.addFocusableText("String", textColor: .yellow, backgroundColor: .blue, cornerRadius: 5) // this will apply only to the specified string
```

Also make sure to implement the `FZTextFocuserDelegate` protocol and set the delegate property of your `FZTextFocuser` instance to be notified when the user taps the text

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

You can use CocoaPods (https://cocoapods.org/) to install `FZTextFocuser`. If you don't have CocoaPods configured on your project yet, please refer to the CocoaPods Guides (https://guides.cocoapods.org/using/using-cocoapods.html).

Next, add the library to your Podfile:
```
pod 'FZTextFocuser'
```

Then, run the command:
```shell
$ pod install
```

Once CocoaPods is integrated with your project, make sure to always run your project using the `.xcworkspace` file instead of `.xcodeproj`.

Alternatively, you can just download the source code and add the `FZTextFocuser.swift` file to your project.

## Requirements
tvOS 9.0+

## Author

gutenbergn, gutenbergn@gmail.com

## License

FZTextFocuser is available under the MIT license. See the LICENSE file for more info.
