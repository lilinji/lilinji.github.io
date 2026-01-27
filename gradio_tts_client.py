import argparse
import os
import re
import sys
import time
from pathlib import Path
from urllib.parse import urlparse
from urllib.request import urlopen
import shutil


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--server", default=os.getenv("GRADIO_SERVER", "http://172.16.8.75:8000/"))
    parser.add_argument("--api-name", default="/run_instruct")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--text")
    group.add_argument("--text-file")
    parser.add_argument("--lang", default="Chinese", choices=[
        "Auto", "Chinese", "English", "German", "Italian", "Portuguese", "Spanish", "Japanese", "Korean", "French", "Russian"
    ])
    parser.add_argument("--speaker", default="Dylan", choices=[
        "Serena", "Vivian", "Uncle Fu", "Ryan", "Aiden", "Ono Anna", "Sohee", "Eric", "Dylan"
    ])
    parser.add_argument("--instruct", default="")
    parser.add_argument("--output")
    parser.add_argument("--strip-markdown", action="store_true")
    return parser.parse_args()


def strip_markdown(text):
    text = re.sub(r"(?s)^---\s*\n.*?\n---\s*\n", "", text)
    text = re.sub(r"```[\s\S]*?```", "", text)
    text = re.sub(r"!\[([^\]]*)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", text)
    text = re.sub(r"`([^`]*)`", r"\1", text)
    text = re.sub(r"<[^>]+>", "", text)
    text = re.sub(r"^\s{0,3}#{1,6}\s*", "", text, flags=re.M)
    text = re.sub(r"^\s{0,3}>\s?", "", text, flags=re.M)
    text = re.sub(r"^\s*([-*+]|(\d+\.))\s+", "", text, flags=re.M)
    text = re.sub(r"\n{3,}", "\n\n", text)
    return text.strip()


def load_text(args):
    if args.text is not None:
        if args.text == "-":
            text = sys.stdin.read()
        else:
            text = args.text
        return strip_markdown(text) if args.strip_markdown else text
    text_path = Path(args.text_file)
    text = text_path.read_text(encoding="utf-8")
    if args.strip_markdown or text_path.suffix.lower() in {".md", ".markdown"}:
        return strip_markdown(text)
    return text


def build_default_output(source):
    parsed = urlparse(source)
    suffix = Path(parsed.path).suffix if parsed.path else ""
    if not suffix:
        suffix = ".wav"
    stamp = time.strftime("%Y%m%d_%H%M%S")
    return Path.cwd() / f"tts_output_{stamp}{suffix}"


def save_result(result_path, output_path):
    output_path = Path(output_path)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    if str(result_path).startswith("http://") or str(result_path).startswith("https://"):
        with urlopen(result_path) as response, open(output_path, "wb") as f:
            shutil.copyfileobj(response, f)
        return output_path
    src_path = Path(result_path)
    if not src_path.exists():
        raise FileNotFoundError(f"Result file not found: {result_path}")
    shutil.copyfile(src_path, output_path)
    return output_path


def main():
    try:
        from gradio_client import Client
    except Exception as exc:
        print(f"gradio_client is required: {exc}", file=sys.stderr)
        sys.exit(1)

    args = parse_args()
    text = load_text(args)
    if not text.strip():
        print("Text is empty.", file=sys.stderr)
        sys.exit(1)

    client = Client(args.server)
    result = client.predict(
        text=text,
        lang_disp=args.lang,
        spk_disp=args.speaker,
        instruct=args.instruct,
        api_name=args.api_name,
    )

    output_value = result[0] if isinstance(result, (list, tuple)) else result
    output_path = Path(args.output) if args.output else build_default_output(str(output_value))
    saved_path = save_result(output_value, output_path)

    status = result[1] if isinstance(result, (list, tuple)) and len(result) > 1 else ""
    print(str(saved_path))
    if status:
        print(status)


if __name__ == "__main__":
    main()
