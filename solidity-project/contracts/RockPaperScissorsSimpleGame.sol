pragma solidity >=0.4.22 <0.6.0;
 
contract RockPaperScissorsSimpleGame {
    enum Choice {Rock, Paper, Scissor}
    struct PlayerChoice {
        address player;
        Choice choice;
        bool isSet;
    }
    // Mapping to store the player choices
    mapping(address => PlayerChoice) public playerChoices;
    address[] public playerChoicesIndices;
    // Set to store the addresses of all players
    mapping(address => bool) public players;
    address[] public playersIndices;
    // Events to log the game results
    event GameResult(address winner, address loser);


    bool public isDraw;
    address public winner;
    bool public gameStart;
    
    // TODO: Other member data...
    
    constructor() public {
        isDraw = false;
        // TODO: other initialization
        gameStart = false;
    }
    
    function addPlayer() public payable {
        // TODO: a player register here
        // Note that a player cannot register twice
        require(!players[msg.sender], "Error: Player already registered");
        playersIndices.push(msg.sender);
        players[msg.sender] = true;
    }
    
    function input(Choice choice) public {
        // TODO: a player makes a choice here
         // Check if the player is a valid player
        require(!gameStart, "Error: input in the next round");
        require(players[msg.sender], "Error: Not a valid player");
        require(!playerChoices[msg.sender].isSet, "Error: input twice");
        // Store the player's choice
        playerChoicesIndices.push(msg.sender);      
        playerChoices[msg.sender] = PlayerChoice({player:msg.sender,choice:choice,isSet:true});
        uint256 playerCount = playerChoicesIndices.length;
        if (playerCount % 2 == 0) {
            winning();
        }
    }
    
    function winning() public {
        // TODO:
        // If the players make the same choice, set isDraw as true.
        // Otherwise, set winner as the winner's address
        // Get the number of players
        gameStart = true;
        address _winner;
        address _loser;
        for (uint i=0; i < playerChoicesIndices.length; i++){
            address player1 = playerChoices[playerChoicesIndices[i]].player;
            if (!players[player1]){
                continue;
            }
            for (uint j=0; j < playerChoicesIndices.length; j++){
                // Determine the winner and loser
                address player2 = playerChoices[playerChoicesIndices[j]].player;
                if (!players[player2]){
                    continue;
                }
                if (player1 == player2) {
                    continue;
                }

                if (playerChoices[player1].choice == Choice.Rock && playerChoices[player2].choice == Choice.Scissor ||
                    playerChoices[player1].choice == Choice.Scissor && playerChoices[player2].choice == Choice.Paper ||
                    playerChoices[player1].choice == Choice.Paper && playerChoices[player2].choice == Choice.Rock) {
                    _winner = player1;
                    _loser = player2;
                    break;
                }
                if (playerChoices[player1].choice == playerChoices[player2].choice) {
                    isDraw = true;
                    break;
                }               
            }
        }
        if (isDraw){
            emit GameResult(address(0), address(0));
        }else{
            emit GameResult(_winner, _loser);
            winner = _winner;
        }
        roundOver();
    }
 
    // TODO: Other helper functions
    function roundOver() private {
        for (uint i=0; i< playerChoicesIndices.length;i++){
            delete playerChoices[playerChoicesIndices[i]];
        }
        playerChoicesIndices = new address[](0);
        gameStart = false;
    }
}