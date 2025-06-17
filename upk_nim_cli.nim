import cligen
import which
import tables
import osproc
import strutils
import os
import streams

proc getInstallCommand(manager, package: string): seq[string] =
  var commands = initTable[string, seq[string]]()
  commands["pacman"] = @["sudo", "pacman", "-S", package, "--noconfirm"]
  commands["yay"] = @["yay", "-S", package, "--noconfirm"]
  commands["apt"] = @["sudo", "apt", "install", package, "-y"]
  commands["dnf"] = @["sudo", "dnf", "install", package, "-y"]
  commands["yum"] = @["sudo", "yum", "install", package, "-y"]
  commands["zypper"] = @["sudo", "zypper", "install", "-y", package]
  commands["apk"] = @["sudo", "apk", "add", package]
  #yay -S librewolf --noconfirm --nocleanmenu --nodiffmenu maybe later
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
  stdout.flushFile()
  
  if manager in ["yay", "paru"]:
    let exitCode = execCmd(command.join(" "))
    return exitCode == 0
  else:
    let process = startProcess(
      command[0], 
      args = command[1..^1], 
      options = {poUsePath, poStdErrToStdOut}
    )
    
    let outputStream = process.outputStream
    
    while process.running or not outputStream.atEnd:
      try:
        let line = outputStream.readLine()
        echo line
        stdout.flushFile()
      except IOError, OSError:
        break
    
    let exitCode = process.waitForExit()
    process.close()
    
    return exitCode == 0

proc install(args: seq[string]) =
  var managers: seq[string] = @[]
  for m in ["pacman", "yay", "apt", "dnf", "yum", "zypper", "apk"]:
    if which(m) != "":
      managers.add(m)

  if managers.len == 0:
    echo "No known package manager detected."
    quit(1)

  echo "Detected package managers: ", managers.join(", ")

  var pkg = ""
  if args.len > 0:
    pkg = args[0]
  else:
    stdout.write("Enter the package name to install: ")
    stdout.flushFile()
    pkg = readLine(stdin).strip()

  if pkg.len == 0:
    echo "No package name provided."
    quit(1)

  var success = false
  for manager in managers:
    if tryInstall(manager, pkg):
      echo "Successfully installed ", pkg, " using ", manager, "."
      success = true
      break
    else:
      echo "Failed with ", manager
  
  if not success:
    echo "Failed to install ", pkg, " with all detected managers."

when isMainModule:
  dispatch(install)