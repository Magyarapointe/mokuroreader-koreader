# Mokuro Reader Plugin for KOReader

Read manga with mokuro OCR support directly in KOReader!

## Features

- ✅ **Automatic detection** of mokuro-processed CBZ files
- ✅ **Tap on text bubbles** to see OCR'd Japanese text
- ✅ **Dictionary integration** - long press on words to look them up
- ✅ **Adjustable font size** for better readability
- ✅ **Works on all platforms** - Kindle, Kobo, PocketBook, Android, etc.
- ✅ **Supports all ZIP compression types** (Mac, Windows, Linux)

## Installation

1. **Download** the `mokuro.koplugin` folder
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

2. Create a CBZ file:
   - **Mac/Linux**: `zip -r manga.cbz manga_folder/*`
   - **Windows**: Use 7-Zip or built-in compression

3. Transfer the CBZ to your e-reader

### Reading

1. Open the mokuro CBZ in KOReader
2. The plugin detects the .mokuro file automatically
3. **Tap on text bubbles** to see the OCR'd text
4. **Long press on words** to look them up in your dictionaries
5. Adjust font size in: Menu → Navigation → Mokuro Reader → Font Size

## Settings

Access plugin settings via: **Menu → Navigation → Mokuro Reader**

- **Enable/Disable** the plugin
- **Font Size**: Small (18), Medium (22), Large (26), Extra Large (30)
- **Status**: Check if mokuro data is loaded

## Compatibility

- **KOReader**: v2020.01 or newer
- **Mokuro**: v0.2.0 or newer
- **Platforms**: All KOReader platforms (Kindle, Kobo, PocketBook, Android, etc.)
- **File format**: CBZ (ZIP with images + .mokuro file)

## Troubleshooting

### Plugin doesn't detect mokuro file

- Ensure your CBZ contains a `.mokuro` file
- Check the file is valid JSON
- Try re-creating the CBZ with standard compression

### Tap zones don't work

- Make sure the plugin is enabled (Menu → Mokuro Reader)
- Check that the CBZ was correctly processed by mokuro
- Restart KOReader after installing the plugin

## Technical Details

The plugin uses:
- `ffi/archiver` for reading CBZ files (supports all compression types)
- `rapidjson` for parsing .mokuro files
- `DictQuickLookup` for displaying text with dictionary integration
- Touch zones for detecting taps on text bubbles

## License

AGPL-3.0 (same as KOReader)

## Credits

Created for the KOReader community
Based on the mokuro OCR project by kha-white
