{exec, spawn} = require "child_process"

helpers       = require "../helpers"
{Compiler}    = require "./base"

class exports.RsyncCompiler extends Compiler
    constructor: ->
        console.log "RsyncCompiler.constructor"
        super
        @delay    = 1500
        @cmd      = "rsync"
        @cmd_args = ["-avL", @options.buildPath, @options.destination]

    matchesFile: (file) =>
        yes

    rsync: ->
        @log "spawn: #{@cmd} #{@cmd_args.join(' ')}"
        rsync = spawn(@cmd, @cmd_args)

        rsync.stderr.on "data", (data) =>
            @logError "RSYNC ERR: #{data}"

        rsync.stdout.setEncoding('utf8')
        rsync.stdout.on "data", (data) =>
            for line in data.split("\n")
                @log "RSYNC: #{line}"

        rsync.on "exit", (data) =>
            @log "RSYNC: ---------------------------------------------"
            helpers.growl "brunch -- RSYNC", "rsync complete @ #{@options.destination}"

        return rsync

    compile: (files) =>
        if @options.rsync
            proc = @rsync()
