// Presenting a contract that lets two players engage in an epic battle of Tic Tac Toe,
// and rewards the winner with a custom NFT of the game board's final state.
// This build is for the scaffold-eth 2 hackathon (2023)
// Author: @justagamingnow

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// The contract inherits from the OpenZeppelin ERC721 contract.
contract YourContract is ERC721 {
    using Strings for uint256;

// Introducing our valiant players and the legendary game board.
    address public player1;
    address public player2;
    uint8[3][3] public board;
    uint8 public currentPlayer;
    uint256 public moveCount;
    uint256 public lastMoveTimestamp;

    uint256 private nextTokenId;
    mapping(uint256 => string) private tokenIdToSVG;

// Here lie the stats of our noble players.

    struct PlayerStats {
        uint256 gamesPlayed;
        uint256 wins;
        uint256 losses;
    }

    mapping(address => PlayerStats) public playerStats;

// A list of events that shall be etched into the blockchain's history.

    event GameStarted(address indexed player1, address indexed player2);
    event MoveMade(address indexed player, uint8 row, uint8 column);
    event GameWon(address indexed winner);
    event GameDraw();
    event GameTimeout(address indexed loser);

// The rules of engagement - only players, unstarted games, valid moves, and no consecutive moves.

    modifier onlyPlayers() {
        require(msg.sender == player1 || msg.sender == player2, "Not a valid player");
        _;
    }

    modifier notStarted() {
        require(player1 == address(0) || player2 == address(0), "Game has already started");
        _;
    }

    modifier validMove(uint8 row, uint8 column) {
        require(row >= 0 && row < 3 && column >= 0 && column < 3, "Invalid move position");
        require(board[row][column] == 0, "Position already occupied");
        _;
    }

    modifier notConsecutiveMove() {
        require((msg.sender == player1 && currentPlayer == 1) || (msg.sender == player2 && currentPlayer == 2), "Not your turn");
        _;
    }

// The birth of our Tic Tac Toe NFT contract.

    constructor() ERC721("TicTacToeNFT", "TTTNFT") {}

// Ahoy! A challenger approaches to join the fray!

    function joinGame() external {
        if (player1 != address(0) && player2 != address(0)) {
            if (block.timestamp > lastMoveTimestamp + 3 minutes) {
                address loser = currentPlayer == 1 ? player1 : player2;
                emit GameTimeout(loser);
                updatePlayerStatsAfterTimeout(loser);
                resetGame();
            } else {
                require(player1 == address(0) || player2 == address(0), "Game is in progress");
            }
        }

        require(player1 == address(0) || player2 == address(0), "Game is in progress");

        require(msg.sender != player1, "You have already joined this game");
        if (player1 == address(0)) {
            player1 = msg.sender;
        } else {
            player2 = msg.sender;
            currentPlayer = 1;
            lastMoveTimestamp = block.timestamp;
            emit GameStarted(player1, player2);
            updatePlayerStatsAfterJoin();
        }
    }

// A player dares to make a move on the battlefield.
  
  function makeMove(uint8 row, uint8 column) external onlyPlayers validMove(row, column) notConsecutiveMove {
        if (block.timestamp > lastMoveTimestamp + 3 minutes) {
            address loser = msg.sender;
            emit GameTimeout(loser);
            updatePlayerStatsAfterTimeout(loser);
            resetGame();
            return;
        }

        board[row][column] = currentPlayer;
        emit MoveMade(msg.sender, row, column);
        moveCount++;

        if (isWinner(row, column)) {
            address winner = msg.sender;
            emit GameWon(winner);
            updatePlayerStatsAfterWin(winner);
            resetGame();
        } else if (moveCount == 9) {
            emit GameDraw();
            updatePlayerStatsAfterDraw();
            resetGame();
        } else {
            currentPlayer = currentPlayer == 1 ? 2 : 1;
            lastMoveTimestamp = block.timestamp;
        }
    }

// The oracle that shall determine the victor.

    function isWinner(uint8 row, uint8 column) private view returns (bool) {
        uint8 value = board[row][column];

        if (board[row][0] == value && board[row][1] == value && board[row][2] == value) {
            return true;
        }

        if (board[0][column] == value && board[1][column] == value && board[2][column] == value) {
            return true;
        }

        if (row == column && board[0][0] == value && board[1][1] == value && board[2][2] == value) {
            return true;
        }

        if (row + column == 2 && board[0][2] == value && board[1][1] == value && board[2][0] == value) {
            return true;
        }

        return false;
    }

// A humble helper to identify the player's number.

    function getPlayerNumber(address player) private view returns (uint8) {
        if (player == player1) {
            return 1;
        } else if (player == player2) {
            return 2;
        } else {
            revert("Invalid player");
        }
    }

// Update player stats upon joining the game.

    function updatePlayerStatsAfterJoin() private {
        playerStats[player1].gamesPlayed++;
        playerStats[player2].gamesPlayed++;
    }

// Update player stats upon winning the game.
    
    function updatePlayerStatsAfterWin(address winner) private {
        address loser = winner == player1 ? player2 : player1;
        playerStats[winner].wins++;
        playerStats[loser].losses++;

        createSVGBoardSnapshotNFT(winner);
    }

// Update player stats upon a draw.

    function updatePlayerStatsAfterDraw() private {
        playerStats[player1].gamesPlayed--;
        playerStats[player2].gamesPlayed--;
    }

// Update player stats after a timeout.

    function updatePlayerStatsAfterTimeout(address loser) private {
    address winner = loser == player1 ? player2 : player1;
    playerStats[winner].wins++;
    if (playerStats[loser].losses > 0) {
        playerStats[loser].losses--;
    }
}

// Reset the game board for the next bout.

function resetGame() private {
    for (uint8 row = 0; row < 3; row++) {
        for (uint8 col = 0; col < 3; col++) {
            board[row][col] = 0;
        }
    }
    delete currentPlayer;
    delete moveCount;
    delete player1;
    delete player2;
    delete lastMoveTimestamp;
    currentPlayer = 1;
}

// Create an SVG snapshot of the board and mint an NFT as a trophy for the winner.

function createSVGBoardSnapshotNFT(address winner) private {
        uint256 tokenId = nextTokenId;
        nextTokenId++;

        string memory svg = generateSVGBoardSnapshot(winner);

        tokenIdToSVG[tokenId] = svg;

        _mint(msg.sender, tokenId);
    }

// Generate an SVG snapshot of the board to be minted as an NFT.

function generateSVGBoardSnapshot(address winner) private view returns (string memory) {
    string memory svgBoard = string(abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500" viewBox="0 0 500 500">',

        '<g>'
    ));

    for (uint8 row = 0; row < 3; row++) {
        for (uint8 col = 0; col < 3; col++) {
            if (board[row][col] == 1) {
                svgBoard = string(abi.encodePacked(svgBoard, '<circle cx="', Strings.toString(col * 100 + 50), '" cy="', Strings.toString(row * 100 + 50), '" r="40" fill="brown"/>'));
            } else if (board[row][col] == 2) {
                svgBoard = string(abi.encodePacked(svgBoard, '<rect x="', Strings.toString(col * 100), '" y="', Strings.toString(row * 100), '" width="100" height="100" fill="red"/>'));
            }
        }
    }

    // Add player addresses and winner crown
    svgBoard = string(abi.encodePacked(svgBoard,
        '<line x1="100" y1="0" x2="100" y2="300" stroke="black" stroke-width="5"/>',
        '<line x1="200" y1="0" x2="200" y2="300" stroke="black" stroke-width="5"/>',
        '<line x1="0" y1="100" x2="300" y2="100" stroke="black" stroke-width="5"/>',
        '<line x1="0" y1="200" x2="300" y2="200" stroke="black" stroke-width="5"/>',
        '<text x="150" y="310" fill="blue" font-size="10px" text-anchor="middle">Player 1: ', Strings.toHexString(uint160(player1)), '</text>',
        '<text x="150" y="320" fill="blue" font-size="10px" text-anchor="middle">Player 2: ', Strings.toHexString(uint160(player2)), '</text>',
        '<text x="150" y="350" fill="red" font-size="10px" text-anchor="middle">Winner: ', Strings.toHexString(uint160(winner)), '</text>',
        '<text x="150" y="340" fill="red" font-size="24px" text-anchor="middle">&#9812;</text></g></svg>' 
    ));

    return svgBoard;
}

// Render the token URI for an NFT based on its tokenId.
    
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist");

        string memory svg = tokenIdToSVG[tokenId];

        return string(abi.encodePacked("data:image/svg+xml;base64,", svg));
    }
}
