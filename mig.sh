truffle migrate --reset|grep  -e 'Battleships: 0x'|awk '{print $2}' > newAddress.txt
