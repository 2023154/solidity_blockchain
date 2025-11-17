# BusRide Architecture (Remix-Only)

## Current Scope
- Single passenger + operator defined in the contract.
- Escrow: passenger calls `bookSeat()` with exact fare; funds stay in contract.
- Completion: operator calls `completeRide()` to receive passenger funds.
- Refund flows: passenger can call `cancelByRider()` before completion; operator may call `cancelByOperator()`.
- Parameters adjustable through `updateRide()`.

## Files
- `contracts/BusRide.sol` – the only Solidity source used in Remix.
- `README.md` – usage guide and deployment steps.

## State Machine
`None -> Booked -> (Completed OR Refunded)`

## Missing/Intentional Simplifications
- `cancelWindow` is not tied to a timestamp yet (placeholder).
- No multi-rider support or whitelist.
- Operator/passenger addresses are hard-coded for tutorial simplicity.

## Future Enhancements
- Allow constructor parameters for operator/passenger or a whitelist.
- Track departure time and enforce `cancelWindow`.
- Add events for cancellation reason (rider vs operator).
- Reintroduce a framework (Hardhat/Foundry) when automated tests or scripts are needed.
