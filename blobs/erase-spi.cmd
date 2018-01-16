# erase flash
sf probe

echo erasing flash...
sf erase 0 3e8000

echo done
