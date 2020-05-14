package core

import (
  "fmt"
)

func Show(e string, p string, t []string) {
  fmt.Println("This is show subcommand func!")
  fmt.Println("env : ", e)
  fmt.Println("path: ", p)
  fmt.Println("tail: ", t)
}

func Apply(e string, p string, t []string) {
  fmt.Println("This is apply subcommand func!")
  fmt.Println("env : ", e)
  fmt.Println("path: ", p)
  fmt.Println("tail: ", t)
}

func Test(e string, p string, t []string){
  fmt.Println("This is apply subcommand func!")
  fmt.Println("env : ", e)
  fmt.Println("path: ", p)
  fmt.Println("tail: ", t)
}

