# Claud Desktop without Spying

[Claude_Launch_Without_Spying.shortcut](./Claude_Launch_Without_Spying.shortcut) is a macOS shortcut that circumvents the effects [as described in an article](https://www.thatprivacyguy.com/blog/anthropic-spyware/), i.e., the fact that Claude Desktop for macOS installs Chrome extensions without further notice.

This macOS shortcut wraps the Claude Desktop launch and removes these extensions after app has been launched. 

__Please note__ that this shortcut will not save you if Claude Desktop is launched automatically if you start your system. It is a quick hack for manually launching the app.

In order to use the shortcut, you will have to allow script execution. For the sake of transparency, here are the lines executed by the script:
```
rm -f ~/Library/Application\ Support/Vivaldi/NativeMessagingHosts/com.anthropic.claude_browser_extension.json 
rm -f ~/Library/Application\ Support/Google/Chrome/NativeMessagingHosts/com.anthropic.claude_browser_extension.json 
rm -f ~/Library/Application\ Support/com.operasoftware.Opera/NativeMessagingHosts/com.anthropic.claude_browser_extension.json 
rm -f ~/Library/Application\ Support/Chromium/NativeMessagingHosts/com.anthropic.claude_browser_extension.json 
rm -f ~/Library/Application\ Support/Microsoft\ Edge/NativeMessagingHosts/com.anthropic.claude_browser_extension.json 
rm -f ~/Library/Application\ Support/Arc/User\ Data/NativeMessagingHosts/com.anthropic.claude_browser_extension.json 
rm -f ~/Library/Application\ Support/BraveSoftware/Brave-Browser/NativeMessagingHosts/com.anthropic.claude_browser_extension.json 
```

## Testing

If you want to check if the shortcut is working properly launch a terminal and execute the following command:
```
find ~/Library/Application\ Support -name "com.anthropic.claude_browser_extension*"
```

This should yield the following results complaining that not all directories could be accessed, e.g.:
```
...
find: /Users/xyz/Library/Application Support/com.apple.sharedfilelist: Operation not permitted
find: /Users/xyz/Library/Application Support/Knowledge: Operation not permitted
...
```
If a path from the ones listed above is printed, something went wrong.