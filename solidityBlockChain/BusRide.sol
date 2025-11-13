// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20;

// Kept for reference/testing already added in repo
contract SimpleStorage{
    uint256 private storedNumber;

    function store(uint256 _number) public {
        storedNumber = _number;
    }

    function retrieve() public view returns (uint256){
        return storedNumber;
    }
}

// A simple Bus Ride escrow contract between a specific rider and the bus operator.
contract BusRide {
    enum Status { None, Booked, Completed, Refunded }

    struct Booking {
        Status status;
        uint256 amount;
    }

    address payable public operator = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4); // Fixed operator address
    address public constant passenger = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2; // Fixed passenger address

    uint256 public fare;         // exact amount riders must send per seat
    uint256 public capacity;     // max seats available
    uint256 public seatsBooked;  // current seats booked
    uint256 public cancelWindow; // seconds before scheduled time riders may cancel (kept for logic, but not linked to a departure)

    mapping(address => Booking) public bookings; // rider => booking

    event Booked(address indexed rider, uint256 amount);
    event Completed(address indexed rider, uint256 amountToOperator);
    event Refunded(address indexed rider, uint256 amount);
    event RideParamsUpdated(uint256 fare, uint256 capacity, uint256 cancelWindow);

    modifier onlyOperator() {
        require(msg.sender == operator, "Not operator");
        _;
    }

    constructor(
        uint256 _fare,
        uint256 _capacity,
        uint256 _cancelWindow
    ) {
        require(_fare > 0, "Fare must be > 0");
        require(_capacity > 0, "Capacity must be > 0");
        fare = _fare;
        capacity = _capacity;
        cancelWindow = _cancelWindow == 0 ? 3600 : _cancelWindow; // default 1h
    }

    function bookSeat() external payable {
        require(msg.sender == passenger, "Only registered passenger allowed");
        require(seatsBooked < capacity, "Ride full");
        Booking storage b = bookings[msg.sender];
        require(b.status == Status.None || b.status == Status.Refunded, "Already booked");
        require(msg.value == fare, "Send exact fare");
        bookings[msg.sender] = Booking({status: Status.Booked, amount: msg.value});
        seatsBooked += 1;
        emit Booked(msg.sender, msg.value);
    }

    function completeRide(address rider) external onlyOperator {
        Booking storage b = bookings[rider];
        require(b.status == Status.Booked, "Not booked");
        b.status = Status.Completed;
        uint256 amount = b.amount;
        (bool ok, ) = operator.call{value: amount}("");
        require(ok, "Transfer failed");
        emit Completed(rider, amount);
    }

    // Rider cancels before cutoff window
    function cancelByRider() external {
        Booking storage b = bookings[msg.sender];
        require(b.status == Status.Booked, "Not booked");
        // No departureTime check needed
        uint256 amount = b.amount;
        b.status = Status.Refunded;
        seatsBooked -= 1;
        (bool ok, ) = payable(msg.sender).call{value: amount}("");
        require(ok, "Refund failed");
        emit Refunded(msg.sender, amount);
    }

    // Operator can refund a rider (e.g. ride cancelled)
    function cancelByOperator(address rider) external onlyOperator {
        Booking storage b = bookings[rider];
        require(b.status == Status.Booked, "Not booked");
        uint256 amount = b.amount;
        b.status = Status.Refunded;
        seatsBooked -= 1;
        (bool ok, ) = payable(rider).call{value: amount}("");
        require(ok, "Refund failed");
        emit Refunded(rider, amount);
    }

    function updateRide(
        uint256 _fare,
        uint256 _capacity,
        uint256 _cancelWindow
    ) external onlyOperator {
        require(_fare > 0, "Fare must be > 0");
        require(_capacity >= seatsBooked, "Capacity < booked");
        fare = _fare;
        capacity = _capacity;
        if (_cancelWindow != 0) cancelWindow = _cancelWindow;
        emit RideParamsUpdated(fare, capacity, cancelWindow);
    }

    function getBooking(address rider) external view returns (Status status, uint256 amount) {
        Booking memory b = bookings[rider];
        return (b.status, b.amount);
    }

    receive() external payable { revert("Direct payments not allowed"); }
    fallback() external payable { revert("No fallback"); }
}