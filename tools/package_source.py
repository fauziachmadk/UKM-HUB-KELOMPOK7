"""Fauzi: arsipkan file source yang dilacak Git, tanpa alat/cache/riwayat Git."""
from pathlib import Path
import subprocess
from zipfile import ZIP_DEFLATED, ZipFile

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT.parent / "KERANGKA-UKM-HUB.zip"
BLOCKED = {".git", "build", ".dart_tool", ".gradle", ".idea", "ephemeral", "__pycache__"}

if __name__ == "__main__":
    tracked = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT).decode("utf-8").split("\0")
    files = [Path(name) for name in tracked if name]
    if not files:
        raise SystemExit("Belum ada file source yang dilacak Git.")
    for relative in files:
        if BLOCKED.intersection(relative.parts) or relative.name == "local.properties":
            raise SystemExit(f"File lokal/cache tidak boleh masuk arsip: {relative}")
    with ZipFile(OUTPUT, "w", ZIP_DEFLATED) as archive:
        for relative in files:
            path = ROOT / relative
            if path.is_symlink():
                raise SystemExit(f"Symlink tidak boleh masuk arsip: {relative}")
            archive.write(path, (Path("KERANGKA-UKM-HUB") / relative).as_posix())
    with ZipFile(OUTPUT) as archive:
        assert archive.testzip() is None
        count = len(archive.namelist())
    print(f"{OUTPUT}: {count} file, {OUTPUT.stat().st_size} byte, CRC bersih.")
