# SystemD Support

## Example

```racket
(require systemd/daemon)

;; Get first passed socket.
(define-values (in out)
  (sd-port 0))

;; Signal that we are ready.
(sd-notify "READY=1")
```

Only TCP sockets are supported right now.
This is a Racket's internal API limitation.
