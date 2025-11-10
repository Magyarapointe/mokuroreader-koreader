# Changelog

All notable changes to the Mokuro Reader plugin will be documented in this file.

## [6.0.0] - 2025-11-10 - STABLE RELEASE 🎉

### Added
- **PERFECT TEXT SELECTION FOR JAPANESE!** Character-by-character precision
- Added padding spaces at start of text to make first character easily selectable
- Full dictionary integration with automatic CJK space removal

### Summary
This version provides fully working text selection with dictionary integration:
- ✅ Tap speech bubbles to see OCR text in bottom popup
- ✅ Hold and drag to select Japanese text character-by-character
- ✅ Release to open dictionary with selected word (CJK spaces automatically removed)
- ✅ All text selection edge cases handled properly
- ✅ First character is now easily selectable with padding

### Technical Highlights (v5.3 → v6.0 journey)
- v5.3: Fixed callback signature and widget creation order
- v5.4: Switched to ScrollTextWidget (proper KOReader widget)
- v5.5: Fixed access to internal TextBoxWidget methods
- v5.6: Fixed closure variable capture (ui and mokuro_popup)
- v6.0: Added text padding for first character selection

## [1.1.2] - 2025-11-09

### Fixed
- Fixed crash: Added missing `Device` require statement
- Popup now displays correctly

## [1.1.1] - 2025-11-09

### Fixed
- **TEXT SELECTION NOW WORKS!** 🎉
- Switched from `ScrollTextWidget` to `ScrollHtmlWidget` (same as footnotes)
- Text is now properly selectable with hold gesture
- Dictionary lookup works correctly on selected words
- Clear highlight after dictionary closes

### Technical
- Uses `ScrollHtmlWidget` instead of `ScrollTextWidget`
- Converts plain text to HTML with proper escaping
- `HoldReleaseText` event with callback for text selection
- Same selection mechanism as KOReader's footnotes

## [1.1.0] - 2025-11-09

### Changed
- **NEW POPUP STYLE**: Replaced DictQuickLookup with footnote-style popup (inspired by KOReader's footnote display)
- Popup now appears at bottom of screen (1/3 height) like footnotes
- Much cleaner interface - **NO MORE UNWANTED BUTTONS!** 🎉
- Text selection works exactly like in footnotes
- Tap outside the popup (above it) to close

### Technical
- Uses `ScrollTextWidget` instead of `DictQuickLookup`
- Popup wrapped in `BottomContainer` for proper positioning
- Simpler gesture handling (tap-to-close outside popup area)
- Same text selection and dictionary integration as before

## [1.0.1] - 2025-11-09

### Fixed
- Documentation: Corrected menu location (Navigation, not Tools)
- Added `sorting_hint = "tools"` to _meta.lua

## [1.0.0] - 2025-11-09

### Added
- Initial release of Mokuro Reader plugin for KOReader
- Automatic detection of mokuro-processed CBZ files
- Tap zones on text bubbles for OCR text display
- Integration with KOReader's dictionary system
- DictQuickLookup widget for text display with word selection
- Font size adjustment (Small, Medium, Large, Extra Large)
- Support for all ZIP compression types via ffi/archiver
- Cross-platform compatibility (Kindle, Kobo, PocketBook, Android, Linux, Mac)

### Technical Implementation
- Uses `ffi/archiver` for reliable CBZ reading on all platforms
- Coordinate conversion from mokuro JSON to screen coordinates
- Touch zone registration system for precise tap detection
- JSON parsing with rapidjson
- G_reader_settings integration for font size preferences

### Known Limitations
- Buttons in dictionary popup cannot be hidden (tweak_buttons_func not supported in some KOReader versions)
- Some older KOReader versions may not support all features

## Future Improvements

### Planned for v1.1.0
- [ ] Hide dictionary popup buttons (if/when KOReader support improves)
- [ ] Custom popup design without dependency on DictQuickLookup
- [ ] Page navigation from popup
- [ ] Highlight current text bubble

### Planned for v1.2.0
- [ ] Support for multiple .mokuro files in one CBZ
- [ ] Text-to-speech integration
- [ ] Export OCR text to notes
- [ ] Statistics (pages read, words looked up)

### Planned for v2.0.0
- [ ] Real-time mokuro processing (optional)
- [ ] Custom OCR engine integration
- [ ] Reading progress tracking
- [ ] Sync with external services
