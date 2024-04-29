import { viem } from "hardhat";
import { vars } from "hardhat/config";

async function main() {

  const WBTC = await viem.deployContract("WBTC");

  console.log(
    `deployed to ${WBTC.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
