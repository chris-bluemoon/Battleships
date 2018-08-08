if (typeof web3 !== 'undefined') {
  web3 = new Web3(web3.currentProvider);
  console.log("Found web3 injection");
  console.log(web3);
} else {
  console.log("I am Trying new web3 connection");
  console.log(typeof web3);
  web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
}
web3.eth.defaultAccount = web3.eth.accounts[0];

var BattleshipContract = web3.eth.contract([{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"}],"name":"LogShotResult","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"}],"name":"LogPlaceLegality","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"uint256"},{"indexed":false,"name":"","type":"uint256"}],"name":"LogShipStartStop","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"}],"name":"LogAllShipsPlaced","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"uint256"},{"indexed":false,"name":"","type":"uint256"},{"indexed":false,"name":"","type":"uint256"}],"name":"LogShipPlaced","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"uint256"}],"name":"LogCurrentShip","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"}],"name":"LogShipSunk","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"}],"name":"LogGameWon","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"}],"name":"LogAllShipsSunk","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"uint8"}],"name":"LogCheckShipStatus","type":"event"},{"constant":true,"inputs":[],"name":"returnPlayers","outputs":[{"name":"","type":"string"},{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"playerName","type":"string"}],"name":"registerPlayer","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint8"},{"name":"y","type":"uint8"},{"name":"shipType","type":"string"},{"name":"playerName","type":"string"},{"name":"direction","type":"uint8"}],"name":"placeShip","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"playerName_","type":"string"}],"name":"checkIfWon","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"x","type":"uint8"},{"name":"y","type":"uint8"}],"name":"fireShot","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"clearGame","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"playerName_","type":"string"}],"name":"returnBoard","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"a","type":"string"},{"name":"b","type":"string"}],"name":"compareStrings","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"}]);

var Battleship = BattleshipContract.at('0xf2792535ca11813e1375e8eed55ca27757745ee2');
console.log(Battleship);

console.log("Calling registerPlayer");
//Battleship.registerPlayer("Chris",function(error, result) {
$("#registerButton").click(function() {
  Battleship.registerPlayer($("#registerInput").val(),function(error,transHash) {
    if (!error) {
      $("#inst").html(transHash);
      console.log(transHash);
    } else {
      console.log(error);
    }
  });
});
$("#resetButton").click(function() {
  Battleship.resetGame(function(error,transHash) {
    if (!error) {
      console.log(transHash);
    } else {
      console.log(error);
    }
  });
});
//Battleship.setPlayer();
//  if (!error) {
    //-- $("#inst").html(result);
 //   console.log("Registered player");
//  } else {
 //   console.log("Didn't register players");
//    console.log(error);
 // }
//});
//--
console.log("Calling returnPlayers");
Battleship.returnPlayers(function(error, result) {
  if (!error) {
    $("#playerName").html(result);
    console.log("Returned players");
  } else {
    console.log("Didn't return players");
    console.log(error);
  }
});
