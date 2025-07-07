#!/bin/bash
# Test script for F1 help system

echo "🔍 Testing F1 Help System..."

# Check files exist
echo "📁 Files:"
ls -la ~/arch-dotfiles/.help-system/config.json ~/arch-dotfiles/.help-system/help.html

# Test JSON validity
echo "🔧 JSON validation:"
python3 -c "import json; print('✅ Valid JSON' if json.load(open('config.json')) else '❌ Invalid JSON')" 2>/dev/null || echo "❌ JSON Error"

# Test file access
echo "📄 Content files:"
ls -la content/

# Test browser launch
echo "🌐 Testing browser launch..."
firefox --version >/dev/null 2>&1 && echo "✅ Firefox available" || echo "❌ Firefox not found"

echo "✅ Test completed"