#!/bin/bash

# دیاریکردنی فۆڵدەری ئێستای یارییەکەت
WATCHED_DIR="."

echo "🚀 پاسەوانی ئۆتۆماتیکی گیت چالاک بوو! چاوەڕوانی گۆڕانکارییەکانم..."

# چاودێریکردنی هەر گۆڕانکارییەک لە فایلەکاندا (جگە لە فۆڵدەری .git)
inotifywait -m -r -e modify -e create -e delete --exclude '\.git' "$WATCHED_DIR" | while read path action file; do
    echo "⚡ گۆڕانکاری دۆزرایەوە لە: $path$file ($action)"
    
    # کەمێک چاوەڕێ دەکات بۆ ئەوەی ئەگەر چەند فایلێک بوو پێکەوە بنێردرێن
    sleep 2
    
    # پرۆسەی ناردنی ئۆتۆماتیکی بۆ گێتهەب
    git add .
    git commit -m "auto: updated $file via termux watcher"
    git push origin main
    
    echo "✅ گۆڕانکارییەکە بە سەرکەوتوویی نێردرا بۆ گێتهەب! چاوەڕوانی گۆڕانکاری داهاتوو..."
done
