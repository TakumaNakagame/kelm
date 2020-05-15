package core

import (
  "fmt"
)

func Show(e string, p string, t []string) {
  printVariables("show", e, p, t)
}

func Apply(e string, p string, t []string) {
  printVariables("apply", e, p, t)
}

func Test(e string, p string, t []string){
  printVariables("test", e, p, t)
}

func Delete(e string, p string, t []string){
  printVariables("delete", e, p, t)
}

func Recreate(e string, p string, t []string){
  printVariables("recreate", e, p, t)
}

func printVariables(cmd string, e string, p string, t []string){
  fmt.Println("subcommand: ", cmd)
  fmt.Println("env       : ", e)
  fmt.Println("path      : ", p)
  fmt.Println("tail      : ", t)
}