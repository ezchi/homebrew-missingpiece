#!/bin/bash
set -e

# Usage: ./build_bottle.sh <formula_name>
# Example: ./build_bottle.sh systemc

FORMULA_NAME=$1

if [ -z "$FORMULA_NAME" ]; then
    echo "Error: Formula name required."
    echo "Usage: $0 <formula_name>"
    exit 1
fi

TAP_NAME="ezchi/missingpiece"
LOCAL_FORMULA_PATH="./Formula/$FORMULA_NAME.rb"
# Get the tap path dynamically
TAP_PATH=$(brew --repo "$TAP_NAME")
TAP_FORMULA_PATH="$TAP_PATH/Formula/$FORMULA_NAME.rb"

# 1. Check if local formula exists
if [ ! -f "$LOCAL_FORMULA_PATH" ]; then
    echo "Error: Local formula file not found at $LOCAL_FORMULA_PATH"
    exit 1
fi

# 2. Sync local formula to the active Homebrew tap directory
echo "==> Syncing $LOCAL_FORMULA_PATH to $TAP_FORMULA_PATH"
cp "$LOCAL_FORMULA_PATH" "$TAP_FORMULA_PATH"

# 3. Uninstall existing versions
echo "==> Uninstalling existing $FORMULA_NAME (if any)..."
brew uninstall "$FORMULA_NAME" 2>/dev/null || true
brew uninstall "$TAP_NAME/$FORMULA_NAME" 2>/dev/null || true

# 4. Install with --build-bottle
echo "==> Installing $TAP_NAME/$FORMULA_NAME with --build-bottle..."
brew install --build-bottle "$TAP_NAME/$FORMULA_NAME"

# 5. Run brew test
echo "==> Running tests..."
brew test "$TAP_NAME/$FORMULA_NAME"

# 6. Generate Bottle and JSON
echo "==> Generating bottle and updating formula..."
# Remove old Json/tar.gz files to avoid confusion
if ls *.bottle.json 1> /dev/null 2>&1; then rm *.bottle.json; fi
if ls *.bottle.tar.gz 1> /dev/null 2>&1; then rm *.bottle.tar.gz; fi

# Generate json and tarball
brew bottle --json "$TAP_NAME/$FORMULA_NAME"

# Find the generated json file
BOTTLE_JSON=$(ls *.bottle.json | head -n 1)

if [ -z "$BOTTLE_JSON" ]; then
  echo "Error: No bottle JSON file generated."
  exit 1
fi

# 7. Merge into tap formula
echo "==> Merging bottle info into tap formula ($BOTTLE_JSON)..."
brew bottle --merge --write --no-commit "$BOTTLE_JSON"

# 8. Sync back to local
echo "==> Syncing updated formula back to local $LOCAL_FORMULA_PATH..."
cp "$TAP_FORMULA_PATH" "$LOCAL_FORMULA_PATH"


# 9. Manage Bottles directory
BOTTLES_DIR="./Bottles"
mkdir -p "$BOTTLES_DIR"

NEW_BOTTLE_FILE=$(ls *.bottle.tar.gz | head -n 1)
if [ -n "$NEW_BOTTLE_FILE" ]; then
    echo "==> Moving $NEW_BOTTLE_FILE to $BOTTLES_DIR/..."
    mv "$NEW_BOTTLE_FILE" "$BOTTLES_DIR/"
fi

echo "==> Cleaning up old bottles for $FORMULA_NAME in $BOTTLES_DIR..."
# Iterate over potential bottle files for this formula
# We look for files starting with formula name followed by - (digit) or --
for file in "$BOTTLES_DIR"/*.bottle.tar.gz; do
    [ -e "$file" ] || continue
    filename=$(basename "$file")
    
    # Check if file belongs to this formula
    # Matches: systemc--3.0.2... or systemc-3.0.2...
    # Excludes: systemc-other-thing... (unless starts with digit)
    # Using regex to ensure we target the right formula
    if [[ "$filename" =~ ^${FORMULA_NAME}-- ]] || [[ "$filename" =~ ^${FORMULA_NAME}-[0-9] ]]; then
        FILE_SHA=$(shasum -a 256 "$file" | awk '{print $1}')
        
        # Check if this SHA is present in the CURRENT formula file
        if grep -q "$FILE_SHA" "$LOCAL_FORMULA_PATH"; then
             echo "  [KEEP]   $filename (Hash matches formula)"
        else
             echo "  [DELETE] $filename (Hash not found in active formula)"
             rm "$file"
        fi
    fi
done

echo "==> Build and Update complete!"
echo "Formula file updated: $LOCAL_FORMULA_PATH"
echo "Bottles directory updated: $BOTTLES_DIR"
