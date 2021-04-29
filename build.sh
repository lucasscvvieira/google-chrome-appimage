#/bin/sh

set -x

mkdir -p google-chrome/AppDir
cd google-chrome

# download google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

# extract files
ar x google-chrome-stable_current_amd64.deb
tar -xf data.tar.xz -C ./AppDir

cd AppDir
CHROME_VERSION=$(./opt/google/chrome/chrome --product-version)

mv ./usr/share/applications/google-chrome.desktop .
rm -rf ./usr ./etc

mkdir -p ./usr/lib \
	./usr/share/icons/hicolor/64x64/apps \
	./usr/share/icons/hicolor/32x32/apps \
	./usr/share/icons/hicolor/256x256/apps \
	./usr/share/icons/hicolor/24x24/apps \
	./usr/share/icons/hicolor/128x128/apps \
	./usr/share/icons/hicolor/48x48/apps

# apply patches
mv ./opt/google/chrome/product_logo_64.png  ./usr/share/icons/hicolor/64x64/apps/google-chrome.png
mv ./opt/google/chrome/product_logo_32.png  ./usr/share/icons/hicolor/32x32/apps/google-chrome.png
mv ./opt/google/chrome/product_logo_256.png ./usr/share/icons/hicolor/256x256/apps/google-chrome.png
mv ./opt/google/chrome/product_logo_24.png  ./usr/share/icons/hicolor/24x24/apps/google-chrome.png
mv ./opt/google/chrome/product_logo_128.png ./usr/share/icons/hicolor/128x128/apps/google-chrome.png
mv ./opt/google/chrome/product_logo_48.png  ./usr/share/icons/hicolor/48x48/apps/google-chrome.png
cp ./usr/share/icons/hicolor/256x256/apps/google-chrome.png .

sed -i -e 's|/usr/bin/google-chrome-stable|google-chrome|g' google-chrome.desktop
sed -i -e "s|Actions=new-window;new-private-window;|Actions=new-window;new-private-window;\nX-AppImage-Version=$CHROME_VERSION|g" google-chrome.desktop

cd ..
cp ../AppRun ./AppDir

wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
./appimagetool-x86_64.AppImage AppDir -n -u "gh-releases-zsync|lucasscvvieira|google-chrome-appimage|stable|Google-Chrome*.AppImage.zsync" "Google-Chrome-$CHROME_VERSION-x86_64.AppImage"
chmod +x Google-Chrome*.AppImage

mkdir dist
mv Google-Chrome*.AppImage* ./dist

