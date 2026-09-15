"""Report foundation metadata without starting an analytical runtime."""

from quantbench_worker import HAS_OPERATIONAL_TRADING_AUTHORITY, __version__


def main() -> None:
    """Print the non-operational Phase 1 worker identity."""
    authority = "enabled" if HAS_OPERATIONAL_TRADING_AUTHORITY else "none"
    print(f"QuantBench worker {__version__}; operational trading authority: {authority}")


if __name__ == "__main__":
    main()
