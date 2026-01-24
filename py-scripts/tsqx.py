########## ## TSQX ##
##########

# Based on TSQX by Evan: https://github.com/vEnhance/dotfiles/blob/main/py-scripts/tsqx.py
# and by cjquines: https://github.com/cjquines/tsqx

import re
import sys
from typing import Any, Generator

GENERIC_PREAMBLE = r"""
size(%s);
defaultpen(fontsize(10pt));
usepackage("amsmath");
usepackage("amssymb");
settings.tex="pdflatex";
settings.outformat="pdf";

import geometry;
pair foot(pair P, pair A, pair B) { return foot(triangle(P, A, B).VA); }
pair IP(path p, path q) { return intersectionpoints(p, q)[0]; }
pair IP(path p, path q, int i) { return intersectionpoints(p, q)[i]; }
""".strip()


def generate_points(kind, n) -> list[str]:
    if kind == "triangle":
        return ["dir(110)", "dir(210)", "dir(330)"]
    elif kind == "regular":
        return [f"dir({(90 + i * 360 / n) % 360})" for i in range(n)]
    raise SyntaxError("Special command not recognized")


T_TOKEN = str | list[str] | list["T_TOKEN"]


ARITHMETIC_OPERATORS = {"plus": "+", "minus": "-", "mult": "*", "divide": "/"}


class Op:
    exp: T_TOKEN

    def _join_exp(self, exp: T_TOKEN, join_str: str) -> str:
        return join_str.join(self._emit_exp(e) for e in exp)

    def _emit_exp(self, exp: T_TOKEN) -> str:
        if not isinstance(exp, list):
            return exp
        if len(exp) == 1 or isinstance(exp[0], list):
            return self._join_exp(exp, "")
        if "," in exp:
            return f"({self._join_exp(exp, '').replace(',', ', ')})"

        head, *tail = exp
        if tail[0] in ["--", "..", "^^"]:
            return self._join_exp(exp, ", ")
        if (binop := ARITHMETIC_OPERATORS.get(str(head))) is not None:
            return f"({self._join_exp(tail, binop)})"
        return f"{head}({self._join_exp(tail, ', ')})"

    def emit_exp(self) -> str:
        res = self._emit_exp(self.exp)
        for j in ["--", "..", "^^"]:
            res = res.replace(f", {j}, ", j)
        return res

    def emit(self) -> str:
        raise Exception("Operation not recognized")

    def post_emit(self) -> str:
        return ""


class Blank(Op):
    def emit(self):
        return ""


class EscapedLine(Op):
    def __init__(self, exp: str):
        self.exp = exp

    def emit(self):
        # pass through with no processing
        return str(self.exp)


class Command(Op):
    def __init__(self, exp: T_TOKEN):
        self.exp = exp

    def emit(self):
        return self.emit_exp() + ";"


class Point(Op):
    def __init__(
        self,
        name: str,
        exp: T_TOKEN,
        dot=True,
        label: str | None = "",
        direction="",
    ):
        self.name = name
        self.exp = exp
        self.dot = dot
        self.label = name if label is not None else None
        if self.label:
            self.label = self.label.replace("_prime", "'")
            self.label = self.label.replace("_asterisk", r"^{\ast}")
        self.direction = direction or f"dir({name})"

    def emit(self) -> str:
        return f"pair {self.name} = {self.emit_exp()};"

    def post_emit(self):
        args = [self.name]
        if self.label:
            args = [f'"${self.label}$"', *args, self.direction]
        if self.dot:
            return f"dot({', '.join(args)});"
        if len(args) > 1:
            return f"label({', '.join(args)});"
        return ""


class Draw(Op):
    def __init__(
        self,
        exp: T_TOKEN,
        fill: str | None = None,
        outline: str | None = None,
    ):
        self.exp = exp
        self.fill = fill
        self.outline = outline

    def emit(self):
        exp = self.emit_exp()
        if self.fill:
            outline = self.outline or "defaultpen"
            return f"filldraw({exp}, {self.fill}, {outline});"
        elif self.outline:
            return f"draw({exp}, {self.outline});"
        else:
            return f"draw({exp});"


