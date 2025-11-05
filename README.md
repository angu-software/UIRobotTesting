# UIRobotTesting

> NOTE: This project is still WIP
> I invite you to checkout the current state and leave feedback!


## Overview
UIRobotTesting is a Swift-based toolkit for writing robust, repeatable UI tests.


## Installation (Swift Package Manager)
1. In Xcode: File > Add Packages…
2. Enter repository URL: https://github.com/angu-software/UIRobotTesting
3. Add the package to your test target(s)

## Getting Started
1. Define a Screen Robot
   - Encapsulate UI elements and actions for a specific screen.
2. Write Tests
   - Compose robots to express user flows in a readable manner.
3. Run in CI
   - Enable headless simulators and collect artifacts (logs/screenshots).

### Example (conceptual)
- LoginRobot: enter username, enter password, tap login  
- HomeRobot: assert welcome message, navigate to feature  
- Test: `LoginRobot().login(as: "user", password: "secret").then(HomeRobot.self).assertWelcome()`

## Best Practices
- Keep robots small and focused per screen
- Prefer accessibility identifiers for stability
- Use timeouts and retries sparingly and consistently
- Capture screenshots on failure automatically
- Avoid hard sleeps; prefer wait conditions

## Contributing
- Open issues and PRs with clear context
- Follow Swift API Design Guidelines
- Add tests for new behaviors

## License
MIT (or your chosen license)
