# Contributing

Contributions welcome! Please follow these guidelines to ensure a smooth process.

## Testing

This project uses a bash-based testing suite located in the `test/` directory.

### Running Tests Locally

Before submitting a Pull Request, please run the full test suite locally:

```bash
bash test/test.sh
```

This script will:
1. Create a temporary vault in `test/vault`.
2. Run all test cases defined in `test/suite/*.sh`.
3. Clean up the temporary vault after execution.

### CI/CD

We have a GitHub Action configured to automatically run these tests on:
- Pushes to the `main` branch.
- Pull Requests targeting `main`.

Ensure your PR passes these checks.

## Code Style

- Follow existing bash scripting conventions.
- Ensure all new logic is covered by tests.
