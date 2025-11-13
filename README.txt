PROJECT: BusRide dApp (Remix Quickstart)

Overview
- `BusRide.sol` escrows each rider’s fare until the operator completes or refunds.
- Events: `Booked`, `Completed`, `Refunded`.

Use Remix Only
1) Open Remix and load the workspace folder.
2) Compiler: select `0.8.20`, enable Auto compile, compile `solidityBlockChain/BusRide.sol`.
3) Deploy & Run:
	- Environment: `Remix VM (Shanghai)`
	- Contract: `BusRide`
	- Inputs:
	  - `_fare` (wei): e.g. `10000000000000000` (0.01 ETH)
	  - `_capacity`: e.g. `2`
	  - `_departureTime` (unix seconds): in browser console run `Math.floor(Date.now()/1000) + 3600` and paste the result
	  - `_cancelWindow` (seconds): e.g. `1800`
	- Click Deploy.
4) Book a seat:
	- Set Value to the exact fare (e.g., `0.01` and select `ether`, or `10000000000000000` with `wei`)
	- Call `bookSeat()`
5) Complete or refund:
	- As operator, call `completeRide(riderAddress)` to release funds
	- Or call `cancelByOperator(riderAddress)` to refund rider

Troubleshooting
- “Departure must be future”: use a future `_departureTime` from the console.
- UI timeouts: reload Remix, increase Settings → Request Timeout, or switch browser.
