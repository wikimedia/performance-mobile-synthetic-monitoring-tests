apps=("org.mozilla.firefox" \
      "com.android.chrome")

for app in ${apps[@]}; do
  echo adb -s $1 shell am force-stop $app
  adb -s $1 shell am force-stop $app
  echo adb -s $1 shell pm clear $app
  adb -s $1 shell pm clear $app
done