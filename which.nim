# which.nim
import os, strutils
when defined(posix):
  import posix

proc isExecutable(path: string): bool =
  when defined(posix):
    return posix.access(path, posix.X_OK) == 0
  else:
    return fileExists(path)

proc which*(cmd: string): string = 
  let pathEnv = getEnv("PATH")
  let paths = pathEnv.split(PathSep)
  when defined(windows):
    let exts = getEnv("PATHEXT").split(';')
  else:
    let exts = [""]

  for dir in paths:
    for ext in exts:
      let candidate = dir / (cmd & ext)
      if fileExists(candidate) and isExecutable(candidate):
        return candidate
  return ""