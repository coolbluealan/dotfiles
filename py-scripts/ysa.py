import argparse
import multiprocessing
import re
import sys

PREAMBLE = r"""
defaultpen(fontsize(10pt));
size(%s);
usepackage("amsmath");
usepackage("amssymb");
settings.tex="pdflatex";
settings.outformat="pdf";

import geometry;
pair foot(pair P, pair A, pair B) { return foot(triangle(P, A, B).VA); }
pair IP(path p, path q) { return intersectionpoints(p, q)[0]; }
pair IP(path p, path q, int i) { return intersectionpoints(p, q)[i]; }
path CR(pair O, pair A) { return circle(O, abs(O-A)); }
""".strip()

LPC = tuple[str, str, str]


def tokenize(line: str) -> list[str]:
    for old, new in [
        # syntax
        ("=", " = "),
        ("(", "( "),
        (")", " ) "),
        # variable names
        ("'", "_prime"),
        ("&", "_asterisk"),
    ]:
        line = line.replace(old, new)
    return list(filter(None, line.split()))


def parse_subexp(tokens: list[str], idx: int) -> tuple[str, int]:
    token = tokens[idx]
    idx += 1
    if token[-1] == "(":
        args = []
        while tokens[idx] != ")":
            exp, idx = parse_subexp(tokens, idx)
            args.append(exp)

        if len(token) > 1 and token[-2].isalpha():
            res = ",".join(args)
            for op in ["+", "-", "*", "/"]:
                res = res.replace("," + op, op)
        else:
            res = "".join(args)

        return token + res + ")", idx + 1
    return token, idx


def parse_exp(tokens: list[str]) -> str:
    if len(tokens) > 1 and all(re.fullmatch(r"[\w'\"]+", token) for token in tokens):
        return f"{tokens[0]}({', '.join(tokens[1:])})"

    res = ""
    idx = 0
    while idx != len(tokens):
        try:
            exp, idx = parse_subexp(tokens, idx)
            res += exp
        except IndexError:
            raise SyntaxError(f"Unexpected end of line: {tokens}")
    return res.replace(",", ", ")


def point(tokens: list[str], exp: str, comment: str) -> LPC:
    DIR = {"": "dl", ":": "", ".": "d", ";": "l"}
    if not tokens:
        raise SyntaxError("Can't parse point name")
    name, *rest = tokens
    assert isinstance(name, str)

    if rest and rest[-1] in DIR:
        *rest, opts = rest
        assert isinstance(opts, str)
    else:
        opts = ""
    options = DIR[opts]

    if rest:
        dirs, *rest = rest
        if rest:
            raise SyntaxError("Can't parse point name")
        assert isinstance(dirs, str)

        NUM = r"(-?\d*\.?\d+)"
        if m := re.fullmatch(f"{NUM}R{NUM}", dirs):
            dir = f"{m.groups()[0]}*dir({m.groups()[1]})"
        elif dir_pairs := re.findall(f"{NUM}([A-Z]+)", dirs):
            dir = "+".join(f"{r}*plain.{d}" for r, d in dir_pairs)
        elif m := re.fullmatch("[NESW]+", dirs):
            dir = f"plain.{dirs}"
        elif m := re.fullmatch(NUM, dirs):
            dir = f"dir({dirs})"
        else:
            raise SyntaxError("Can't parse point name")
    else:
        dir = f"dir({name})"

    args = [name]
    if "l" in options:
        label = name.replace("_prime", "'").replace("_asterisk", r"^\ast")
        args = [f'"${label}$"', name, dir]
    if "d" in options:
        post = f"dot({', '.join(args)});"
    elif options:
        post = f"label({', '.join(args)});"
    else:
        post = ""
    return f"pair {name} = {exp};", post, comment


def draw(tokens: list[str], exp: str, comment: str) -> LPC:
    try:
        idx = tokens.index(";")
        fill = tokens[:idx]
        outline = tokens[idx + 1 :]
    except ValueError:
        fill = []
        outline = tokens
    fill = [
        f"opacity({pen})" if re.fullmatch(r"\d*\.?\d*", pen) else pen for pen in fill
    ]

    fill = "+".join(fill)
    outline = "+".join(outline)
    if fill:
        outline = outline or "defaultpen"

    return (
        f"filldraw({exp}, {fill}, {outline});"
        if fill
        else f"draw({exp}, {outline});"
        if outline
        else f"draw({exp});",
        "",
        "",
    )


def parse(line: str) -> LPC:
    # escape
    if line.startswith("!"):
        return line[1:], "", ""

    if "#" in line:
        line, comment = line.split("#", 1)
    else:
        comment = ""
    tokens = tokenize(line)

    # blank
    if not tokens:
        return "", "", comment

    # point
    try:
        idx = tokens.index("=")
        return point(
            tokens[:idx],
            parse_exp(tokens[idx + 1 :]),
            comment,
        )
    except ValueError:
        pass

    # draw
    try:
        idx = tokens.index(";")
        return draw(
            tokens[idx + 1 :],
            parse_exp(tokens[:idx]),
            comment,
        )
    except ValueError:
        pass

    # command
    return parse_exp(tokens) + ";", "", comment


def main():
    argparser = argparse.ArgumentParser(description="Generate Asymptote code.")
    argparser.add_argument(
        "filename",
        help="Read from file instead of stdin.",
        nargs="?",
        default="",
    )
    argparser.add_argument(
        "-p",
        "--preamble",
        help="Add preamble.",
        action="store_true",
    )
    argparser.add_argument(
        "-s",
        "--size",
        help="Set output size in preamble.",
        default="8cm",
    )
    argparser.add_argument(
        "-y",
        "--ysa",
        help="Add YSA source",
        action="store_true",
    )
    args = argparser.parse_args()

    with open(args.filename, "r") if args.filename else sys.stdin as stream:
        lines = stream.readlines()
    lines = [line.strip() for line in lines]
    with multiprocessing.Pool() as pool:
        lpcs = pool.map(parse, lines)

    if args.preamble:
        print(PREAMBLE % args.size)
        print()

    for line, post, comment in lpcs:
        print(line + (f" //{comment}" if comment else ""))
    print()
    for line, post, comment in lpcs:
        if post:
            print(post)

    if args.ysa:
        print()
        print("/* ----- YSA SOURCE -----")
        for line in lines:
            print(line)
        print("*/")


if __name__ == "__main__":
    main()
