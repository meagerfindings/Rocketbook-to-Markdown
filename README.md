# Rocketbook to Markdown

A simple Ruby script that converts OCR `.txt` files into `.md` files and moves them into predefined dir or locations.

The `.txt` files are OCR files that are created from handwritten notes using [Rocketbook](https://getrocketbook.com)'s scanning app.

## Setup / Background
The notes are synced via Google Drive, one of the few services that Rocketbook uploads the OCR content to. Unfortunately, the Google Drive formats the `.txt` files as Gdoc files that cannot be opened using Google Drive Backup and Sync. 

In order to get around this, I used a [template Google Apps script for pulling files from Gmail messages](http://www.googleappsscript.org/home/fetch-gmail-attachment-to-google-drive-using-google-apps-script). _I'd recommend adding an email message search to that script if you use it so that you're not pulling in all files from GDrive, essentially opening yourself up to malicious attacks._

With that script in place, I now send my Rocketbook scans to Gmail instead of Google Drive.

The Ruby script runs once every 20 seconds on each file in the chosen dir. It scans the file name for a match to a predefined filter and either converts if there is a match, or simply ignores the file if there is no match. The script moves all files to a processed sub directory in order to avoid iterating over a growing list of files.

Scheduling of the script is done using a `.plist` file and [Lunchy](https://github.com/eddiezane/lunchy).

_The Ruby script requires Ruby 2.4.1 or greater due to it's use of `FileUtils`._

## Examples

### Quotes file

Handwritten notes with the title: `## Quotes ##` will automatically be titled `Quotes-transcribed-beta.txt` by Rocketbook and uploaded. The ruby script then takes the OCR output and appends it to the `Quotes.md` file.

The OCR isn't the best, but neither is my handwriting. I can however, use some markdown syntax as I write these notes by hand though.

### Books file

Appended text is appended as a newline with a checkbox and bullet point in front of them.

Ex: `Out of the Ashes` is added to my books file and I get the following output:

```
 # Books
 - [x] Goals!
 - [x] Eloquent Ruby
 - [ ] Out of the Ashes
```

### Sermons

This could be repurposed for whatever. It allows me to take handwritten notes in church and then have a new markdown file for each note that matches the predefined searches. The name and date are appended to the file name and the title of the markdown note.
