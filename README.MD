Annotation Export/Import
========================

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0) ![This script was last tested in Nuix 7.8](https://img.shields.io/badge/Script%20Tested%20in%20Nuix-7.8-green.svg)

View the GitHub project [here](https://github.com/Nuix/Annotation-Export-Import) or download the latest release [here](https://github.com/Nuix/Annotation-Export-Import/releases).

# Overview

This script provides a way to export annotations from one case and then import them back in to another case.  Annotations are stored in a SQLite database.  During import, records in SQLite database file can be matched to items in destination case by either GUID or MD5.

# Getting Started

## Setup

Begin by downloading the latest release of this code.  Extract the contents of the archive into your Nuix scripts directory.  In Windows the script directory is likely going to be either of the following:

- `%appdata%\Nuix\Scripts` - User level script directory
- `%programdata%\Nuix\Scripts` - System level script directory

# Usage

## Export

To export annotations, begin by checking the "Export Annotations" radio button.  Then provide a file path to which the SQLite DB file will be saved.  Choose the annotation types to be exported (currently only Markups are supported), then click the "Ok" button.

## Import

To import annotations previously exported to a SQLite DB file by this script, begin by clicking "Import Annotations".  Then select the existing SQLite DB file created previously by exporting annotations with this script.

Choose whether to match items using `GUID` or `MD5`.  Use GUID when the destination case is a copy of the source case and you know the GUIDs in destination case will match the GUIDs in the source case.  Use MD5 when you know the destination case has the same data as the source case, but not necessarily the same GUIDs.  You'll will likely want to use MD5 if the destination case was a reprocess of the same data as the destination case, since the GUIDs will be different.

Then choose the annotation types to be imported (currently only Markups are supported).

Then decide how markups should be treated when the given markup set in the DB file already exists in the case.  Checking **Append if Markup Set Already Exists** will add new markups to any markup set that may already exist.  Leaving this option unchecked will create a new markup set with a suffixed name if a markup set in the DB file is found to already exist in the destination case.

# Cloning this Repository

This script relies on code from [Nx](https://github.com/Nuix/Nx) to present a settings dialog and progress dialog.  This JAR file is not included in the repository (although it is included in release downloads).  If you clone this repository, you will also want to obtain a copy of Nx.jar by either:
1. Building it from [the source](https://github.com/Nuix/Nx)
2. Downloading an already built JAR file from the [Nx releases](https://github.com/Nuix/Nx/releases)

Once you have a copy of Nx.jar, make sure to include it in the same directory as the script.

This script also relies on code from [SuperUtilities](https://github.com/Nuix/SuperUtilities).  This JAR file is not included in the repository (although it is included in release downloads).  If you clone this repository, you will also want to obtain a copy of SuperUtilities.jar by either:
1. Building it from [the source](https://github.com/Nuix/SuperUtilities)
2. Downloading an already built JAR file from the [SuperUtilities releases](https://github.com/Nuix/SuperUtilities/releases)

Once you also have a copy of SuperUtilities.jar, make sure to include it in the same directory as the script.

# License

```
Copyright 2019 Nuix

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
