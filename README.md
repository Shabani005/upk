
**upk_nim** is a simple, cross-distro package installer written in Nim. It detects your system's available package managers and attempts to install a package using the first one it finds.

## Features

- **Automatic detection** of popular Linux package managers: `pacman`, `yay`, `apt`, `dnf`, `yum`, `zypper`, `apk`
- **Non-interactive installation** (no prompts)
- **Simple CLI interface**
- **Statically compiled** for portability

## Usage

1. **Download** the latest release from [GitHub Releases](https://github.com/yourusername/yourrepo/releases).
2. **Run** the binary:

   ```sh
   ./upk_nim
   ```

3. **Enter the package name** when prompted.

   ```
   Detected package managers: apt, yum
   Enter the package name to install: curl
   Trying: sudo apt install curl -y
   OUTPUT:
   ...
   Successfully installed curl using apt.
   ```

## Compilation

To build from source, you need [Nim](https://nim-lang.org/) installed.

**Static build (recommended for portability):**

```sh
nim c -d:release --passL:-static upk_nim.nim
```

This will produce a statically linked binary named `upk_nim`.

## How it works

- Detects which package managers are available on your system.
- Prompts for a package name.
- Tries to install the package using each detected manager, in order.
- Stops at the first successful installation.

## Supported Package Managers

- `pacman` (Arch Linux)
- `yay` (AUR helper for Arch)
- `apt` (Debian/Ubuntu)
- `dnf` (Fedora)
- `yum` (CentOS/RHEL)
- `zypper` (openSUSE)
- `apk` (Alpine Linux)

## License

MIT

---

**Note:**  
- You may need to run the binary as root or with `sudo` depending on your system and package manager.
- If you encounter issues, please open an issue on the [GitHub repository](https://github.com/Shabani005/upk).
