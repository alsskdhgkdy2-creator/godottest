"""Restore the verified web engine from the matching Godot template."""
import gzip
import hashlib
from pathlib import Path
import sys
import zipfile

EXPECTED = "fc74679e3b97f76878947fcd4fbe1268cbfa6188182a2e33bbc3f5dc9bfa57d0"

def main():
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python3 tools/prepare_web_engine.py web_nothreads_release.zip")
    with zipfile.ZipFile(sys.argv[1]) as archive:
        wasm = archive.read("godot.wasm")
    if hashlib.sha256(wasm).hexdigest() != EXPECTED:
        raise SystemExit("Template differs from the verified Godot 4.7.2 web_nothreads release engine")
    target = Path(__file__).resolve().parents[1] / "dist" / "engine-v2.wasm.gz"
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(gzip.compress(wasm, mtime=0))
    print(f"Restored {target.name}: {target.stat().st_size} bytes")

if __name__ == "__main__":
    main()
