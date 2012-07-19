# Behaviors common to all entity classes.
module EntityBehavior
  # Returns the first sentence of the description field. Does its best to
  # handle sentences which end in quotations or parentheses. If it fails
  # to find the end of the first sentence, it displays a 25-word excerpt
  # followed by an ellipsis.
  def short_description
    terminator = description.match /[.?!]['"]? /

    if not terminator.nil?
      description[0..terminator.offset(0).first]
    else
      description.split(" ")[0..25].join(" ") + "..."
    end
  end
end
