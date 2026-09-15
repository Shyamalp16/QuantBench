import "@testing-library/jest-dom/vitest";

import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { App } from "./App";

describe("App", () => {
  it("states that the foundation has no trading authority", () => {
    render(<App />);
    expect(
      screen.getByRole("heading", { name: "QuantBench" }),
    ).toBeInTheDocument();
    expect(
      screen.getByText(/operational trading authority: none/i),
    ).toBeInTheDocument();
  });
});
