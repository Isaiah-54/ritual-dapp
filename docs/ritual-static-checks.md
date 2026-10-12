# Ritual Static Checks (no testnet required)

From https://x.com/ritualfnd/status/2107548970373525760

1. **Where did the build stop?** — first `false` marker in `.ritual-build/progress.json`
2. **Did the agent read the overview?** — `files_read` includes overview skill
3. **Does it compile with via_ir?** — `via_ir = true` in `foundry.toml`
4. **Is every callback authenticated?** — `msg.sender == AsyncDelivery`
5. **Do your tests prove it?** — empty/late async path covered

Homework: test empty or late async result so the contract does not hang.
