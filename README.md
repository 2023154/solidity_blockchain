# BusRide Remix Tutorial

This repository is trimmed for Remix-only usage. No Hardhat, no Node scripts. Just the Solidity contract you can copy or import into Remix.

## Files
`contracts/BusRide.sol` – Simple one-passenger bus ride escrow example.

## Contract Summary
Fixed operator and passenger addresses. Passenger books exactly one seat by paying the fare. Operator can complete the ride and receive funds. Either side can trigger refunds depending on flow.

### Constructor
`BusRide(uint256 fareWei, uint256 capacity, uint256 cancelWindowSeconds)`
- `fareWei`: Exact seat price.
- `capacity`: Max seats (single passenger still restricted by address, but allows >1 seatsBooked logic if extended later).
- `cancelWindowSeconds`: Time window logic placeholder (not tied to departure timestamp in this simplified version).

### Main Functions
- `bookSeat()` payable: Passenger sends exactly `fare`.
- `completeRide(address rider)`: Operator marks rider completed; transfers booking amount to operator.
- `cancelByRider()`: Passenger refunds their fare (before completion).
- `cancelByOperator(address rider)`: Operator refunds passenger (e.g. cancellation).
- `updateRide(fare, capacity, cancelWindow)`: Operator can adjust parameters (capacity cannot drop below `seatsBooked`).
- `getBooking(address rider)` view: Returns booking status and amount.

### Events
`Booked`, `Completed`, `Refunded`, `RideParamsUpdated`.

### Status Enum
`None`, `Booked`, `Completed`, `Refunded`.

## Using in Remix
1. Open https://remix.ethereum.org
2. Add a new file named `BusRide.sol` and paste content from `contracts/BusRide.sol`.
3. Select compiler version `0.8.20` and compile.
4. In Deploy & Run, choose environment:
   - `Remix VM` for local testing
   - `Browser Wallet` to use MetaMask on a testnet
5. Provide constructor arguments (e.g. `fareWei = 1000000000000000`, `capacity = 1`, `cancelWindowSeconds = 1800`).
6. Deploy.
7. Set `Value` field = fare (`0.001 ETH` above example) then call `bookSeat()` from the passenger address.
8. Operator address switches account in MetaMask and calls `completeRide(passengerAddress)` to receive funds.
9. For refunds test `cancelByRider()` before completion or `cancelByOperator(passengerAddress)`.

## Manual Test Checklist
- Deploy in Remix VM, book once with passenger account, ensure `Booked` event fires.
- Call `completeRide(passenger)` from operator account and confirm operator balance increases.
- Reset deployment, book again, call `cancelByRider()` to verify refund path and `seatsBooked` decrement.
- Repeat with `cancelByOperator(passenger)` to ensure operator-triggered refunds also work.

## MetaMask Tips
- Switch accounts in MetaMask to test operator vs passenger.
- Use a testnet (Sepolia) and faucet ETH.
- If gas estimation fails, check that you send exactly `fare` for booking.

## Extending Later
When ready for multi-rider support, custom errors, or automated testing, you can reintroduce a Hardhat framework. For now this remains intentionally minimal.

## Disclaimer
Educational sample. Review and adjust before any production deployment.
