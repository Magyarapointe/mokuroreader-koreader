# Installation Guide

## Step-by-Step Installation

### 1. Download the Plugin

Go to the [Releases page](https://github.com/YOUR_USERNAME/mokuroreader-koreader/releases) and download the latest `mokuroreader.koplugin-vX.X.X.zip`

### 2. Extract the Archive

Unzip the file. You should get a folder named `mokuroreader.koplugin`

### 3. Find Your KOReader Plugins Directory

The location depends on your device:

| Device | Path |
|--------|------|
| **Kindle** | `/mnt/us/koreader/plugins/` |
| **Kobo** | `.kobo/KOReader/plugins/` or `koreader/plugins/` |
| **PocketBook** | `system/share/koreader/plugins/` |
| **Android** | `/sdcard/koreader/plugins/` |
| **Linux** | `~/.config/koreader/plugins/` |
| **macOS** | `~/Library/Application Support/koreader/plugins/` |

### 4. Copy the Plugin

Copy the entire `mokuroreader.koplugin` folder to the plugins directory.

**Example on Kobo via USB:**
```
Computer > Kobo > .kobo > KOReader > plugins > mokuroreader.koplugin
```

**Example on Android via File Manager:**
```
Internal Storage > koreader > plugins > mokuroreader.koplugin
```

### 5. Restart KOReader

Completely close and reopen KOReader.

### 6. Verify Installation

1. Open any book in KOReader
2. Tap the menu
3. Navigate to **Navigation** tab
4. You should see **Mokuro Reader** in the list

If you see it, installation was successful! 🎉

### 7. Test with a Mokuro Manga

1. Process a manga with [mokuro](https://github.com/kha-white/mokuro)
2. Open the resulting CBZ in KOReader
3. Tap any speech bubble
4. A popup with OCR text should appear!

## Troubleshooting

### "Plugin doesn't appear in menu"

**Possible causes:**
- Folder is in the wrong location
- Folder is named incorrectly (must be `mokuroreader.koplugin`)
- KOReader version is too old (need v2024.07+)

**Solutions:**
1. Double-check the plugins folder path for your device
2. Ensure you copied the entire folder, not just the files inside
3. Make sure the folder is named exactly `mokuroreader.koplugin`
4. Update KOReader to the latest version

### "Nothing happens when I tap bubbles"

**Possible causes:**
- CBZ file doesn't have mokuro data
- Mokuro file is corrupted

**Solutions:**
1. Open the CBZ with a zip tool (7-Zip, WinRAR, etc.)
2. Check if there's a `.mokuro` file inside
3. If not, the manga needs to be processed with mokuro first
4. Try processing the manga again with mokuro

### "Text selection doesn't work"

**Remember:**
- You need to **hold** (not tap) on the text
- Hold for at least 0.5 seconds before starting to drag
- Make sure you're holding on the text area, not outside

### "Dictionary doesn't open"

**Setup required:**
1. In KOReader: Menu → Settings → Dictionary
2. Install a Japanese dictionary
3. Recommended: JMdict, JMdict for Yomichan, or Wadoku

## Uninstallation

To remove the plugin:

1. Delete the `mokuroreader.koplugin` folder from the plugins directory
2. Restart KOReader

Your reading data and KOReader settings won't be affected.

## Need More Help?

- Check the [main README](../README.md)
- Open an [issue](https://github.com/YOUR_USERNAME/mokuroreader-koreader/issues)
- Join the [discussions](https://github.com/YOUR_USERNAME/mokuroreader-koreader/discussions)
