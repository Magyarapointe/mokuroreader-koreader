# Contributing to Mokuro Reader

Thank you for your interest in contributing to Mokuro Reader! 🎉

## How to Contribute

### Reporting Bugs 🐛

Found a bug? Please open an [issue](https://github.com/YOUR_USERNAME/mokuroreader-koreader/issues) with:

1. **Clear title**: Describe the problem concisely
2. **Steps to reproduce**: How to trigger the bug
3. **Expected behavior**: What should happen
4. **Actual behavior**: What actually happens
5. **Environment**:
   - KOReader version
   - Device (Kobo, Kindle, etc.)
   - Plugin version
6. **Logs**: Include relevant crash logs if available

### Suggesting Features 💡

Have an idea? Open a [discussion](https://github.com/YOUR_USERNAME/mokuroreader-koreader/discussions) or issue with:

1. **Use case**: Why is this feature needed?
2. **Proposed solution**: How should it work?
3. **Alternatives**: Other approaches you considered

### Submitting Pull Requests 🔧

1. **Fork** the repository
2. **Create a branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**: Follow the code style below
4. **Test thoroughly**: On at least one device
5. **Commit**: Use clear, descriptive commit messages
6. **Push**: `git push origin feature/amazing-feature`
7. **Open a PR**: Describe your changes clearly

## Code Style

### Lua Conventions

- **Indentation**: 4 spaces (no tabs)
- **Naming**: 
  - `snake_case` for functions and variables
  - `CamelCase` for classes/modules
- **Comments**: Use clear, concise comments for complex logic
- **Line length**: Keep lines under 100 characters when possible

### Example

```lua
-- Good
local function calculate_text_width(text, font_size)
    -- Calculate width accounting for CJK characters
    local width = 0
    for char in text:gmatch(".") do
        width = width + get_char_width(char, font_size)
    end
    return width
end

-- Bad
function CalculateTextWidth(t,fs)
  local w=0 for c in t:gmatch(".") do w=w+get_char_width(c,fs) end return w
end
```

## Testing

Before submitting:

1. **Manual testing**: Test on your device
2. **Edge cases**: Try unusual inputs
3. **Different files**: Test with various mokuro manga
4. **Clean logs**: No errors in crash logs

## Documentation

When adding features:

1. Update `README.md` if user-facing
2. Update `CHANGELOG.md` with changes
3. Add inline comments for complex code
4. Update examples if needed

## Questions?

Not sure about something? Open a [discussion](https://github.com/YOUR_USERNAME/mokuroreader-koreader/discussions) and ask!

Thank you for contributing! 🙏
