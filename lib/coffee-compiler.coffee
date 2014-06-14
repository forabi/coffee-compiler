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

        @pane = atom.workspaceView.getActivePane()

        try
            js = compile coffee, bare: yes
        catch e
            js = e.toString()
        finally
            view = @getView()
            editor = view.getEditor()
            editor.setGrammar atom.syntax.grammarForScopeName 'source.js'
            editor.setText js
            @pane.addItem editor
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
