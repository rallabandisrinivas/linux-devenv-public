#!/bin/bash


### HowTo
## Find "latest" url:
# It usually contains hyphens as replacements for underscores
# Go to the addon search web page of firefox. Search for the addon and go to its page. Look in the address bar. Use the addons name as it is displayed there as part of the download URL
# Right click on the add addon button and copy link location is NOT the correct way to do it.

wget -O https.xpi https://addons.mozilla.org/firefox/downloads/latest/https-everywhere&
wget -O review.xpi https://addons.mozilla.org/firefox/downloads/latest/reviewmeta-com-review-helper&
wget -O ublock.xpi https://addons.mozilla.org/firefox/downloads/latest/ublock-origin&
wget -O noscript.xpi https://addons.mozilla.org/firefox/downloads/latest/noscript&
wget -O nocookies.xpi https://addons.mozilla.org/firefox/downloads/latest/i-dont-care-about-cookies&
wget -O facebookcontainer.xpi https://addons.mozilla.org/firefox/downloads/latest/facebook-container&
wget -O videospeed.xpi https://addons.mozilla.org/firefox/downloads/latest/videospeed/&
wget -O darkreader.xpi https://addons.mozilla.org/firefox/downloads/latest/darkreader/&

sleep 2

# Install user.js
# find default-release profile folder to add user specific configs to it
export mozillaDir=$(find   ~/.mozilla -name "*default-release*" -type d)
export target="${mozillaDir}/user.js"
cp home/user/firefox/user.js $target

export target="${mozillaDir}/chrome"
mkdir -p $target
export target="${mozillaDir}/chrome/userChrome.css"
cp home/user/firefox/userChrome.css $target


su -c "firefox ublock.xpi https.xpi review.xpi noscript.xpi nocookies.xpi facebookcontainer.xpi videospeed.xpi darkreader.xpi" user

rm *.xpi

read -p "Press enter to continue"

read -p "Remember to enable dark theme throug menu -> addons -> themes"

read -p "Remember to manually enable the always encrypt mode on https everywhere addon"

touch ~/.config/.firefoxIsInstalled
