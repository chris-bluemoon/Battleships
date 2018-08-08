truffle console --log chris.txt << EOF
const fs = require('fs'); const contract = JSON.parse(fs.readFileSync('./build/contracts/Battleships.json', 'utf8')); console.log(JSON.stringify(contract.abi));
EOF
