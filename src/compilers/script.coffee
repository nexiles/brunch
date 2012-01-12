{exec, spawn} = require "child_process"

helpers       = require "../helpers"
{Compiler}    = require "./base"

class exports.RunScriptCompiler extends Compiler
    constructor: ->
        console.log "RunScriptCompiler.constructor"
        super
        console.log @options
        @delay    = 1500
        @cmd      = @options.script ? "bin/after-brunch"

    matchesFile: (file) =>
        yes

    script: (files) ->
        cmd_args = [@options.buildPath, @options.brunchPath]
        for f in files
            cmd_args.push(f)

        @log "spawn: #{@cmd} #{cmd_args.join(' ')}"
        script = spawn(@cmd, cmd_args)

        script.stderr.on "data", (data) =>
            @logError "SCRIPT ERR: #{data}"

        script.stdout.setEncoding('utf8')
        script.stdout.on "data", (data) =>
            for line in data.split("\n")
                @log "SCRIPT: #{line}"

        script.on "exit", (data) =>
            @log "SCRIPT: ---------------------------------------------"
            helpers.growl "brunch -- SCRIPT", "script complete: #{@cmd}\nRC #{data}"

        return script

    compile: (files) =>
        if @options.runscript
            proc = @script(files)
        else
            @log "script hook deactivated"
