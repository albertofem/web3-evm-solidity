const { deployProxy } = require('@openzeppelin/truffle-upgrades');

const Token721 = artifacts.require("Token721");
const TestForwarder = artifacts.require("TestForwarder");

module.exports = async function (deployer) {
    const forwarder = await TestForwarder.deployed();

    const instance = await deployProxy(
        Token721,
        [deployer.from, "Test", "TEST"],
        {
            deployer: deployer,
            constructorArgs: [forwarder.address]
        }
    );

    console.log('Deployed 721 first implementation and proxy', instance.address);
};