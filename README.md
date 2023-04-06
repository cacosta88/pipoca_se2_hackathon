<p align="center"><img src="./tictac1.png" alt="Alt text for the image" width="200" height="200"></p>

# The Origins of Tic Tac Toe

Tic Tac Toe, also known as Noughts and Crosses or Xs and Os, traces its roots back to ancient Egypt around 1300 BCE, where it was called "Terni Lapilli."   

The game was also played in the Roman Empire, and it became popular during the Middle Ages in England. This timeless game consists of a 3x3 grid where two players take turns marking their symbols, aiming to complete a row, column, or diagonal with three of their marks. Despite its simplicity, Tic Tac Toe has fascinated players for centuries, and it still captures the imagination of people around the world.

Tic Tac Toe, with its deep historical roots and simple yet captivating gameplay, presents an interesting opportunity for integration with blockchain technology. By leveraging the principles of game theory, this integration can introduce new layers of strategy, transparency, and security to the traditional game.

# Rant

As we tread into the era of blockchain technology, it is essential to pause and ponder the philosophical implications and connections between game theory, classic games like Tic Tac Toe, and the decentralized world that we are gradually embracing.

Game theory, a study of mathematical models of strategic decision-making, has long been the foundation of understanding complex interactions in economics, political science, and social systems. The essence of game theory lies in the analysis of decision-making and optimization of results for players, given certain rules and constraints. This analytical perspective brings a fresh lens to the blockchain realm, as blockchain technology seeks to establish trust, transparency, and fairness through decentralization.

Tic Tac Toe, a simple game with a finite set of possible moves and outcomes, may appear to be a trivial example. However, it captures the essence of strategic thinking and provides a window into the significance of game theory. Akin to blockchain technology, the game of Tic Tac Toe embodies the concepts of structure, transparency, and trust. Each player can foresee their opponent's moves, assess the state of the game board, and make informed decisions based on available information. Despite its simplicity, Tic Tac Toe encapsulates the fundamental principles of game theory, making it a fitting metaphor for the underpinnings of blockchain technology.

Blockchain technology is an embodiment of game theory in a digital realm. It is a decentralized, trustless network where the rules of the game are transparent, and each participant must strategize to optimize their outcome. The participants, akin to players in a game, interact with one another within the framework of a consensus algorithm. This algorithm, the rules of engagement in a blockchain, ensures that no single participant can manipulate the outcome. The network's participants, driven by individual incentives, work collectively to maintain the network's integrity and security.

The connection between game theory, Tic Tac Toe, and blockchain technology lies in their shared foundation of strategic decision-making, trust, and transparency. In Tic Tac Toe, the game board's state is transparent, allowing players to trust the game's fairness. Similarly, blockchain technology utilizes cryptographic techniques and consensus mechanisms to ensure transparency and trust in the system.

The blockchain paradox arises when we consider the duality of competition and collaboration that exists within the technology. While blockchain networks are based on individual incentives that encourage competition, they simultaneously foster a collaborative environment where participants work together to maintain the network's integrity. This delicate balance embodies the essence of game theory, where players must navigate strategic decision-making within a given set of rules to achieve the best possible outcomes.

As we continue to explore and adopt blockchain technology, understanding its philosophical roots in game theory and the lessons learned from classic games like Tic Tac Toe is crucial. In this digital age, the blockchain paradox challenges us to embrace the delicate balance between competition and collaboration, fostering a more equitable, transparent, and trustworthy world.

# Potential next steps from current draft version

Multiplayer Support: Expand the game to allow for more than two players, making the gameplay more challenging and engaging while further demonstrating the power of decentralized networks in supporting multiple participants.

Dynamic Boards: Introduce dynamically generated game boards of varying sizes and shapes, increasing the complexity of the game and showcasing the flexibility and adaptability of blockchain technology.

Wagering System: Implement a wagering system where players can stake cryptocurrency on the outcome of the game, promoting real-world value and incentivizing strategic gameplay.

Play-to-Earn Mechanics: Create a play-to-earn model that rewards players with native tokens or NFTs, aligning with the popular blockchain gaming trend and demonstrating the potential for blockchain-based economies.

Decentralized Leaderboards: Develop a decentralized leaderboard that tracks players' win/loss records, game statistics, and rankings, showcasing blockchain's ability to provide transparent and tamper-proof records.

NFT-Based Customization: Allow players to collect, trade, and utilize NFTs for in-game customization, such as unique game pieces, board designs, or special abilities, highlighting the integration of blockchain and gaming.

Smart Contract-based Tournaments: Organize smart contract-governed tournaments with automatic payouts and transparent entry requirements, demonstrating the power of blockchain in facilitating trustless interactions.

Cross-Chain Compatibility: Enable cross-chain gameplay, allowing players to connect and compete using different blockchain networks, showcasing the potential for interoperability in the blockchain ecosystem.

Social Features: Integrate social features such as friend lists, chat functions, and in-game collaboration tools, illustrating the power of decentralized networks in facilitating communication and social interaction.

Community Governance: Implement a decentralized governance system where players can vote on game updates, rule changes, or new features using their in-game assets, promoting a sense of community ownership and embodying the democratic principles of blockchain technology.

# Summary of smart contract `YourContract.sol`

The contract is a decentralized Tic Tac Toe game utilizing the Ethereum blockchain, where two players can participate, and the winner is rewarded with an ERC721 Non-Fungible Token (NFT) representing the final game state.  
It is built for the scaffold-eth 2 hackathon (2023) and authored by @justagamingnow.

Key contract components include:

Inheritance: The contract inherits from OpenZeppelin's ERC721 contract, leveraging its functionality to manage NFTs.  
Libraries: The contract uses the Strings library from OpenZeppelin for string manipulation.  
State Variables: It stores player addresses, game board, current player, move count, last move timestamp, nextTokenId, and mappings for tokenIdToSVG and playerStats.  
Structs: A struct named PlayerStats is defined to store games played, wins, and losses for each player.  
Events: Several events are defined, including GameStarted, MoveMade, GameWon, GameDraw, and GameTimeout.  
Modifiers: Modifiers are used to enforce certain conditions, such as onlyPlayers, notStarted, validMove, and notConsecutiveMove.  
Functions: The contract includes functions for joining a game, making a move, determining a winner, updating player stats, resetting the game, creating an SVG snapshot of the board, generating the SVG snapshot, and overriding the tokenURI function.  

# How to run locally with Scaffold-Eth 2

To run the Tic Tac Toe smart contract using Scaffold-Eth 2, follow the steps outlined below. These steps assume you have already cloned the repo and installed the necessary dependencies.

Scaffold-Eth 2 Repo: https://github.com/scaffold-eth/se-2

Replace the necessary files:

Copy the `00_deploy_your_contract.ts` file to `se-2\packages\hardhat\deploy`  
Copy the `YourContract.sol` file to `se-2\packages\hardhat\contracts`  
Copy the `ContractInteraction.tsx` and `ContractData.tsx` files to `se-2\packages\nextjs\components\example-ui`  

Run a local network in the first terminal:

`yarn chain`

This starts a local Ethereum network using Hardhat for testing and development.

In a second terminal, deploy the test contract:

`yarn deploy`
This deploys the Tic Tac Toe smart contract to the local network.

In a third terminal, start the NextJS app:

`yarn start`
Visit your app at http://localhost:3000 to interact with the smart contract using the example UI in the frontend.
