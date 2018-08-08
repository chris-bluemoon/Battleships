var BattleshipGame = artifacts.require("BattleshipGame");

module.exports = function(deployer) {
  deployer.deploy(BattleshipGame);
}
