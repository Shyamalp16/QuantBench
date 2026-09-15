"""Foundation invariants for the empty worker package."""

from quantbench_worker import HAS_OPERATIONAL_TRADING_AUTHORITY, __version__


def test_worker_has_no_operational_authority() -> None:
    """The Phase 1 worker must remain broker-independent."""
    assert HAS_OPERATIONAL_TRADING_AUTHORITY is False
    assert __version__ == "0.1.0"
