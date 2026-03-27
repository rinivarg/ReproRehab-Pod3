#!/bin/bash

# Build the book
jupyter-book build .

# Copy image folders to the build directory
for week in "Week 2" "Week 3" "Week 4" "Week 5" "Week 6" "Week 7 & 8"; do
    if [ -d "Materials/$week/imgs" ]; then
        echo "Copying imgs from $week..."
        mkdir -p "_build/html/Materials/$week/imgs"
        cp -r "Materials/$week/imgs/"* "_build/html/Materials/$week/imgs/"
    fi
done

echo "done!"
