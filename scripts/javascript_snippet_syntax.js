const CALLBACK_NAME = 'callback'

module.exports = class JavaScriptSnippetSyntax {
  constructor(snippetInterface) {
    this.snippetInterface = snippetInterface
  }

  build({ comment, generatedExpressions, functionName, stepParameterNames }) {
    let functionKeyword = 'function '
    if (this.snippetInterface === 'generator') {
      functionKeyword += '*'
    }

    let implementation
    if (this.snippetInterface === 'callback') {
      implementation = `${CALLBACK_NAME}(null, 'pending');`
    } else {
      implementation = "return 'pending';"
    }

    const definitionChoices = generatedExpressions.map(
      (generatedExpression, index) => {
        const prefix = index === 0 ? '' : '// '
        const allParameterNames = generatedExpression.parameterNames.concat(
          stepParameterNames
        )
        if (this.snippetInterface === 'callback') {
          allParameterNames.push(CALLBACK_NAME)
        }
        return (
          prefix +
          functionName +
          "('" +
          generatedExpression.source.replace(/'/g, "\\'") +
          "', " +
          functionKeyword +
          '(' +
          allParameterNames.join(', ') +
          ') {\n'
        )
      }
    )

    return (
      definitionChoices.join('') +
      `  // ${comment}\n` +
      `  ${implementation}\n` +
      '});'
    )
  }
}