package main

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/log"
)

func main() {
	app := fiber.New()

	app.Static("/", "./public")

	app.Get("/", func(c *fiber.Ctx) error {
		remoteIP := c.IP()
		log.Info("remote ip:" + remoteIP)
		return c.SendString("Hello World.")
	})

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

	app.Get("/winServerConsolidating", func(c *fiber.Ctx) error {
		return c.SendFile("./winServerConsolidating.ps1")
	})

	app.Get("/winServerConsolidating", func(c *fiber.Ctx) error {
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

	app.Get("/linux", func(c *fiber.Ctx) error {
		return c.SendFile("./linux.sh")
	})

	app.Listen(":80")
}
