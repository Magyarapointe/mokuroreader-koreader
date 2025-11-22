# Mokuro Reader Plugin for KOReader

Read manga with mokuro OCR support directly in KOReader!

## Features

- ✅ **Automatic detection** of mokuro-processed CBZ files
- ✅ **Tap on text bubbles** to see OCR'd Japanese text
- ✅ **Dictionary integration** - hold and drag to select words, release to look them up
- ✅ **Sentence mining** - context is saved when adding words to VocabBuilder or Anki
- ✅ **Dual page mode support** - works correctly in two-page reading mode
- ✅ **Adjustable font size** for better readability
- ✅ **Works on all platforms** - Kindle, Kobo, PocketBook, Android, etc.
- ✅ **Supports all ZIP compression types** (Mac, Windows, Linux)

## Requirements

- **KOReader v2025.08 or higher** (required for `lib/ffi/archiver.so` support)
- Mokuro v0.2.0 or newer for processing manga

> ⚠️ **Important**: Earlier versions of KOReader (e.g., v2025.04) will crash when loading this plugin due to missing archiver library.

## Installation

1. **Download** the `mokuroreader.koplugin` folder
2. **Copy** it to your KOReader plugins directory:
   - **Kindle**: `/mnt/us/koreader/plugins/`
   - **Kobo**: `.adds/koreader/plugins/`
   - **PocketBook**: `/system/config/koreader/plugins/`
   - **Android**: `/sdcard/koreader/plugins/`
3. **Restart** KOReader
4. Open a mokuro-processed CBZ and start reading!

## Usage

### Preparing manga

1. Process your manga with mokuro:
   ```bash
   pip install mokuro
   mokuro "path/to/manga/folder"
   ```

2. Create a CBZ file containing both the images and the `.mokuro` file:
   - **Mac/Linux**: `zip -r manga.cbz manga_folder/*`
   - **Windows**: Use 7-Zip or built-in compression

3. Transfer the CBZ to your e-reader

### Reading

1. Open the mokuro CBZ in KOReader
2. The plugin detects the `.mokuro` file automatically
3. **Tap on text bubbles** to see the OCR'd text in a popup
4. **Hold and drag** to select text, **release** to look it up in your dictionaries
5. Adjust font size in: Menu → Navigation → Mokuro Reader → Font Size

### Sentence Mining

When you add a word to **VocabBuilder** or **Anki**, the plugin automatically provides the surrounding text from the speech bubble as context. This makes your flashcards more useful for learning!

## Settings

Access plugin settings via: **Menu → Navigation → Mokuro Reader**

- **Enable/Disable** the plugin
- **Font Size**: Medium (32), Large (48, default), Extra Large (64), Huge (80)
- **Status**: Check if mokuro data is loaded
- **About**: Plugin information

## Compatibility

| Component | Minimum Version |
|-----------|----------------|
| KOReader  | v2025.08       |
| Mokuro    | v0.2.0         |

**Platforms**: All KOReader platforms (Kindle, Kobo, PocketBook, Android, Linux, Mac)

**File format**: CBZ (ZIP archive containing images + `.mokuro` JSON file)

## Troubleshooting

### Plugin crashes on load

Make sure you're using **KOReader v2025.08 or newer**. Earlier versions don't include the required `lib/ffi/archiver.so` library.

### Plugin doesn't detect mokuro file

- Ensure your CBZ contains a `.mokuro` file
- Check the file is valid JSON
- Try re-creating the CBZ with standard compression

### Tap zones don't work

- Make sure the plugin is enabled (Menu → Mokuro Reader)
- Check that the CBZ was correctly processed by mokuro
- Restart KOReader after installing the plugin

### Dictionary lookup shows spaces between characters

This is normal for the display, but the plugin automatically removes CJK spaces before sending text to the dictionary.

## Technical Details

The plugin uses:
- `ffi/archiver` for reading CBZ files (supports all compression types)
- `rapidjson` for parsing `.mokuro` files
- `ScrollTextWidget` for text display with native text selection
- Touch zones for detecting taps on text bubbles
- Context injection for VocabBuilder/Anki sentence mining

## License

AGPL-3.0 (same as KOReader)

## Credits

Created for the KOReader community  
Based on the [mokuro](https://github.com/kha-white/mokuro) OCR project by kha-white
