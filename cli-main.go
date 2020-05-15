package main

import (
	"flag"
	"fmt"
	"os"
	"github.com/TakumaNakagame/kelm/core"
)

func help() {
	fmt.Println("this is help")
}

func main() {
	var (
		env         string
		helmVersion int
		namespace   string
		name        string
	)

	showCmd := flag.NewFlagSet("show", flag.ExitOnError)
	showCmd.StringVar(&env, "env", "dev", "your cluster enviroument. DEFAULT: dev")
	showCmd.StringVar(&env, "e", "dev", "your cluster enviroument. DEFAULT: dev")
	showCmd.IntVar(&helmVersion, "helm-version", 3, "use Helm versin (default: 3)")
	showCmd.IntVar(&helmVersion, "l", 3, "use Helm versin (default: 3)")
	showCmd.StringVar(&namespace, "namespace", "", "apply namespace")
	showCmd.StringVar(&namespace, "n", "", "apply namespace")
	showCmd.StringVar(&name, "name", "", "release name")

	applyCmd := flag.NewFlagSet("apply", flag.ExitOnError)
	applyCmd.StringVar(&env, "env", "dev", "your cluster enviroument. DEFAULT: dev")
	applyCmd.StringVar(&env, "e", "dev", "your cluster enviroument. DEFAULT: dev")
	applyCmd.IntVar(&helmVersion, "helm-version", 3, "use Helm versin (default: 3)")
	applyCmd.IntVar(&helmVersion, "l", 3, "use Helm versin (default: 3)")
	applyCmd.StringVar(&namespace, "namespace", "", "apply namespace")
	applyCmd.StringVar(&namespace, "n", "", "apply namespace")
	applyCmd.StringVar(&name, "name", "", "release name")

	testCmd := flag.NewFlagSet("test", flag.ExitOnError)
	testCmd.StringVar(&env, "env", "dev", "your cluster enviroument. DEFAULT: dev")
	testCmd.StringVar(&env, "e", "dev", "your cluster enviroument. DEFAULT: dev")
	testCmd.IntVar(&helmVersion, "helm-version", 3, "use Helm versin (default: 3)")
	testCmd.IntVar(&helmVersion, "l", 3, "use Helm versin (default: 3)")
	testCmd.StringVar(&namespace, "namespace", "", "apply namespace")
	testCmd.StringVar(&namespace, "n", "", "apply namespace")
	testCmd.StringVar(&name, "name", "", "release name")

	deleteCmd := flag.NewFlagSet("delete", flag.ExitOnError)
	deleteCmd.StringVar(&env, "env", "dev", "your cluster enviroument. DEFAULT: dev")
	deleteCmd.StringVar(&env, "e", "dev", "your cluster enviroument. DEFAULT: dev")
	deleteCmd.IntVar(&helmVersion, "helm-version", 3, "use Helm versin (default: 3)")
	deleteCmd.IntVar(&helmVersion, "l", 3, "use Helm versin (default: 3)")
	deleteCmd.StringVar(&namespace, "namespace", "", "apply namespace")
	deleteCmd.StringVar(&namespace, "n", "", "apply namespace")
	deleteCmd.StringVar(&name, "name", "", "release name")

	recreateCmd := flag.NewFlagSet("recreate", flag.ExitOnError)
	recreateCmd.StringVar(&env, "env", "dev", "your cluster enviroument. DEFAULT: dev")
	recreateCmd.StringVar(&env, "e", "dev", "your cluster enviroument. DEFAULT: dev")
	recreateCmd.IntVar(&helmVersion, "helm-version", 3, "use Helm versin (default: 3)")
	recreateCmd.IntVar(&helmVersion, "l", 3, "use Helm versin (default: 3)")
	recreateCmd.StringVar(&namespace, "namespace", "", "apply namespace")
	recreateCmd.StringVar(&namespace, "n", "", "apply namespace")
	recreateCmd.StringVar(&name, "name", "", "release name")

	if len(os.Args) < 2 {
		help()
		os.Exit(1)
	}

	switch os.Args[1] {
	case "show":
		showCmd.Parse(os.Args[2:])
		tail := showCmd.Args()
		path := tail[0]
		core.Show(env, path, showCmd.Args())

	case "apply":
		applyCmd.Parse(os.Args[2:])
		tail := applyCmd.Args()
		path := tail[0]
		core.Apply(env, path, applyCmd.Args())

	case "test":
		testCmd.Parse(os.Args[2:])
		tail := testCmd.Args()
		path := tail[0]
		core.Test(env, path, testCmd.Args())

	case "delete":
		deleteCmd.Parse(os.Args[2:])
		tail := deleteCmd.Args()
		path := tail[0]
		core.Delete(env, path, deleteCmd.Args())

	case "recreate":
		recreateCmd.Parse(os.Args[2:])
		tail := recreateCmd.Args()
		path := tail[0]
		core.Recreate(env, path, recreateCmd.Args())

	default:
		fmt.Println("Undefind subcommand: ", os.Args[1])
		help()
	}
}
