#!/bin/bash
# scripts/merge-spec-to-doc.sh
# Merges all markdown files from a spec directory into one structured document

set -e

SPEC_ID=$1

if [ -z "$SPEC_ID" ]; then
  echo "Usage: ./merge-spec-to-doc.sh <spec-id>"
  echo "Example: ./merge-spec-to-doc.sh 002-playground-prompt-ui"
  exit 1
fi

SPEC_DIR="specs/${SPEC_ID}"
TEMP_DIR="/tmp/spec-merge-$$"
OUTPUT_FILE="$HOME/Downloads/${SPEC_ID}-complete.docx"

if [ ! -d "$SPEC_DIR" ]; then
  echo "❌ Spec directory not found: $SPEC_DIR"
  exit 1
fi

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
  echo "❌ Pandoc not found. Install with: brew install pandoc"
  exit 1
fi

mkdir -p "$TEMP_DIR"

echo "📚 Merging spec ${SPEC_ID}..."

# Create master markdown file with proper structure
cat > "$TEMP_DIR/master.md" <<EOF
---
title: "Specification ${SPEC_ID}"
subtitle: "Complete Documentation"
date: "$(date +'%B %d, %Y')"
---

# Table of Contents

EOF

# Function to add TOC entry
add_to_toc() {
  local section_title=$1
  echo "- ${section_title}" >> "$TEMP_DIR/master.md"
}

# Build TOC first (we'll add entries as we process files)
TOC_ENTRIES=()

# Collect all filenames that will be added
if [ -f "$SPEC_DIR/coordination/executive-summary.md" ]; then
  TOC_ENTRIES+=("executive-summary.md")
fi
if [ -f "$SPEC_DIR/spec.md" ]; then
  TOC_ENTRIES+=("spec.md")
fi
if [ -f "$SPEC_DIR/plan.md" ]; then
  TOC_ENTRIES+=("plan.md")