class Parser:
    def __init__(self):
        self.alias_map = {"": "dl", ":": "", ".": "d", ";": "l"}
        self.aliases = self.alias_map.keys() | self.alias_map.values()

    def tokenize(self, line: str) -> list[T_TOKEN]:
        line = line.strip() + " "
        for old, new in [
            # ~ and = are separate tokens
            ("~", " ~ "),
            ("=", " = "),
            (",", " , "),
            ("(", "( "),
            (")", " ) "),
            # spline joiners
            ("--", " --  "),
            ("..", " .. "),
            ("^^", " ^^ "),
            # no spaces around asymptote arithmetic
            (" +", "+"),
            ("+ ", "+"),
            ("- ", "-"),
            (" *", "*"),
            ("* ", "*"),
            # but slashes in draw ops should remain tokens
            (" / ", "  /  "),
            (" /", "/"),
            ("/ ", "/"),
            # ' not allowed in variable names
            ("'", "_prime"),
            ("&", "_asterisk"),
        ]:
            line = line.replace(old, new)
        return list(filter(None, line.split()))

    def parse_subexp(
        self,
        tokens: list[T_TOKEN],
        idx: int,
        func_mode=False,
    ) -> tuple[T_TOKEN, int]:
        token = tokens[idx]
        if token[-1] == "(":
            is_func = len(token) > 1
            res: list[T_TOKEN] = []
            idx += 1
            if is_func:
                res.append(token[:-1])
            while tokens[idx] != ")":
                exp, idx = self.parse_subexp(tokens, idx, is_func)
                res.append(exp)
            return list(filter(None, res)), idx + 1
        if token == "," and func_mode:
            return "", idx + 1
        return token, idx + 1

    def parse_exp(self, tokens: list[T_TOKEN]) -> T_TOKEN:
        res: list[T_TOKEN] = []
        idx = 0
        while idx != len(tokens):
            try:
                exp, idx = self.parse_subexp(tokens, idx)
                res.append(exp)
            except IndexError:
                raise SyntaxError(f"Unexpected end of line: {tokens}")
        return res

    def parse_special(
        self,
        tokens: list[T_TOKEN],
        comment: str,
    ) -> Generator[tuple[Op, str], None, None]:
        if not tokens:
            raise SyntaxError("Can't parse special command")
        head, *tail = tokens
        if comment:
            yield Blank(), comment
        if head in ["triangle", "regular"]:
            for name, exp in zip(tail, generate_points(head, len(tail))):
                assert isinstance(name, str)
                yield Point(name, [exp]), ""
            return
        else:
            raise SyntaxError("Special command not recognized")

    def parse_name(self, tokens: list[T_TOKEN]) -> tuple[str, dict[str, Any]]:
        if not tokens:
            raise SyntaxError("Can't parse point name")
        name, *rest = tokens
        assert isinstance(name, str)

        if rest and rest[-1] in self.aliases:
            *rest, opts = rest
            assert isinstance(opts, str)
        else:
            opts = ""
        opts = self.alias_map.get(opts, opts)
        options = {"dot": "d" in opts, "label": name if "l" in opts else None}

        if rest:
            dirs, *rest = rest
            assert isinstance(dirs, str)
            if m := re.fullmatch(r"([\d\.]+)R([\d\.]+)", dirs):
                options["direction"] = f"{m.groups()[0]}*dir({m.groups()[1]})"
            elif dir_pairs := re.findall(r"([\d\.]+)([A-Z]+)", dirs):
                options["direction"] = "+".join(f"{n}*plain.{w}" for n, w in dir_pairs)
            elif m := re.fullmatch(r"[\d\.]+", dirs):
                options["direction"] = f"dir({dirs})"
            elif re.fullmatch(r"[NESW]+", dirs):
                options["direction"] = f"plain.{dirs}"
            else:
                rest.append(dirs)
        else:
            options["direction"] = f"dir({name})"

        if rest:
            raise SyntaxError("Can't parse point name")
        return name, options

    def parse_draw(self, tokens: list[T_TOKEN]):
        try:
            idx = tokens.index("/")
            fill_ = tokens[:idx]
            outline_ = tokens[idx + 1 :]
        except ValueError:
            fill_ = []
            outline_ = tokens

        assert all(isinstance(_, str) for _ in outline_)
        outline: list[str] = [
            str(_) for _ in outline_
        ]  # this is idiotic, what did i miss?

        fill: list[str] = []
        for pen in fill_:
            assert isinstance(pen, str)
            if re.fullmatch(r"\d*\.?\d*", pen):
                fill.append(f"opacity({pen})")
            else:
                fill.append(pen)

        return {"fill": "+".join(fill), "outline": "+".join(outline)}

    def parse(self, line: str) -> Generator[tuple[Op, str], None, None]:
        # escape sequence
        if line.startswith("!"):
            yield EscapedLine(line[1:].strip()), ""
            return

        if "#" in line:
            line, comment = line.split("#", 1)
        else:
            comment = ""

        tokens = self.tokenize(line)
        if not tokens:
            yield Blank(), comment
            return
        # special
        if tokens[0] == "~":
            yield from self.parse_special(tokens[1:], comment)
            return
        # point
        try:
            idx = tokens.index("=")
            name, options = self.parse_name(tokens[:idx])
            exp = self.parse_exp(tokens[idx + 1 :])
            yield Point(name, exp, **options), comment

            return
        except ValueError:
            pass
        # draw
        try:
            idx = tokens.index("/")
            exp = self.parse_exp(tokens[:idx])
            options = self.parse_draw(tokens[idx + 1 :])
            yield Draw(exp, **options), comment
            return
        except ValueError:
            pass
        # command
        exp = self.parse_exp(tokens)
        yield Command(exp), comment
        return


def main():
    from argparse import ArgumentParser

    argparser = ArgumentParser(description="Generate Asymptote code.")
    argparser.add_argument(
        "fname",
        help="Read from file rather than stdin.",
        metavar="filename",
        nargs="?",
        default="",
    )
    argparser.add_argument(
        "-p",
        "--pre",
        help="Adds a preamble.",
        action="store_true",
        dest="preamble",
        default=False,
    )
    argparser.add_argument(
        "-s",
        "--size",
        help="Set image size in preamble.",
        action="store",
        dest="size",
        default="8cm",
    )
    argparser.add_argument(
        "-t",
        "--terse",
        help="Hide the TSQX source",
        action="store_true",
        dest="terse",
        default=False,
    )
    args = argparser.parse_args()

    with open(args.fname, "r") if args.fname else sys.stdin as stream:
        lines = stream.readlines()
    parser = Parser()
    opcs = [opc for line in lines for opc in parser.parse(line)]

    if args.preamble:
        print(GENERIC_PREAMBLE % args.size)
        print()

    for op, comment in opcs:
        print(op.emit() + (f" //{c}" if (c := comment.rstrip()) else ""))
    print()

    for op, comment in opcs:
        if out := op.post_emit():
            print(out)

    if not args.terse:
        print()
        print(r"/* --------------------------TSQX Source----------------------------+")
        for line in lines:
            print(line.strip())
        print(r"*/")


if __name__ == "__main__":
    main()
