import re
import subprocess
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
GRAMMAR = ROOT.parent / "tree-sitter-peeper"
CLI = GRAMMAR / "node_modules/.bin/tree-sitter"


class StructLiteralTests(unittest.TestCase):
    def test_example_and_queries(self):
        subprocess.run([CLI, "parse", "--quiet", ROOT / "main.peep"], cwd=GRAMMAR, check=True)
        for query in sorted((ROOT / "languages/peeper").glob("*.scm")):
            with self.subTest(query=query.name):
                subprocess.run(
                    [CLI, "query", "--quiet", query, ROOT / "main.peep"],
                    cwd=GRAMMAR,
                    check=True,
                )

    def test_literal_captures(self):
        cases = [
            ("Point.{ x = 1 }", "Point", "type"),
            ("Box<i32>.{ x = 1 }", "Box", "type"),
            ("geometry::Point.{ x = 1 }", "Point", "type"),
            ("pkg::geometry::Point.{ x = 1 }", "Point", "type"),
            ("pkg::Box<i32>.{ x = 1 }", "Box", "type"),
            ("Outer<i32>::Inner.{ x = 1 }", "Inner", "type"),
            ("Outer<i32>::Inner<Point>.{ x = 1 }", "Inner", "type"),
            (".{ x = 1 }", "x", "property"),
            ("Result<i32>::Ok with .{ x = 1 }", "Ok", "constructor"),
            ("Result<i32>::Ok with Point.{ x = 1 }", "Ok", "constructor"),
            ("Result::Ok with .{ x = 1 }", "Ok", "constructor"),
            ("pkg::Result::Ok with .{ x = 1 }", "Ok", "constructor"),
            ("Result<i32>::Pending", "Pending", "constructor"),
            ("pkg::Result::Pending", "Pending", "constructor"),
        ]
        with tempfile.TemporaryDirectory(dir=ROOT / "test") as directory:
            source = Path(directory) / "literal.peep"
            for expression, name, capture in cases:
                with self.subTest(expression=expression):
                    source.write_text(f"fn main() {{ let value = {expression}; }}\n")
                    subprocess.run([CLI, "parse", "--quiet", source], cwd=GRAMMAR, check=True)
                    result = subprocess.run(
                        [CLI, "query", ROOT / "languages/peeper/highlights.scm", source],
                        cwd=GRAMMAR,
                        check=True,
                        capture_output=True,
                        text=True,
                    )
                    captures = re.findall(
                        r"capture: \d+ - ([\w.]+),[^\n]*text: `([^`]+)`", result.stdout
                    )
                    self.assertIn((capture, name), captures)
                    if "x =" in expression:
                        self.assertIn(("property", "x"), captures)
                        self.assertIn(("punctuation.delimiter", "."), captures)
                    if capture == "type":
                        self.assertNotIn(("constructor", name), captures)
                    if " with " in expression:
                        self.assertIn(("keyword", "with"), captures)


if __name__ == "__main__":
    unittest.main()
