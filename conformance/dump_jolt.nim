import std/[os, osproc, strformat, strutils]

const
  ConformanceDir = parentDir(currentSourcePath())
  RepoRoot = ConformanceDir.parentDir().parentDir()
  JoltIncludeDir = RepoRoot / "jolty" / "JoltPhysics"
  JoltIssueReportingCpp = JoltIncludeDir / "Jolt" / "Core" / "IssueReporting.cpp"
  CppSource = ConformanceDir / "dump_jolt.cpp"
when defined(windows):
  const ExeName = "dump_jolt.exe"
else:
  const ExeName = "dump_jolt"

const
  ExePath = ConformanceDir / ExeName

proc quoteArg(value: string): string =
  if value.contains({' ', '\t', '"'}):
    "\"" & value.replace("\"", "\\\"") & "\""
  else:
    value

proc findCompiler(): string =
  let envCompiler = getEnv("CXX")
  if envCompiler.len > 0:
    return envCompiler

  for candidate in ["g++.exe", "clang++.exe", "g++", "clang++", "c++.exe", "c++"]:
    if findExe(candidate).len > 0:
      return candidate

  raise newException(OSError, "Could not find a C++ compiler. Set CXX or install g++ / clang++.")

proc runOrQuit(command: string) =
  let (output, exitCode) = execCmdEx(command)
  if output.len > 0:
    stdout.write output
  if exitCode != 0:
    quit exitCode

proc main() =
  let compiler = findCompiler()
  let compileCmd = [
    quoteArg(compiler),
    "-std=c++17",
    "-DJPH_DOUBLE_PRECISION",
    "-I" & quoteArg(JoltIncludeDir),
    quoteArg(CppSource),
    quoteArg(JoltIssueReportingCpp),
    "-o",
    quoteArg(ExePath)
  ].join(" ")

  echo fmt"Building {CppSource} with {compiler}"
  runOrQuit(compileCmd)
  runOrQuit(quoteArg(ExePath))

main()
