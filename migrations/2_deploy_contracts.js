module.exports = function(deployer) {
    var Mock721Collection = artifacts.require("./MockCollection.sol");
    deployer.deploy(Mock721Collection);
};