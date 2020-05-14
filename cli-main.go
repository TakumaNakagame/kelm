package main

import (
  "flag"
  "fmt"
  "os"
  "github.com/TakumaNakagame/kelm/core"
)

func help(){
  fmt.Println("this is help")
}

// kelm apply -e dev ./prometheus # apply manifets
// kelm show -e dev ./prometheus  # show manifests
// kelm test -e dev ./prometheus  # --dry-run manifests

func main(){
  var (
    showEnv string
    showPath string

    applyEnv string
    applyPath string

    testEnv string
    testPath string
  )

  showCmd := flag.NewFlagSet("show", flag.ExitOnError)
  showCmd.StringVar(&showEnv, "env", "dev", "your cluster enviroument. DEFAULT: dev")
  showCmd.StringVar(&showEnv, "e"  , "dev", "your cluster enviroument. DEFAULT: dev")
  showCmd.StringVar(&showPath, "path", "", "manifests path")
  showCmd.StringVar(&showPath, "p"   , "", "manifests path")

  applyCmd:= flag.NewFlagSet("apply", flag.ExitOnError)
  applyCmd.StringVar(&applyEnv, "env", "dev", "your cluster enviroument. DEFAULT: dev")
  applyCmd.StringVar(&applyEnv, "e"  , "dev", "your cluster enviroument. DEFAULT: dev")
  applyCmd.StringVar(&applyPath, "path", "", "manifests path")
  applyCmd.StringVar(&applyPath, "p"   , "", "manifests path")

  testCmd:= flag.NewFlagSet("test", flag.ExitOnError)
  testCmd.StringVar(&testEnv, "env", "dev", "your cluster enviroument. DEFAULT: dev")
  testCmd.StringVar(&testEnv, "e"  , "dev", "your cluster enviroument. DEFAULT: dev")
  testCmd.StringVar(&testPath, "path", "", "manifests path")
  testCmd.StringVar(&testPath, "p"   , "", "manifests path")

  if len(os.Args) < 2{
    help()
    os.Exit(1)
  }

  switch os.Args[1]{
    case "show":
      showCmd.Parse(os.Args[2:])
      if len(showPath) == 0{
        fmt.Println("ERROR: require: path option")
        fmt.Println(showCmd.PrintDefaults())
        os.Exit(1)
      }
      core.Show(showEnv, showPath, showCmd.Args())
    case "apply":
      applyCmd.Parse(os.Args[2:])
      core.Apply(applyEnv, applyPath, applyCmd.Args())
    case "test":
      testCmd.Parse(os.Args[2:])
      core.Test(testEnv, testPath, testCmd.Args())
    default:
      fmt.Println("Undefind subcommand: ", os.Args[1])
      help()
  }
}
