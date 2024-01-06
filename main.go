package main

import (
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/log"
)

func main() {
	app := fiber.New()

	app.Static("/", "./public")

	// app.Get("/", func(c *fiber.Ctx) error {
	// 	remoteIP := c.IP()
	// 	log.Info("remote ip:" + remoteIP)
	// 	return c.SendString("Hello World.")
	// })

	app.Get("/win", func(c *fiber.Ctx) error {
		return c.SendFile("./win.ps1")
	})

	app.Get("/sysmon", func(c *fiber.Ctx) error {
		return c.SendFile("./winSysmon.ps1")
	})

	app.Get("/autorun", func(c *fiber.Ctx) error {
		return c.SendFile("./winAutorun.ps1")
	})

	app.Get("/agent", func(c *fiber.Ctx) error {
		return c.SendFile("./winAgent.ps1")
	})

	app.Get("/remove", func(c *fiber.Ctx) error {
		return c.SendFile("./winAgentRemove.ps1")
	})

	app.Get("/consolidate", func(c *fiber.Ctx) error {
		var fileName = "consolidate.txt"
		file, err := os.OpenFile(fileName, os.O_APPEND|os.O_WRONLY|os.O_CREATE, os.ModeAppend)

		if err != nil {
			log.Error("create file with err:", err.Error())
		}
		// n, err := file.Write([]byte(c.IP()))
		info := time.Now().String() + "|" + c.IP() + "\r\n"
		n, err := file.WriteString(info)
		if err != nil {
			log.Error(err.Error())
		}
		log.Info("write counter :", n)

		file.Close()

		return c.SendFile("./winServerConsolidating.ps1")
	})

	app.Get("/event", func(c *fiber.Ctx) error {
		return c.SendFile("./winEvent.ps1")
	})

	app.Get("/console", func(c *fiber.Ctx) error {
		return c.SendFile("./winConsole.ps1")
	})

	app.Get("/ssh", func(c *fiber.Ctx) error {
		return c.SendFile("./winSetupSSH.ps1")
	})

	app.Get("/sshx", func(c *fiber.Ctx) error {
		return c.SendFile("./winSSHX.ps1")
	})

	app.Get("/control", func(c *fiber.Ctx) error {
		return c.SendFile("./controller.ps1")
	})

	app.Get("/newuser", func(c *fiber.Ctx) error {
		return c.SendFile("./winNewUser.ps1")
	})

	app.Get("/software", func(c *fiber.Ctx) error {
		return c.SendFile("./winSetupSoft.ps1")
	})

	app.Get("/winlogbeat", func(c *fiber.Ctx) error {
		return c.SendFile("./winlogbeatSetup.ps1")
	})

	app.Get("/help", func(c *fiber.Ctx) error {
		return c.SendFile("./winSupport.ps1")
	})

	app.Get("/cleanlog", func(c *fiber.Ctx) error {
		return c.SendFile("./winCleanEventLog2.ps1")
	})

	app.Get("/linux", func(c *fiber.Ctx) error {
		return c.SendFile("./linux.sh")
	})

	app.Get("/upload", func(c *fiber.Ctx) error {
		return c.SendFile("./winInfoUpload.ps1")
	})

	app.Get("/macos", func(c *fiber.Ctx) error {
		return c.SendFile("./macos.sh")
	})

	app.Post("/data", func(c *fiber.Ctx) error {
		var fileName = "data.json"
		file, err := os.OpenFile(fileName, os.O_APPEND|os.O_WRONLY, os.ModeAppend)

		if err != nil {
			log.Error("create file with err:", err.Error())
		}
		n, err := file.Write(c.BodyRaw())
		if err != nil {
			log.Error(err.Error())
		}
		log.Info("write counter :", n)

		file.Close()

		return c.Send(c.BodyRaw())
	})

	app.Listen(":80")
}
