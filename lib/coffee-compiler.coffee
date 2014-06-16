{ EditorView } = require 'atom'
{ compile } = require 'coffee-script'
ids = { }

module.exports =
    activate: (state) ->
        atom.workspaceView.command "coffee-compiler:compile", => @compile()
    # deactivate: ->
    compile: ->
        @coffeeEditor = atom.workspace.getActiveEditor()
        selection = @coffeeEditor.getSelection()
        coffee = selection.getText() || @coffeeEditor.getText()

        @view = @getView()
        @editor = @view.getEditor()

        try
            output = compile coffee, bare: yes
            @editor.setGrammar atom.syntax.grammarForScopeName 'source.js'
        catch e
            output = e.toString()
            @editor.setGrammar atom.syntax.grammarForScopeName 'text.plain'
        finally
            @editor.setText output
            @pane = atom.workspaceView.getActivePane()
            @pane.addItem @editor
            @pane.activateNextItem()

    getView: ->
        ids[@coffeeEditor.id] = (
            view = ids[@coffeeEditor.id]
            if view
                editor = view.getEditor()
                if not editor.isAlive() then view = new EditorView mini: yes
                view
            else new EditorView mini: yes
        )
    # serialize: ->
