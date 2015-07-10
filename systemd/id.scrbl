#lang scribble/manual

@require[scribble/eval]

@require[(for-label racket)
         (for-label systemd/id)]

@title{Unique Identifiers}

@defmodule[systemd/id]

SystemD's globally unique identifiers with simple hexadecimal format can be
used anywhere the traditional uuids can. SystemD itself uses them to identify
the local device and current boot of the system.

@defproc[(sd-id? (v any/c)) boolean?]{
  Determine whether the specified value is a properly formatted SystemD
  identifier.
}

@defproc[(sd-random-id) sd-id?]{
  Generate a new, completely random globally unique identifier.
}

@defproc[(sd-machine-id) sd-id?]{
  Return the unique identifier of the local machine.
}

@defproc[(sd-boot-id) sd-id?]{
  Return the unique identifier of current boot.
}


@; vim:set ft=scribble sw=2 ts=2 et:
