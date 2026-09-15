"""Tests for the non-operational worker entry point."""

from _pytest.capture import CaptureFixture

from quantbench_worker.__main__ import main


def test_main_reports_no_operational_authority(capsys: CaptureFixture[str]) -> None:
    """The command reports identity only and starts no trading runtime."""
    main()

    assert "operational trading authority: none" in capsys.readouterr().out
