#!/bin/bash

# Select a region using slurp
region=$(slurp)

# Exit if no region is selected
if [ -z "$region" ]; then
  notify-send "Text not copy!"
  exit 1
fi

# Define temporary files
temp_image=$(mktemp --suffix=.png)
temp_text=$(mktemp --suffix=.txt)

# Use grim to capture only the selected region to a temporary file
grim -g "$region" "$temp_image"

# Use tesseract to extract text from the captured region with English language support
tesseract "$temp_image" "$temp_text" --oem 3 --psm 6

# Output the extracted text
extracted_text=$(cat "${temp_text}.txt")

# Copy the extracted text to the clipboard using wl-copy
echo "$extracted_text" | wl-copy

# Optional: Show the extracted text in a notification
notify-send "Text copied to clipboard: " "$extracted_text"

# Cleanup temporary files
rm "$temp_image" "${temp_text}.txt"

