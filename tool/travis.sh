#!/bin/bash

# Fast fail the script on failures.
set -e

dartanalyzer --fatal-warnings \
  lib/attr.dart \
  lib/html.dart \
  lib/html_browser.dart \
  lib/html_html5lib.dart \
  lib/html_utils.dart \
  lib/tag.dart \
  lib/util/html_tidy.dart \

pub run test -p vm
pub run test -p chrome,firefox
# pub run test -p content-shell -j 1
# pub run test -p firefox -j 1 --reporter expanded