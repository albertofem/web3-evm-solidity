const TestForwarder = artifacts.require("TestForwarder");

module.exports = async function (deployer) {
    let instance = await deployer.deploy(TestForwarder)
};