# Manages automatic completions for a text field. Completions are prompted by
# the @ character. Differs from most autocompletes in that the chosen name is
# replaced by a Markdown link.
#
# @param [jQuery] field The jQuery-wrapped DOM element in which text input
# takes place.
# @param [jQuery] popup The jQuery-wrapped DOM element which will display
# possible completions.
# @param [Array] completions An array of [name, full] pairs. When a name is
# selected or tab/enter-completed, the full completion appears in its place.
class Autocomplete
  constructor: (field, popup, completions) ->
    @field = field
    @popup = popup
    @completions = completions


