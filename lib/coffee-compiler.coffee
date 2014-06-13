{ EditorView } = require 'atom'
{ compile } = require 'coffee-script'
# ids = { }

module.exports =
    activate: (state) ->
        atom.workspaceView.command "coffee-compiler:compile", => @compile()
    # deactivate: ->
    compile: ->
        @coffeeEditor = atom.workspace.getActiveEditor()
        selection = @coffeeEditor.getSelection()
        coffee = selection.getText() || @coffeeEditor.getText()
        js = compile coffee, bare: yes

        @view = new EditorView mini: true
        # @view = ids[@coffeeEditor.id] || ids[@coffeeEditor.id] = new EditorView mini: true

        @editor = @view.getEditor()

        @editor.setGrammar atom.syntax.grammarForScopeName 'source.js'
        @editor.setText js
        @pane = atom.workspaceView.getActivePane()
        @pane.addItem @editor
        @pane.activateNextItem()
    # serialize: ->
