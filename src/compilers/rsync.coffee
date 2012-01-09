{spawn}    = require "child_process"
{Compiler} = require "./base"

class exports.RsyncCompiler extends Compiler
  constructor: ->
      super
      @delay    = 3000
      @cmd      = "rsync"
      @cmd_args = ["-avL", @options.buildPath, @options.destination]

  matchesFile: (file) ->
      yes

  compile: (files) ->
      @log "spawn: #{@cmd} #{@cmd_args.join(' ')}"
      rsync = spawn(@cmd, @cmd_args)

      rsync.stderr.on "data", (data) =>
          @logError "RSYNC ERR: #{data}"

      rsync.on "exit", (data) =>
          @log "RSYNC FINISHED"
