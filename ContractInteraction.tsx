import { useState, useEffect } from "react";
import { List } from "antd";
import {
  useScaffoldContractRead,
  useScaffoldContractWrite,
  useScaffoldEventSubscriber,
} from "~~/hooks/scaffold-eth";
import { address } from "~~/components/scaffold-eth/";



export const ContractInteraction = () => {
  const [row, setRow] = useState(0);
  const [column, setColumn] = useState(0);
  const [board, setBoard] = useState([
    ["", "", ""],
    ["", "", ""],
    ["", "", ""],
  ]);
  const [status, setStatus] = useState("");

  

  const { data: player1 } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "player1",
  });

  const { data: player2 } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "player2",
  });

  const { data: currentPlayer } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "currentPlayer",
  });
  

  const { data: boardData } = useScaffoldContractRead({
    contractName: "YourContract",
    functionName: "board",
  });

  const joinGame = useScaffoldContractWrite({
    contractName: "YourContract",
    functionName: "joinGame",
  });

  const makeMove = useScaffoldContractWrite({
    contractName: "YourContract",
    functionName: "makeMove",
    args: [row, column],
  });

  useScaffoldEventSubscriber({
    contractName: "YourContract",
    eventName: "MoveMade",
    listener: (player, row, column) => {
      setBoard((prevBoard) => {
        const newBoard = [...prevBoard];
        newBoard[row][column] = player === player1 ? "X" : "O";
        return newBoard;
      });
    },
  });

  useEffect(() => {
    if (currentPlayer) {
      setStatus(`Player ${currentPlayer}'s turn`);
    } else {
      setStatus("Waiting for players...");
    }
  }, [currentPlayer]);

  const handleRowChange = (e) => {
    setRow(parseInt(e.target.value));
  };

  const handleColumnChange = (e) => {
    setColumn(parseInt(e.target.value));
  };

  useEffect(() => {
    if (boardData) {
      const newBoard = boardData.map((row) => {
        return row.map((cell) => (cell === 1 ? "X" : cell === 2 ? "O" : ""));
      });
      setBoard(newBoard);
      console.log("Updated board state:", newBoard);
    }
  }, [boardData]);

  useScaffoldEventSubscriber({
    contractName: "YourContract",
    eventName: "GameDraw",
    listener: () => {
      resetBoard();
    },
  });

  useScaffoldEventSubscriber({
    contractName: "YourContract",
    eventName: "GameWon",
    listener: () => {
      resetBoard();
    },
  });

  useScaffoldEventSubscriber({
    contractName: "YourContract",
    eventName: "GameTimeout",
    listener: () => {
      resetBoard();
    },
  });

  const resetBoard = () => {
    setBoard([
      ["", "", ""],
      ["", "", ""],
      ["", "", ""],
    ]);
  };

  return (
    <div className="flex flex-col w-full">
      <div className="flex flex-col mt-6 px-7 py-8 bg-base-200 opacity-80 rounded-2xl shadow-lg border-2 border-primary">
        <span className="text-4xl sm:text-6xl text-black">Tic Tac Toe </span>

        <div className="mt-8 flex flex-col sm:flex-row items-start sm:items-center gap-2 sm:gap-5">
          <input
            type="number"
            placeholder="Row"
            min="0"
            max="2"
            className="input font-bai-jamjuree w-full px-5 border border-primary text-lg sm:text-2xl placeholder-black uppercase"
            onChange={handleRowChange}
          />
          <input
            type="number"
            placeholder="Column"
            min="0"
            max="2"
            className="input font-bai-jamjuree w-full px-5 border border-primary text-lg sm:text-2xl placeholder-black uppercase"
            onChange={handleColumnChange}
          />
<button
  className="btn btn-primary rounded-full capitalize font-normal font-white w-24"
  onClick={async () => {
    console.log("Making move with row:", row, "and column:", column);
    await makeMove.writeAsync(); // Updated this line
  }}
>
  Make Move
</button>


        </div>

        <div className="mt-4">
          <span className="text-xl">{status}</span><br/>
          <span className="text-xl">Player 1: {player1}</span><br/>
          <span className="text-xl">Player 2: {player2}</span>
          
        </div>
       
     

        <div className="mt-8 grid grid-cols-3 gap-4">
          {board.map((row, rowIndex) => {
            return row.map((cell, colIndex) => (
              <div
                key={`${rowIndex}-${colIndex}`}
                className="w-16 h-16 flex justify-center items-center border-2 border-black"
              >
                {cell}
              </div>
            ));
          })}
        </div>

        <button
  className="btn btn-primary rounded-full capitalize font-normal font-white w-24 my-4"
  onClick={async () => {
    await joinGame.writeAsync(); 
  }}
>
  Join Game
</button>

        
        


      </div>
     
</div>
  );
}
