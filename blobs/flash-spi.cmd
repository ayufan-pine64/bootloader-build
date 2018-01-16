# first read existing loader
sf probe

echo reading flash...
${devtype} read ${kernel_addr_r} 10 1f40;

# erase flash
echo erasing flash...
sf erase 0 3e8000

# write flash
echo writing flash...
sf write ${kernel_addr_r} 0 3e8000

echo done