fi
if [ -d "$SPEC_DIR/contracts" ] && [ "$(ls -A $SPEC_DIR/contracts/*.md 2>/dev/null)" ]; then
  for contract in "$SPEC_DIR/contracts"/*.md; do
    if [ -f "$contract" ]; then
      TOC_ENTRIES+=("contracts/$(basename "$contract")")
    fi
  done
fi
if [ -d "$SPEC_DIR/coordination/briefs" ] && [ "$(ls -A $SPEC_DIR/coordination/briefs/*.md 2>/dev/null)" ]; then
  for brief in "$SPEC_DIR/coordination/briefs"/*.md; do
    if [ -f "$brief" ]; then
      TOC_ENTRIES+=("briefs/$(basename "$brief")")
    fi
  done
fi
if [ -d "$SPEC_DIR/checklists" ] && [ "$(ls -A $SPEC_DIR/checklists/*.md 2>/dev/null)" ]; then
  for checklist in "$SPEC_DIR/checklists"/*.md; do
    if [ -f "$checklist" ]; then
      TOC_ENTRIES+=("checklists/$(basename "$checklist")")
    fi
  done
fi

# Write TOC entries
for entry in "${TOC_ENTRIES[@]}"; do
  echo "- ${entry}" >> "$TEMP_DIR/master.md"
done

echo "" >> "$TEMP_DIR/master.md"

# Function to add file as a section (filename becomes ONLY heading in outline)
add_section() {
  local file=$1
  local section_title=$2
  
  if [ ! -f "$file" ]; then
    return
  fi
  
  # Add page break using raw openxml (for Word docx format)
  echo "" >> "$TEMP_DIR/master.md"
  echo '```{=openxml}' >> "$TEMP_DIR/master.md"
  echo '<w:p><w:r><w:br w:type="page"/></w:r></w:p>' >> "$TEMP_DIR/master.md"
  echo '```' >> "$TEMP_DIR/master.md"
  echo "" >> "$TEMP_DIR/master.md"
  echo "# ${section_title}" >> "$TEMP_DIR/master.md"
  echo "" >> "$TEMP_DIR/master.md"
  
  # Include file content, converting all markdown headings to bold text
  # This prevents them from appearing in the document outline
  cat "$file" | sed 's/^# \(.*\)$/\n**\1**\n/g' | \
                sed 's/^## \(.*\)$/\n**\1**\n/g' | \
                sed 's/^### \(.*\)$/\n**\1**\n/g' | \
                sed 's/^#### \(.*\)$/\n**\1**\n/g' | \
                sed 's/^##### \(.*\)$/\n**\1**\n/g' >> "$TEMP_DIR/master.md"
  
  echo "" >> "$TEMP_DIR/master.md"
}

# Build structured document
echo "   📄 Adding Executive Summary..."
if [ -f "$SPEC_DIR/coordination/executive-summary.md" ]; then
  add_section "$SPEC_DIR/coordination/executive-summary.md" "executive-summary.md"
fi

echo "   📋 Adding Specification..."
if [ -f "$SPEC_DIR/spec.md" ]; then
  add_section "$SPEC_DIR/spec.md" "spec.md"
fi

echo "   🗺️  Adding Implementation Plan..."
if [ -f "$SPEC_DIR/plan.md" ]; then
  add_section "$SPEC_DIR/plan.md" "plan.md"
fi

# Add contracts section
if [ -d "$SPEC_DIR/contracts" ] && [ "$(ls -A $SPEC_DIR/contracts/*.md 2>/dev/null)" ]; then
  echo "   📜 Adding Contracts..."
  
  for contract in "$SPEC_DIR/contracts"/*.md; do
    if [ -f "$contract" ]; then
      filename=$(basename "$contract")
      add_section "$contract" "contracts/${filename}"
    fi
  done
fi

# Add coordination briefs
if [ -d "$SPEC_DIR/coordination/briefs" ] && [ "$(ls -A $SPEC_DIR/coordination/briefs/*.md 2>/dev/null)" ]; then
  echo "   👥 Adding Team Briefs..."
  
  for brief in "$SPEC_DIR/coordination/briefs"/*.md; do
    if [ -f "$brief" ]; then
      filename=$(basename "$brief")
      add_section "$brief" "briefs/${filename}"
    fi
  done
fi

# Add checklists
if [ -d "$SPEC_DIR/checklists" ] && [ "$(ls -A $SPEC_DIR/checklists/*.md 2>/dev/null)" ]; then
  echo "   ✅ Adding Checklists..."
  
  for checklist in "$SPEC_DIR/checklists"/*.md; do
    if [ -f "$checklist" ]; then
      filename=$(basename "$checklist")
      add_section "$checklist" "checklists/${filename}"
    fi
  done
fi

# Add any other markdown files not yet included
echo "   📎 Checking for additional files..."
while IFS= read -r -d '' file; do
  # Skip files we've already included
  if [[ ! "$file" =~ (executive-summary|spec|plan|contracts|briefs|checklists|README) ]]; then
    rel_path="${file#$SPEC_DIR/}"
    echo "   📌 Adding: $rel_path"
    add_section "$file" "$rel_path"
  fi
done < <(find "$SPEC_DIR" -name "*.md" -type f -print0)

echo ""
echo "🔄 Converting to .docx with pandoc..."

# Convert to docx with nice formatting (no auto-TOC since we made custom one)
pandoc "$TEMP_DIR/master.md" \
  -o "$OUTPUT_FILE" \
  -V geometry:margin=1in \
  -V linkcolor:blue \
  -V fontsize=11pt \
  --highlight-style=tango \
  --reference-doc="$HOME/.pandoc/reference.docx" 2>/dev/null || \
pandoc "$TEMP_DIR/master.md" \
  -o "$OUTPUT_FILE" \
  -V geometry:margin=1in \
  -V linkcolor:blue \
  -V fontsize=11pt \
  --highlight-style=tango

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Complete document created!"
echo "📂 Location: $OUTPUT_FILE"
echo "📊 File size: $(ls -lh "$OUTPUT_FILE" | awk '{print $5}')"
echo ""
echo "📌 Next steps:"
echo "   1. Upload to Google Drive: https://drive.google.com"
echo "   2. Google Drive will convert to Google Docs"
echo "   3. Use Document Outline (View → Show document outline) for navigation"
echo "   4. Share with stakeholders"
echo ""

# Open the output directory
open "$(dirname "$OUTPUT_FILE")"

