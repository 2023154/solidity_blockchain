const { expect } = require("chai");

describe("SimpleStorage", function () {
  it("stores and retrieves numbers", async function () {
    const SimpleStorage = await ethers.getContractFactory("SimpleStorage");
    const simple = await SimpleStorage.deploy();
    await simple.waitForDeployment();

    // default value should be 0
    expect(await simple.retrieve()).to.equal(0n);

    // store 42 and read back
    const tx1 = await simple.store(42);
    await tx1.wait();
    expect(await simple.retrieve()).to.equal(42n);

    // update to 7 and read back
    const tx2 = await simple.store(7);
    await tx2.wait();
    expect(await simple.retrieve()).to.equal(7n);
  });
});
