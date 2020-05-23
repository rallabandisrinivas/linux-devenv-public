#/bin/bash

# becasue the level 1 is way too low, we automatically set it to 6 when it drops below 6

inotifywait -q -m -e close_write myfile.py |
while read -r filename event; do
  ./myfile.py         # or "./$filename"
done


