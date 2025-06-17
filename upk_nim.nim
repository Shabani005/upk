import which
import tables
import osproc
import strutils

proc getInstallCommand(manager, package: string): seq[string] =
  var commands = initTable[string, seq[string]]()
  commands["pacman"] = @["sudo", "pacman", "-S", package, "--noconfirm"]
  commands["yay"] = @["yay", "-S", package, "--noconfirm"]
  commands["apt"] = @["sudo", "apt", "install", package, "-y"]
  commands["dnf"] = @["sudo", "dnf", "install", package, "-y"]
  commands["yum"] = @["sudo", "yum", "install", package, "-y"]
  commands["zypper"] = @["sudo", "zypper", "install", "-y", package]
  commands["apk"] = @["sudo", "apk", "add", package]

  if commands.hasKey(manager):
    return commands[manager]
  else:
    return @[]

proc tryInstall(manager, package: string): bool =
  let command = getInstallCommand(manager, package)
  if command.len == 0:
    echo "No install command for ", manager
    return false
  echo "Trying: ", command.join(" ")
  let (output, exitCode) = execCmdEx(command.join(" "))
  echo "OUTPUT:\n", output
  return exitCode == 0

proc main() =
  var managers: seq[string] = @[]
  for m in ["pacman", "yay", "apt", "dnf", "yum", "zypper", "apk"]:
    if which(m) != "":
      managers.add(m)

  if managers.len == 0:
    echo "No known package manager detected."
    quit(1)

  echo "Detected package managers: ", managers.join(", ")
  stdout.write("Enter the package name to install: ")
  let package = readLine(stdin).strip()

  var success = false
  for manager in managers:
    if tryInstall(manager, package):
      echo "Successfully installed ", package, " using ", manager, "."
      success = true
      break
    else:
      echo "Failed with ", manager
  if not success:
    echo "Failed to install ", package, " with all detected managers."

main()