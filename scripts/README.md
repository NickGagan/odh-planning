# Export Scripts

Scripts to export spec documentation for stakeholder review and reference.

## Prerequisites

```bash
# Install pandoc (one-time setup)
brew install pandoc
```

## Scripts

### `merge-spec-to-doc.sh`

Merges all markdown files from a spec directory into one structured .docx document.

**Usage:**
```bash
./scripts/merge-spec-to-doc.sh <spec-id>
```

**Example:**
```bash
./scripts/merge-spec-to-doc.sh 002-playground-prompt-ui
```

**Output:**
- Creates: `~/Downloads/<spec-id>-complete.docx`
- Includes: Executive summary, spec, plan, contracts, team briefs, checklists
- Opens Downloads folder automatically

**Next steps:**
1. Upload .docx to Google Drive
2. Google Drive auto-converts to Google Docs
3. Use "View → Show document outline" for navigation
4. Share with stakeholders

---

### `export-for-notebooklm.sh`

Exports spec files in a flat structure for NotebookLM upload.

**Usage:**
```bash
./scripts/export-for-notebooklm.sh <spec-id> [executive|engineering|team <team-name>]
```

**Examples:**
```bash
# Executive view (summary only)
./scripts/export-for-notebooklm.sh 002-playground-prompt-ui executive

# Engineering view (complete technical docs)
./scripts/export-for-notebooklm.sh 002-playground-prompt-ui engineering

# Team-specific view
./scripts/export-for-notebooklm.sh 002-playground-prompt-ui team dashboard
```

**Output:**
- Creates: `exports/notebooklm/<audience>/<spec-id>/`
- All files flattened with clear naming (e.g., `01-specification.md`)
- Includes README with upload instructions

**Next steps:**
1. Script opens Finder with exported files
2. Script opens NotebookLM in browser
3. In Finder: Cmd+A to select all files
4. Drag files to NotebookLM
5. Generate audio overview
6. Share notebook link with stakeholders

---

## Workflow Recommendations

### For Stakeholder Review (Google Docs)

```bash
# 1. Generate complete document
./scripts/merge-spec-to-doc.sh 002-playground-prompt-ui

# 2. Upload to Google Drive
# 3. Share and collect feedback via comments

# 4. After approval, update Git specs with feedback
```

### For Reference Documentation (NotebookLM)

```bash
# 1. Export for NotebookLM
./scripts/export-for-notebooklm.sh 002-playground-prompt-ui engineering

# 2. Upload to NotebookLM
# 3. Generate audio overview
# 4. Share for team onboarding and Q&A
```

### Complete Workflow

```bash
# Week 1-2: Draft and iterate in Git
git checkout -b feature/002-planning
# ... work on specs ...

# Week 3: Export for stakeholder review
./scripts/merge-spec-to-doc.sh 002-playground-prompt-ui
# Upload to Google Docs, collect feedback

# Week 4: Update specs, get approval, merge to main
git commit -m "Incorporate stakeholder feedback"
git push

# Week 5: Export for reference
./scripts/export-for-notebooklm.sh 002-playground-prompt-ui engineering
# Upload to NotebookLM for team reference
```

---

## Tips

### Google Docs Line Spacing Fix

If copy-pasting from Cursor's markdown preview results in too much spacing:
1. Select all (Cmd+A)
2. Format → Line spacing → Single
3. Format → Remove space before/after paragraph

### NotebookLM Upload

For easiest upload:
1. Use Cmd+A in Finder to select all exported files
2. Drag all at once to NotebookLM browser window
3. Files upload in parallel (though processed sequentially)

### Custom Styling

Create a reference document for consistent .docx styling:
```bash
mkdir -p ~/.pandoc
# Save your styled template as ~/.pandoc/reference.docx
# The merge script will use it automatically
```

---

## Troubleshooting

### "Permission denied" when running merge

```bash
# Make sure script is executable
chmod +x scripts/merge-spec-to-doc.sh
```

### "Pandoc not found"

```bash
# Install pandoc
brew install pandoc
```

### Files not flattened in NotebookLM export

Check that the export script is using the correct directory structure. All files should be in one directory, not nested folders.

---

**Questions?** Check the main README or contact the spec-kit maintainer.

