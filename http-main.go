package main

import (
  "flag"
  "fmt"
  "os"
)

func showManifest(file string){
  fmt.Println("show manifests: ", file)
}

// kelm apply -e dev ./prometheus # apply manifets
// kelm show -e dev ./prometheus  # show manifests
// kelm test -e dev ./prometheus  # --dry-run manifests

func main(){
  var (
    env string
    dir string
  )

  flags := flag.NewFlagSet("sub", flag.ExitOnError)
  flags.StringVar(&env, "env", "dev", "your cluster env")
  flags.StringVar(&env, "e"  , "dev", "your cluster env")
  flags.StringVar(&dir, "dir", "", "your manifests dir")
  flags.StringVar(&dir, "d"  , "", "your manifests dir")
  flags.Parse(os.Args[2:])

  fmt.Println("sub: ", os.Args())
  fmt.Println("env: ", env)
  fmt.Println("dir: ", dir)
}
