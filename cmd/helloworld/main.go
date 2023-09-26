package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"renatoaraujo/helloworld/cmd/helloworld/router"
	"renatoaraujo/helloworld/pkg/logger"
	"renatoaraujo/helloworld/pkg/storage"
)

func main() {
	log := logger.NewLogger()

	s, err := storage.NewDynamoDBClient(os.Getenv("DATABASE_DSN"), os.Getenv("AWS_REGION"))
	if err != nil {
		log.Fatal("failed initialise the storage;", err)
	}

	deps := router.RouterDependencies{
		Logger:  log,
		Storage: s,
	}

	r := router.NewRouter(deps)

	server := &http.Server{
		Addr:    fmt.Sprintf(":%s", os.Getenv("SERVICE_PORT")),
		Handler: r,
	}

	go func() {
		if err := server.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			log.Fatal("failed to start server", err)
		}
	}()

	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT, syscall.SIGTERM)
	<-sig

	log.Info("shutting down the server")

	ctxShutDown, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := server.Shutdown(ctxShutDown); err != nil {
		log.Fatal("failed to gracefully shutdown the server", err)
	}

	log.Info("server exited properly")
}
