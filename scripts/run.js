const main = async () => {
  const fanClubNFTContractFactory = await hre.ethers.getContractFactory(
    'FanClubNFT'
  );
  const fanClubNFTContract = await fanClubNFTContractFactory.deploy();
  await fanClubNFTContract.deployed();
  console.log('Contract deployed to:', fanClubNFTContract.address);

  txn = await fanClubNFTContract.addArtist("Prateek Kuhaad", "image.com", "Singer");
  await txn.wait();
  

  txn = await fanClubNFTContract.addArtist("Adele", "image.com", "Singer");
  await txn.wait();
  const artists = await fanClubNFTContract.getAllArtists();
  console.log("Artists --->" , artists);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
